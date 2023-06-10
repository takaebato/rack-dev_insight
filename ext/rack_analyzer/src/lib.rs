use magnus::{define_module, Error, function, prelude::*};

use extractor::CrudTableExtractor;
use normalizer::Normalizer;

mod extractor;
mod normalizer;

#[magnus::init]
fn init() -> Result<(), Error> {
    let module = define_module("Normalizer")?;
    module.define_singleton_method("normalize", function!(Normalizer::normalize, 1))?;
    let module = define_module("Extractor")?;
    module.define_singleton_method("extract_crud_tables", function!(CrudTableExtractor::extract, 1))?;
    Ok(())
}
