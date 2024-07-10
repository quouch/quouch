Booking app for homestay from queer & female perspective.

## Table of Contents

## 1. Getting started

### 1.1. Prerequisites

- Ruby v3.1.2 (recommendation: [use `rbenv`](https://github.com/rbenv/rbenv))
- PostgreSQL v15+

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
   rails db:create
   ```

6. Run the migrations

   ```bash
   rails db:migrate
   ```

7. Seed the project with some initial data

   ```bash
   rails db:seed
   ```

8. Start the server

   ```bash
   rails s
   ```

9. Visit `http://localhost:3000` in your browser. You can login with the credential provided in your `.env` file

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

## 2. Developing

### 2.1 IDEs

Feel free to use whichever IDE you like! Our configuration is IDE agnostic and rubocop handles all of the code styling, so as long as you're running rubocop before committing, you should be good!

#### Want to use a browser-based IDE?

> Gitpod is a cloud development environment for teams to efficiently and securely develop software.

This repository contains configuration files to get started with in GitPod with very little effort! Try it out:
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/lisbethpurrucker/quouch)

Please note that the build/serving of the app will fail until you add the master key to the repository. You can do this by either following steps 2 and 3 from [the installation guide](#12-installation) or by adding an environment variable to GitPod called `RAILS_MASTER_KEY`.

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
