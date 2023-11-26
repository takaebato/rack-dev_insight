use magnus::{class, exception::ExceptionClass, prelude::*, value::Lazy, RClass, RModule};

// define module Rack
pub static RACK: Lazy<RModule> = Lazy::new(|ruby| ruby.define_module("Rack").unwrap());

// define class Rack::DevInsight
pub static DEV_INSIGHT: Lazy<RClass> = Lazy::new(|ruby| {
    ruby.get_inner(&RACK)
        .define_class("DevInsight", class::object())
        .unwrap()
});

// define class Rack::DevInsight::Error < StandardError
pub static ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&DEV_INSIGHT)
        .define_error("Error", ruby.exception_standard_error())
        .unwrap()
});

// define class Rack::DevInsight::ExtError < Rack::DevInsight::Error
pub static EXT_ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&DEV_INSIGHT)
        .define_error("ExtError", ruby.get_inner(&ERROR))
        .unwrap()
});

// define class Rack::DevInsight::ParserError < Rack::DevInsight::ExtError
pub static PARSER_ERROR: Lazy<ExceptionClass> = Lazy::new(|ruby| {
    ruby.get_inner(&DEV_INSIGHT)
        .define_error("ParserError", ruby.get_inner(&EXT_ERROR))
        .unwrap()
});
