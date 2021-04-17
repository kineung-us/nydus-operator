#########################
###### Build Image ######
#########################

FROM bitwalker/alpine-elixir:1.11.4 as builder

ENV MIX_ENV=prod \
  MIX_HOME=/opt/mix \
  HEX_HOME=/opt/hex

ARG APP_VERSION
ENV APP_VERSION=${APP_VERSION}

RUN mix local.hex --force && \
  mix local.rebar --force

WORKDIR /app

COPY mix.lock mix.exs ./
COPY config config

RUN mix deps.get --only-prod && mix deps.compile

COPY lib lib

RUN mix release

#########################
##### Release Image #####
#########################

FROM alpine:3.10

RUN apk add --update openssl ncurses

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/nydus_operator ./
RUN chown -R nobody: /app

ENTRYPOINT ["/app/bin/nydus_operator"]
CMD ["start"]
