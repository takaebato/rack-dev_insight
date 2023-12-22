# Contributing to rack-dev_insight

## Introduction

Thank you for your interest in contributing to our project.
This document provides guidelines for contributing to the project.

## Development

After fork and clone this repository, you can start development by following the steps below.

### Gem

#### Setup

1. Move into the `gem` directory.
2. Run `docker compose up -d ruby-rust`.
3. Run `docker compose exec ruby-rust bundle exec rake compile` to compile the Rust extension.

#### Testing

1. Run `docker compose exec ruby-rust bundle exec appraisal install` to install the dependencies for each appraisal.
2. Run `docker compose exec ruby-rust bundle exec appraisal rake spec` to run each appraisal.
3. Run `docker compose exec ruby-rust cargo test` to test rust extension code.

#### Linting

1. Run `docker compose exec ruby-rust bundle exec rake fix` to run rubocop and syntax tree format.
2. Run `docker compose exec ruby-rust cargo fix --allow-no-vcs` to fix rust compiler warnings.
3. Run `docker compose exec ruby-rust cargo fmt` to format rust code.
4. Run `docker compose exec ruby-rust cargo clippy --fix --allow-no-vcs` to run clippy.

### Chrome Extension

#### Setup

1. Move into the `extension` directory.
2. Run `npm install` to install dependencies.
3. Run `npm run dev` to run the development server.
4. Open `chrome://extensions` in Chrome and enable developer mode.
5. Click the "Load unpacked" button and select the `extension/dist` directory.
6. Open chrome devtools and find 'RackDevInsight' tab.

#### Linting

1. Run `npm run fix` to run eslint.

#### Reflect openapi.yml changes to Schema

1. Run `npm run buildSchema`to generate `src/api/Api.ts` from `openapi.yml`.

### Debugging and Functionality check

#### Use Prism Mock Server for chrome extension development

1. Move into the `openapi` directory.
2. Run `docker compose up -d` to start prism mock server (and redoc ui server).
3. In `extension/src/components/DevtoolsPanel.svelte`, import `fetchResultDebug` from `src/api/Api.ts` and change `await fetchResult(request)` to `await fetchResultDebug(request)`.
4. Initiate a request in any web page, then a request to the mock server will be sent as a hook of the request.
5. The response of the mock server will be displayed in the devtools panel.

#### Use dummy rails application for fullstack development

1. Run `bundle exec rake dummy_app:rails:setup` to setup dummy rails application.
2. User resource is created by scaffold, so you can access `http://localhost:3000/users` to initiate requests.
3. To reflect file changes of the gem, run `docker compose restart dummy-app-rails`.
4. Code snippets for making various HTTP requests and SQL queries are available in `gem/tasks/dummy_app/template_files/snippet.rb`.

## How to Submit a Contribution

1. Create a new branch for your contribution.
2. Make your changes and commit them with descriptive commit messages.
3. Push your changes to your fork and submit a pull request to the main repository.
4. Describe your changes in detail in the pull request description.
