#!/bin/sh

set -e
set -x

git remote rm heroku

heroku create --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"

APP_NAME=$(heroku apps | grep -v '===' | head -n 1)

heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git --app $APP_NAME
heroku addons:create heroku-postgresql:hobby-dev --app $APP_NAME

SECRET=$(mix phoenix.gen.secret)
heroku config:set SECRET_KEY_BASE=$SECRET --app $APP_NAME
heroku config:set HEROKU_APP_NAME=$APP_NAME --app $APP_NAME
heroku config:set HEROKU_HOST_NAME="$APP_NAME.herokuapp.com" --app $APP_NAME

git push heroku master

heroku run mix ecto.migrate
heroku open
