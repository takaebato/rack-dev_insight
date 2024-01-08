## Installation Guide for Rust Extension

There are two options to install the Rust extension. Choose the one best suited for your platform.

### Option 1: Install Precompiled Gems (Recommended)

Precompiled gems more reliable and simplify the installation process.
They are available for these platforms:

```
arm-linux
aarch64-linux
arm64-darwin
x64-mingw-ucrt
x64-mingw32
x86_64-darwin
x86_64-linux
x86_64-linux-musl
```

#### Steps:

1. Add your platform to the gem lockfile. For instance, for x86_64-linux:

```
bundle lock --add-platform x86_64-linux
```

2. Ensure force_ruby_platform is not set to true in the bundle config.
   For more details, visit [Bundler's documentation]((https://bundler.io/v2.5/man/bundle-lock.1.html#SUPPORTING-OTHER-PLATFORMS)).

### Option 2: Build on Your Machine

If precompiled gems are not available for your platform, you can build from source. This requires Rust and Clang to be installed.

#### Install Rust

For macOS, Linux, or another Unix-like OS:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

For Windows, visit [rust-lang.org](https://forge.rust-lang.org/infra/other-installation-methods.html#other-ways-to-install-rustup) for instructions.

#### Install Clang

Clang is required in [bindgen](https://github.com/rust-lang/rust-bindgen).

For example, for Debian-based Linux distributions:

```sh
apt install llvm-dev libclang-dev clang
```

For other OS, see [instruction in bindgen](https://rust-lang.github.io/rust-bindgen/requirements.html).

If you encounter any troubles during the installation or have any questions, please feel free to reach out.  
You can open an issue here on GitHub or contact us directly. We welcome your feedback and are happy to assist!
