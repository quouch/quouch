[![Ruby on Rails CI](https://github.com/quouch/quouch/actions/workflows/pr-check.yml/badge.svg)](https://github.com/quouch/quouch/actions/workflows/pr-check.yml)
[![System Tests](https://github.com/quouch/quouch/actions/workflows/system-tests.yml/badge.svg)](https://github.com/quouch/quouch/actions/workflows/system-tests.yml)
[![Sentry Badge](https://img.shields.io/badge/Sentry-362D59?logo=sentry&logoColor=fff&style=for-the-badge)](https://quouch.sentry.io)
[![Heroku](https://img.shields.io/badge/heroku-%23430098.svg?style=for-the-badge&logo=heroku&logoColor=white)](https://dashboard.heroku.com/apps/quouch)

# Quouch

Booking app for homestay from queer & female perspective.

## Table of Contents

1. [Getting started](#1-getting-started)
   1. [Prerequisites](#11-prerequisites)
   2. [Installation](#12-installation)
   3. [Optional: Creating mock data for your local database](#13-optional-creating-mock-data-for-your-local-database)
2. [Developing](#2-developing)
   1. [IDEs](#21-ides)
      1. [Browser-based IDE](#want-to-use-a-browser-based-ide)
3. [Deployment](#3-deployment)
   1. [Heroku](#31-heroku)
   2. [PR Reviews](#32-pr-reviews)
4. [Tooling](#4-tooling)

   1. [Docker](#41-docker)
   2. [Running tests](#42-running-tests)
   3. [Linting](#43-linting)
   4. [Formatting](#44-formatting)
   5. [Monitoring](#45-monitoring)

5. [Troubleshooting](#troubleshooting)

## 1. Getting started

### 1.1. Prerequisites

- Ruby v3.1.2 (recommendation: [use `rbenv`](https://github.com/rbenv/rbenv))
- PostgreSQL v15+ or Docker if you prefer [see Docker section](#31-docker)

### 1.2. Installation

1. Clone the repository

   ```bash
   gh repo clone lisbethpurrucker/quouch
   ```

2. Create the `master.key` file and add the key provided by Liz

   ```bash
   touch config/master.key
   ```

3. Create your .env file and replace the values with your own credentials.

   ```bash
   cp .env.example .env
   ```

4. Install dependencies

   ```bash
   bundle install
   ```

5. Create the database

   ```bash
   rails db:setup
   ```

6. Start the server

   ```bash
   rails s
   ```

7. Visit `http://localhost:3000` in your browser. You can login with the credential provided in your `.env` file

It is recommended to complete your profile at this point, as the app is still in development and there might be errors
if you try to access certain pages without a complete profile. You can do it by
visiting [your profile](http://localhost:3000/users/edit).

### 1.3. [Optional] Creating mock data for your local database

If you want to create mock data for your local database, you can run the following command:

```bash
rails dev:populate
```

This will create:

- 30 new users with random data

Need more mock data? Try running `rails dev:test_booking` or `rails dev:test_plans` for creating fake bookings or
subscription plans for the default user.

## 2. Developing

### 2.1 IDEs

Feel free to use whichever IDE you like! Our configuration is IDE agnostic and rubocop handles all of the code styling,
so as long as you're running rubocop before committing, you should be good!

#### Want to use a browser-based IDE?

> Gitpod is a cloud development environment for teams to efficiently and securely develop software.

This repository contains configuration files to get started with in GitPod with very little effort! Try it out:
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/lisbethpurrucker/quouch)

Please note that the build/serving of the app will fail until you add the master key to the repository. You can do this
by either following steps 2 and 3 from [the installation guide](#12-installation) or by adding an environment variable
to GitPod called `RAILS_MASTER_KEY`.

## 3. Deployment

### 3.1 Heroku

We use Heroku to deploy the application. You can access the Heroku dashboard by clicking on the Heroku badge or
[here](https://dashboard.heroku.com/apps/quouch). Credentials are shared via 1Password.

The production environment has its own set of credentials, which are stored in `config/credentials/production.yml.enc`.
For editing this file you will need a `config/credentials/production.key` file. The key is shared via 1Password.
You can edit the credentials by running:

```bash
EDITOR=vim rails credentials:edit --environment production
```

> Hint: Remember to add the credentials to the default environment as well, so the application can run locally.
> Use `EDITOR=vim rails credentials:edit`

### 3.2 PR Reviews

We use Review Apps to deploy PRs to Heroku. You can access the Review Apps by
clicking [here](https://dashboard.heroku.com/pipelines/705ba305-d184-46a5-b02e-950dbda23979).
Review Apps use the `staging` environment, which uses the default credentials and the `master.key`.

## 4. Tooling

### 4.1 Docker

If you prefer using Docker instead of installing PostgreSQL locally, you can run:

```bash
docker compose -f .devcontainer/docker-compose.yml up db -d
```

> What does this do? Docker compose is used to manage multi container apps. `-f` is used to determine which file will be
> used. `up` is the command for starting containers, `db` is the container we want to start. `-d` means it runs in
> detached mode.

### 4.2 Running tests

Running all tests is pretty simple, it only needs this command: `rails test`. This command does not run System Tests.
For that, you need to run `rails test:system`.

> Running tests after `dev:populate` might result in unexpected test failures. Tests expect the DB to be empty!

However, it's a good idea to run tests in the testing environment, so your development environment doesn't get polluted
or deleted.

Some tests are marked as slow and are not run by default. To run all tests, including slow tests, you can run the
following
command:

```bash
SLOW_TESTS=true rails test
```

#### 4.2.1 Running tests in `test` environment

1. Create and setup the test database:
   ```bash
   RAILS_ENV=test rails db:setup
   ```
2. Run the tests, you can use the following command:
   ```bash
   RAILS_ENV=test rails test
   ```

#### 4.2.2 Running specific tests

If you want to run the tests in a specific file, you can use the following command:

```bash
rails test test/models/user_test.rb
```

For running only one test, indicate the line number:

```bash
rails test test/models/user_test.rb:49
```

And for running only one directory:

```bash
rails test test/models
```

#### 4.2.3 Running system tests

System tests are used to test the application from the user's perspective. You can run system tests with the following
command:

```bash
rails system
```

You can also run systems tests for predefined screen sizes and devices:

```bash
rails system:ios
rails system:android
```

If you want more granularity, you can use the following options as environment variables:

- `SCREEN_TYPE` (default: `hd`) - available
  options: `4k`, `full_hd`, `hd`, `sxga`, `xga`, `iphone_se`, `iphone_12_pro`, `pixel7`, `galaxy`
- `MOBILE` (default: `false`) - available options: `true`, `false`

For example, to run system tests for an iPhone 12 Pro, you can run the following command:

```bash
SCREEN_TYPE=iphone_12_pro MOBILE=true rails test:system
```

To run system tests headless (without the browser opening), you can use the following command:

```bash
CI=true rails system [options]
```

#### 4.2.3 Code Coverage

We use [SimpleCov](https://github.com/simplecov-ruby/simplecov) to generate code coverage reports.
To generate a code coverage report, you can run the following command:

```bash
COVERAGE=true rails test
```

This will run all tests and generate a `coverage` directory in the root of the project with the code coverage report.
To see the report, open the `index.html` file in your browser, e.g. run `open coverage/index.html`.

### 4.3 Linting

We use Rubocop to enforce a consistent code style. You can run Rubocop with the following command, which will only
display the offenses that are not marked as `offense` in the `.rubocop.yml` file:

```bash
rubocop --display-only-fail-level-offenses
```

If you want to autofix the issues that Rubocop finds, you can run the following command:

```bash
rubocop -A
```

### 4.4 Formatting

Unfortunately, rubocop does not format HTML, SCSS/CSS, JavaScript, YAML or Markdown files.

We use Prettier to format our JavaScript, SCSS/CSS, YAML and other files that are not formatted by Rubocop.
You can run Prettier with the following command:

```bash
npx prettier --write .
```

For HTML/ERB files, we use `htmlbeautifier`. You can run it with the following command:

```bash
htmlbeautifier **/*.html.erb
```

### 4.5 Monitoring

We use Sentry to monitor errors in the application. You can access the Sentry dashboard by clicking on the Sentry badge
or [here](https://quouch.sentry.io).
Credentials are shared via 1Password.

## Troubleshooting

### PostgreSQL in MacOS (M1)

If you are using MacOS M1, you may encounter the following error when trying to run `rails db:create`:

```
could not connect to server: No such file or directory
    Is the server running locally and accepting
    connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
```

You might want to try installing PostgreSQL using the graphical installer from
the [EDB website](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads).
If you have already installed PostgreSQL using Homebrew, you should uninstall PostgreSQL first by
running `brew uninstall postgresql`.

Using pgAdmin4, create your default user and set a password. Make sure to add these to the `.env` file in the root of
the project.

```
DEFAULT_DATABASE_USER=postgres
DEFAULT_DATABASE_PASSWORD=
```

After that, run `rails db:create` and `rails db:migrate` to create the database and tables.
