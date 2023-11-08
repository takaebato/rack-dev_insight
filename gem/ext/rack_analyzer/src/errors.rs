use magnus::{exception::ExceptionClass, prelude::*, value::Lazy, RModule, class, RClass};

// define module Rack
pub static RACK: Lazy<RModule> = Lazy::new(|ruby| {
    ruby.define_module("Rack")
        .unwrap()
});

// define class Rack::Analyzer
pub static ANALYZER: Lazy<RClass> = Lazy::new(|ruby| {
    ruby.get_inner(&RACK)
        .define_class("Analyzer", class::object())
        .unwrap()
});

// define class Rack::Analyzer::Error < StandardError
pub static ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&ANALYZER)
        .define_error("Error", ruby.exception_standard_error())
        .unwrap()
});

// define class Rack::Analyzer::ExtError < Rack::Analyzer::Error
pub static EXT_ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&ANALYZER)
        .define_error("ExtError", ruby.get_inner(&ERROR))
        .unwrap()
});

// define class Rack::Analyzer::ParserError < Rack::Analyzer::ExtError
pub static PARSER_ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&ANALYZER)
        .define_error("ParserError", ruby.get_inner(&EXT_ERROR))
        .unwrap()
});
