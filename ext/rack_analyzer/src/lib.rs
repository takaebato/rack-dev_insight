use magnus::{class, define_class, define_error, define_module, Error, exception, function, method, prelude::*};
use magnus::exception::standard_error;

use extractor::CrudTableExtractor;
use extractor::CrudTables;
use normalizer::Normalizer;

mod extractor;
mod normalizer;

#[magnus::init]
fn init() -> Result<(), Error> {
    let rack_module = define_module("Rack").unwrap();
    let analyzer_class = rack_module.define_class("Analyzer", Default::default()).unwrap();

    analyzer_class.define_error("Err", standard_error());

    let normalizer_module = analyzer_class.define_module("Normalizer").unwrap();
    normalizer_module.define_singleton_method("_normalize", function!(Normalizer::normalize, 2))?;

    let extractor_module = analyzer_class.define_module("Extractor").unwrap();
    let crud_tables_class = extractor_module.define_class("CrudTables", class::object()).unwrap();
    crud_tables_class.define_singleton_method("_extract", function!(CrudTableExtractor::extract, 2))?;
    crud_tables_class.define_method("_create_tables", method!(CrudTables::create_tables, 0))?;
    crud_tables_class.define_method("_read_tables", method!(CrudTables::read_tables, 0))?;
    crud_tables_class.define_method("_update_tables", method!(CrudTables::update_tables, 0))?;
    crud_tables_class.define_method("_delete_tables", method!(CrudTables::delete_tables, 0))?;
    Ok(())
}
