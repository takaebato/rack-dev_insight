use std::ops::ControlFlow;

use sqlparser::ast::{Expr, VisitMut, VisitorMut};
use sqlparser::ast::Value::Placeholder;
use sqlparser::dialect::GenericDialect;
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
    pub fn normalize(subject: String) -> String {
        let mut statements = Parser::parse_sql(&GenericDialect {}, &subject).unwrap();
        statements.visit(&mut Self);
        statements[0].to_string()
    }
}

#[test]
fn it_works() {
    let sql = "SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = 'tmp'";
    assert_eq!(Normalizer::normalize(sql.into()), "SELECT a, b FROM table_a WHERE a IN (SELECT x FROM table_b) AND b = ?");
}

