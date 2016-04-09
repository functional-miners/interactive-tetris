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

1. `heroku login`
2. `heroku create --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"`
3. `heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git --app APP_NAME`
4. `heroku addons:create heroku-postgresql:hobby-dev --app APP_NAME`
5. `mix phoenix.gen.secret`
6. `heroku config:set SECRET_KEY_BASE=SUPER_SECRET_KEY --app APP_NAME`
7. `heroku config:set HEROKU_APP_NAME=$(heroku apps:info | grep -v '===' | head -n 1) --app APP_NAME`
8. `heroku config:set HEROKU_HOST_NAME="$(heroku apps | grep -v '===' | head -n 1).herokuapp.com" --app APPN_NAME`
9. `git push heroku master`
10. `heroku run mix ecto.migrate`
11. `heroku open`
