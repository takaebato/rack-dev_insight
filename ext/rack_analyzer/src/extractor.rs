use std::collections::{HashMap, HashSet};
use std::ops::ControlFlow;

use sqlparser::ast::{ObjectName, Statement, Visit, Visitor};
use sqlparser::ast::TableFactor::Table;
use sqlparser::dialect::GenericDialect;
use sqlparser::parser::Parser;
use tap::Tap;

#[derive(Default, Debug)]
pub struct CrudTableExtractor {
    create_tables: HashSet<String>,
    read_tables: HashSet<String>,
    update_tables: HashSet<String>,
    delete_tables: HashSet<String>,
}

impl Visitor for CrudTableExtractor {
    type Break = ();

    fn pre_visit_relation(&mut self, relation: &ObjectName) -> ControlFlow<Self::Break> {
        self.read_tables.insert(relation.0[0].value.clone());
        ControlFlow::Continue(())
    }

    fn pre_visit_statement(&mut self, statement: &Statement) -> ControlFlow<Self::Break> {
        match statement {
            Statement::Insert {
                table_name,
                ..
            } => {
                self.create_tables.insert(table_name.0[0].value.clone());
            }
            Statement::Update {
                table,
                ..
            } => {
                if let Table {
                    name,
                    ..
                } = &table.relation {
                    self.update_tables.insert(name.0[0].value.clone());
                }
            }
            Statement::Delete {
                tables,
                from,
                ..
            } => {
                if !tables.is_empty() {
                    for obj_name in tables {
                        self.delete_tables.insert(obj_name.0[0].value.clone());
                    }
                } else {
                    for table_with_joins in from {
                        if let Table {
                            name,
                            ..
                        } = &table_with_joins.relation {
                            self.delete_tables.insert(name.0[0].value.clone());
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
    pub fn extract(subject: String) -> HashMap<String, Vec<String>> {
        let statements = Parser::parse_sql(&GenericDialect {}, &subject).unwrap();
        let mut visitor = CrudTableExtractor::default();
        statements.visit(&mut visitor);
        HashMap::from([
            ("create_tables".into(), Vec::from_iter(visitor.create_tables).tap_mut(|vec| vec.sort())),
            ("read_tables".into(), Vec::from_iter(visitor.read_tables).tap_mut(|vec| vec.sort())),
            ("update_tables".into(), Vec::from_iter(visitor.update_tables).tap_mut(|vec| vec.sort())),
            ("delete_tables".into(), Vec::from_iter(visitor.delete_tables).tap_mut(|vec| vec.sort())),
        ])
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_select_statement() {
        let sql = "SELECT a FROM t1 join t2 on t1.id = t2.t1_id WHERE b IN (SELECT c FROM t3)";
        let res = CrudTableExtractor::extract(sql.into());
        assert_eq!(res,
                   HashMap::from([
                       ("create_tables".into(), vec![]),
                       ("read_tables".into(), vec!["t1".to_string(), "t2".to_string(), "t3".to_string()]),
                       ("update_tables".into(), vec![]),
                       ("delete_tables".into(), vec![])
                   ]));
    }

    #[test]
    fn test_insert_statement() {
        let sql = "INSERT INTO t1 (col1, col2) VALUES(15, col1*2);";
        let res = CrudTableExtractor::extract(sql.into());
        assert_eq!(res,
                   HashMap::from([
                       ("create_tables".into(), vec!["t1".to_string()]),
                       ("read_tables".into(), vec!["t1".to_string()]),
                       ("update_tables".into(), vec![]),
                       ("delete_tables".into(), vec![])
                   ]));
    }

    #[test]
    fn test_update_statement() {
        let sql = "UPDATE t1 join t2 SET t1.title = 'new title' WHERE t2.id = 1;";
        let res = CrudTableExtractor::extract(sql.into());
        assert_eq!(res,
                   HashMap::from([
                       ("create_tables".into(), vec![]),
                       ("read_tables".into(), vec!["t1".to_string(), "t2".to_string()]),
                       ("update_tables".into(), vec!["t1".to_string()]),
                       ("delete_tables".into(), vec![])
                   ]));
    }

    #[test]
    fn test_delete_statement() {
        let sql = "DELETE FROM t1";
        let res = CrudTableExtractor::extract(sql.into());
        assert_eq!(res,
                   HashMap::from([
                       ("create_tables".into(), vec![]),
                       ("read_tables".into(), vec!["t1".to_string()]),
                       ("update_tables".into(), vec![]),
                       ("delete_tables".into(), vec!["t1".to_string()])
                   ]));

        let sql = "DELETE t1, t2 FROM t1 INNER JOIN t2 INNER JOIN t3 WHERE t1.id = t2.t1_id AND t2.id = t3.t2_id;";
        let res = CrudTableExtractor::extract(sql.into());
        assert_eq!(res,
                   HashMap::from([
                       ("create_tables".into(), vec![]),
                       ("read_tables".into(), vec!["t1".to_string(), "t2".to_string(), "t3".to_string()]),
                       ("update_tables".into(), vec![]),
                       ("delete_tables".into(), vec!["t1".to_string(), "t2".to_string()])
                   ]));

        let sql = "DELETE FROM t1, t2 USING t1 INNER JOIN t2 INNER JOIN t3 WHERE t1.id = t2.t1_id AND t2.id = t3.t2_id;";
        let res = CrudTableExtractor::extract(sql.into());
        assert_eq!(res,
                   HashMap::from([
                       ("create_tables".into(), vec![]),
                       ("read_tables".into(), vec!["t1".to_string(), "t2".to_string(), "t3".to_string()]),
                       ("update_tables".into(), vec![]),
                       ("delete_tables".into(), vec!["t1".to_string(), "t2".to_string()])
                   ]));
    }
}
