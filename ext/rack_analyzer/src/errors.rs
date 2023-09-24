use magnus::{exception::ExceptionClass, prelude::*, value::Lazy, RModule, class, RClass};

pub static RACK: Lazy<RModule> = Lazy::new(|ruby| {
    ruby.define_module("Rack")
        .unwrap()
});

pub static ANALYZER: Lazy<RClass> = Lazy::new(|ruby| {
    ruby.get_inner(&RACK)
        .define_class("Analyzer", class::object())
        .unwrap()
});

pub static ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&ANALYZER)
        .define_error("Error", ruby.exception_standard_error())
        .unwrap()
});

pub static EXT_ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&ANALYZER)
        .define_error("ExtError", ruby.get_inner(&ERROR))
        .unwrap()
});

pub static PARSER_ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&ANALYZER)
        .define_error("ParserError", ruby.get_inner(&EXT_ERROR))
        .unwrap()
});
