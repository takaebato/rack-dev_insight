ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

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

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY lib/rack/analyzer/version.rb /app/lib/rack/analyzer/version.rb
COPY rack-analyzer.gemspec /app/rack-analyzer.gemspec

WORKDIR /app
RUN gem update --system
RUN bundle update --bundler
RUN bundle install
