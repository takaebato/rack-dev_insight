use magnus::{define_module, Error, function, prelude::*};

use normalizer::Normalizer;

mod normalizer;

#[magnus::init]
fn init() -> Result<(), Error> {
    let module = define_module("Normalizer")?;
    module.define_singleton_method("normalize", function!(Normalizer::normalize, 1))?;
    Ok(())
}
