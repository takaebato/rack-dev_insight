ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

# Install Rust
ENV RUST_HOME /usr/local/lib/rust
ENV RUSTUP_HOME ${RUST_HOME}/rustup
ENV CARGO_HOME ${RUST_HOME}/cargo
RUN mkdir /usr/local/lib/rust \
    && chmod 0755 $RUST_HOME
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > ${RUST_HOME}/rustup.sh \
    && chmod +x ${RUST_HOME}/rustup.sh \
    && ${RUST_HOME}/rustup.sh -y
ENV PATH $PATH:$CARGO_HOME/bin

RUN apt update
RUN apt install libclang-dev -y

RUN gem update --system
WORKDIR /app
