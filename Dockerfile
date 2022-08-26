FROM bitwalker/alpine-elixir-phoenix:latest

ARG SECRET_KEY_BASE
ARG VERTEX_ACCESS_TOKEN
ARG CLICKHOUSE_DATABASE
ARG CLICKHOUSE_URL
ARG CLICKHOUSE_USER
ARG CLICKHOUSE_PASSWORD

ENV MIX_ENV=prod

RUN mix local.hex --force
RUN mix local.rebar --force

ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

RUN mix do compile, phx.digest

CMD mix phx.server
