use std::ops::ControlFlow;

use magnus::Error;
use sqlparser::ast::{Expr, VisitMut, VisitorMut};
use sqlparser::ast::Value::Placeholder;
use sqlparser::dialect::{Dialect, dialect_from_str, GenericDialect};
use sqlparser::parser::Parser;

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
    pub fn normalize(dialect_name: String, subject: String) -> Result<String, Error> {
        let mut statements = match dialect_from_str(dialect_name) {
            Some(dialect) => {
                match Parser::parse_sql(dialect.as_ref(), &subject) {
                    Ok(statements) => statements,
                    Err(_error) => return Err(Error::new(magnus::exception::arg_error(), "expected string"))
                }
            }
            None => return Err(Error::new(magnus::exception::arg_error(), "expected string"))
        };
        statements.visit(&mut Self);
        Ok(statements[0].to_string())
    }
}

#[test]
fn it_works() {
    let sql = "SELECT a, b FROM `table_a` WHERE a IN (SELECT x FROM table_b) AND b = 'tmp'";
    match Normalizer::normalize(String::from("mysql"), sql.into()) {
        Ok(result) => assert_eq!(result, "SELECT a, b FROM `table_a` WHERE a IN (SELECT x FROM table_b) AND b = ?"),
        Err(_) => assert!(false),
    }
    // assert_eq!(Normalizer::normalize(String::from("mysql"), sql.into()), "SELECT a, b FROM `table_a` WHERE a IN (SELECT x FROM table_b) AND b = ?");
}

