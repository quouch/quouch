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
2. Create your credentials file
    ```bash
    EDITOR=vim rails credentials:edit
    ```
   The file has the following format:
    ```yml
   gmail:
   - username: 
   - password: 
   # Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
   secret_key_base: 
   stripe:
   - production:
      - secret_key: 
      - publishable_key: 
      - signing_secret_key: 
   ```
   > Please get in contact Liz to obtain the credentials.   

3. Create your .env file
   ```bash 
   cp .env.example .env
   ```
   > Please get in contact Liz to obtain the credentials.

   Add your PostgreSQL username and password to the `.env` file:

   ```
   DEFAULT_DATABASE_USER=postgres
   DEFAULT_DATABASE_PASSWORD=
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

7. Start the server

   ```bash
   rails s
   ```


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
