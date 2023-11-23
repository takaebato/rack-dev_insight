use std::collections::HashMap;
use std::ops::ControlFlow;

use magnus::{Error, Ruby};
use sqlparser::ast::{Statement, TableFactor, Visit, Visitor};
use sqlparser::ast::TableFactor::Table;
use sqlparser::dialect::{dialect_from_str};
use sqlparser::parser::Parser;
use tap::Tap;
use crate::errors::PARSER_ERROR;

#[derive(Default, Debug, PartialEq)]
#[magnus::wrap(class = "Rack::DevInsight::Extractor::CrudTables")]
pub struct CrudTables {
    create_tables: Vec<String>,
    read_tables: Vec<String>,
    update_tables: Vec<String>,
    delete_tables: Vec<String>,
}

impl CrudTables {
    pub fn create_tables(&self) -> Vec<String> { self.create_tables.clone() }
    pub fn read_tables(&self) -> Vec<String> { self.read_tables.clone() }
    pub fn update_tables(&self) -> Vec<String> { self.update_tables.clone() }
    pub fn delete_tables(&self) -> Vec<String> { self.delete_tables.clone() }
}

#[derive(Default, Debug)]
pub struct CrudTableExtractor {
    create_tables: Vec<String>,
    read_tables: Vec<String>,
    update_tables: Vec<String>,
    delete_tables: Vec<String>,
    aliases: HashMap<String, String>,
    to_subtract_from_read: Vec<String>,
}

impl Visitor for CrudTableExtractor {
    type Break = ();

    fn pre_visit_table_factor(&mut self, table_factor: &TableFactor) -> ControlFlow<Self::Break> {
        match table_factor {
            Table {
                name,
                alias,
                ..
            } => {
                self.read_tables.push(name.0[0].value.clone());
                if let Some(alias) = alias {
                    self.aliases.insert(alias.name.value.clone(), name.0[0].value.clone());
                }
            }
            _ => {}
        }
        ControlFlow::Continue(())
    }

    fn pre_visit_statement(&mut self, statement: &Statement) -> ControlFlow<Self::Break> {
        match statement {
            Statement::Insert {
                table_name,
                ..
            } => {
                self.create_tables.push(table_name.0[0].value.clone());
                self.to_subtract_from_read.push(table_name.0[0].value.clone());
            }
            Statement::Update {
                table,
                ..
            } => {
                if let Table {
                    name,
                    ..
                } = &table.relation {
                    self.update_tables.push(name.0[0].value.clone());
                    self.to_subtract_from_read.push(name.0[0].value.clone());
                }
            }
            Statement::Delete {
                tables,
                from,
                using,
                ..
            } => {
                if !tables.is_empty() {
                    for obj_name in tables {
                        self.delete_tables.push(obj_name.0[0].value.clone());
                        self.to_subtract_from_read.push(obj_name.0[0].value.clone());
                    }
                } else {
                    for table_with_joins in from {
                        if let Table {
                            name,
                            ..
                        } = &table_with_joins.relation {
                            self.delete_tables.push(name.0[0].value.clone());
                            self.to_subtract_from_read.push(name.0[0].value.clone());
                            // subtract again since using contains the same table
                            if using.is_some() {
                                self.to_subtract_from_read.push(name.0[0].value.clone());
                            }
                        }
                    }
                }
            }
            _ => {}
        }
        ControlFlow::Continue(())
    }
}

impl CrudTableExtractor {
    pub fn extract(ruby: &Ruby, dialect_name: String, subject: String) -> Result<CrudTables, Error> {
        let mut statements = match dialect_from_str(dialect_name) {
            Some(dialect) => {
                match Parser::parse_sql(dialect.as_ref(), &subject) {
                    Ok(statements) => statements,
                    Err(error) => return Err(Error::new(ruby.get_inner(&PARSER_ERROR), error.to_string()))
                }
            }
            None => return Err(Error::new(magnus::exception::arg_error(), "Dialect not found"))
        };
        let mut visitor = CrudTableExtractor::default();
        statements.visit(&mut visitor);
        let create_tables = visitor.convert_alias_to_original(visitor.create_tables.clone()).tap_mut(|vec| vec.sort());
        let read_tables = visitor.convert_alias_to_original(visitor.read_tables.clone()).tap_mut(|vec| vec.sort());
        let update_tables = visitor.convert_alias_to_original(visitor.update_tables.clone()).tap_mut(|vec| vec.sort());
        let delete_tables = visitor.convert_alias_to_original(visitor.delete_tables.clone()).tap_mut(|vec| vec.sort());
        Ok(CrudTables {
            read_tables: visitor.subtract(read_tables, visitor.convert_alias_to_original(visitor.to_subtract_from_read.clone())),
            create_tables,
            update_tables,
            delete_tables,
        })
    }

    fn convert_alias_to_original(&self, tables: Vec<String>) -> Vec<String> {
        tables.into_iter().map(|table| {
            if let Some(original) = self.aliases.get(&table) {
                original.clone()
            } else {
                table
            }
        }).collect()
    }

