# Interactive Tetris

Interactive Tetris application, an *Elixir* + *Phoenix* workshop (for both - beginners and *BEAM* enthusiasts).

Editions:

- *09.04.2016* (*HackerSpace Silesia*, Katowice).

Check out our current meet-ups at [silesian-beamers.github.io](http://silesian-beamers.github.io).

![Screenshot from the game](/docs/Screenshot.png)

## Prerequisites and requirements

- *Elixir* (at least in version `1.2.3`).
- *Erlang* (at least in version `17.5` - ideally `18.2.1`).
- *PostgreSQL* (tested with `9.5.1`).
- *Modern browser* that supports *Web Socket* protocol.

## Local development

To start our application:

  * Install dependencies with `mix deps.get`.
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate` or `mix ecto.setup`.
  * Install Node.js dependencies with `npm install`.
  * Start Phoenix endpoint with `mix phoenix.server` or `iex -S mix phoenix.server` if you want to access console.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Heroku deployment

You can find all commands inside [heroku_deploy.sh](/heroku_deploy.sh).
