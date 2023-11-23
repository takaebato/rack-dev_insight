use std::ops::ControlFlow;

use magnus::{Error, exception, Ruby};
use sqlparser::ast::{Expr, VisitMut, VisitorMut};
use sqlparser::ast::Value::Placeholder;
use sqlparser::dialect::dialect_from_str;
use sqlparser::parser::Parser;
use crate::errors::{PARSER_ERROR};

pub struct Normalizer;

impl VisitorMut for Normalizer {
    type Break = ();

    fn post_visit_expr(&mut self, expr: &mut Expr) -> ControlFlow<Self::Break> {
        if let Expr::Value(value) = expr {
            *value = Placeholder("?".into());
        }
        ControlFlow::Continue(())
    }
}

impl Normalizer {
    pub fn normalize(ruby: &Ruby, dialect_name: String, subject: String) -> Result<String, Error> {
        let mut statements = match dialect_from_str(&dialect_name) {
            Some(dialect) => {
                match Parser::parse_sql(dialect.as_ref(), &subject) {
                    Ok(statements) => statements,
                    Err(error) => return Err(Error::new(ruby.get_inner(&PARSER_ERROR), error.to_string()))
                }
            }
            None => return Err(Error::new(exception::arg_error(), format!("Dialect not found {}", dialect_name)))
        };
        statements.visit(&mut Self);
        Ok(statements[0].to_string())
    }
}

// Thorough tests are written in Ruby. Basic cases are here for sanity check and to help debug.
#[cfg(test)]
mod tests {
    use super::*;
    use rb_sys_test_helpers::with_ruby_vm;

    #[test]
    fn test_correct_sql() {
        with_ruby_vm(|| {
            let ruby = Ruby::get().unwrap();
            let sql = "SELECT a FROM1 WHERE b = 1 AND c in (2, 3) AND d LIKE '%foo";
            match Normalizer::normalize(&ruby, String::from("mysql"), sql.into()) {
                Ok(result) => assert_eq!(result, "SELECT a FROM t1 WHERE b = ? AND c IN (?, ?) AND d LIKE ?"),
                Err(error) => assert!(false, "Should not have errored. Error: {}", error)
            }
        }).unwrap();
    }

    #[test]
    fn test_incorrect_sql() {
        with_ruby_vm(|| {
            let ruby = Ruby::get().unwrap();
            let invalid_sql = "SELECT a FROM t1 WHERE b = 1 WHERE c in (2, 3)";
            match Normalizer::normalize(&ruby, String::from("mysql"), invalid_sql.into()) {
                Ok(_) => assert!(false, "Should have errored"),
                Err(error) => assert!(error.is_kind_of(ruby.get_inner(&PARSER_ERROR)))
            }
        }).unwrap();
    }
}