    fn subtract(&self, read_tables: Vec<String>, mut to_subtracts: Vec<String>) -> Vec<String> {
        read_tables.into_iter().filter(|read| {
            if let Some(pos) = to_subtracts.iter().position(|sub| sub == read) {
                to_subtracts.remove(pos);
                false
            } else {
                true
            }
        }).collect()
    }
}


// Thorough tests are written in Ruby. Basic cases are here for sanity check and to help debug.
#[cfg(test)]
mod tests {
    use indoc::indoc;
    use super::*;
    use rb_sys_test_helpers::with_ruby_vm;

    #[test]
    fn test_select_statement() {
        with_ruby_vm(|| {
            let ruby = Ruby::get().unwrap();
            let sql = indoc! {" \
                SELECT a \
                FROM t1 \
                INNER JOIN t2 ON t1.b = t2.b \
                WHERE c IN ( \
                    SELECT c \
                    FROM t3 \
                    WHERE d = 1 \
                ) \
            "};
            match CrudTableExtractor::extract(&ruby, String::from("mysql"), sql.into()) {
                Ok(result) => assert_eq!(result, CrudTables {
                    create_tables: vec![],
                    read_tables: vec!["t1".to_string(), "t2".to_string(), "t3".to_string()],
                    update_tables: vec![],
                    delete_tables: vec![],
                }),
                Err(error) => assert!(false, "Should not have errored. Error: {}", error)
            }
        }).unwrap()
    }

    #[test]
    fn test_insert_statement() {
        with_ruby_vm(|| {
            let ruby = Ruby::get().unwrap();
            let sql = indoc! {" \
                INSERT INTO t1 (a, b) \
                SELECT t2_alias.a, t2_alias.b \
                FROM t2 t2_alias \
                INNER JOIN t3 t3_alias ON t2_alias.c = t3_alias.c \
                WHERE t3_alias.d IN ( \
                    SELECT d \
                    FROM t4 \
                    WHERE e = 1 \
                ) \
            "};
            match CrudTableExtractor::extract(&ruby, String::from("mysql"), sql.into()) {
                Ok(result) => assert_eq!(result, CrudTables {
                    create_tables: vec!["t1".to_string()],
                    read_tables: vec!["t2".to_string(), "t3".to_string(), "t4".to_string()],
                    update_tables: vec![],
                    delete_tables: vec![],
                }),
                Err(error) => assert!(false, "Should not have errored. Error: {}", error)
            }
        }).unwrap()
    }

    #[test]
    fn test_update_statement() {
        with_ruby_vm(|| {
            let ruby = Ruby::get().unwrap();
            let sql = indoc! {"\
                UPDATE t1
                JOIN t2 ON t1.a = t2.a
                JOIN t3 ON t2.a = t3.a
                LEFT JOIN t4 ON t1.d = t4.a
                SET t1.b = t2.b, t1.c = t3.c
                WHERE t4.b = 1
                AND t2.e = 2
                AND t3.f = 3
            "};
            match CrudTableExtractor::extract(&ruby, String::from("mysql"), sql.into()) {
                Ok(result) => assert_eq!(result, CrudTables {
                    create_tables: vec![],
                    read_tables: vec!["t2".to_string(), "t3".to_string(), "t4".to_string()],
                    update_tables: vec!["t1".to_string()],
                    delete_tables: vec![],
                }),
                Err(error) => assert!(false, "Should not have errored. Error: {}", error)
            }
        }).unwrap()
    }

    #[test]
    fn test_delete_statement() {
        with_ruby_vm(|| {
            let ruby = Ruby::get().unwrap();
            let sql = indoc! {" \
                DELETE t1_alias, t2_alias \
                FROM t1 AS t1_alias \
                INNER JOIN t2 AS t2_alias ON t1_alias.a = t2_alias.a \
                WHERE t1.b IN ( \
                    SELECT b \
                    FROM t3 \
                    WHERE c = 1 \
                ) \
            "};
            match CrudTableExtractor::extract(&ruby, String::from("mysql"), sql.into()) {
                Ok(result) => assert_eq!(result, CrudTables {
                    create_tables: vec![],
                    read_tables: vec!["t3".to_string()],
                    update_tables: vec![],
                    delete_tables: vec!["t1".to_string(), "t2".to_string()],
                }),
                Err(error) => assert!(false, "Should not have errored. Error: {}", error)
            }
        }).unwrap()
    }

    #[test]
    fn test_invalid_sql() {
        with_ruby_vm(|| {
            let ruby = Ruby::get().unwrap();
            let sql = "SELECT a FROM t1 WHERE b = 1 WHERE c in (2, 3";
            match CrudTableExtractor::extract(&ruby, String::from("mysql"), sql.into()) {
                Ok(_) => assert!(false, "Should have errored"),
                Err(error) => assert!(error.is_kind_of(ruby.get_inner(&PARSER_ERROR)))
            }
        }).unwrap()
    }
}
