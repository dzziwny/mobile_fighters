FROM dart:stable

WORKDIR /mf

COPY ./core /mf/core
COPY ./server /mf/server

RUN dart pub get -C core
RUN dart pub get -C server

RUN dart compile aot-snapshot server/bin/main.dart --output mobile_fighters.aot

EXPOSE 8080

CMD ["dartaotruntime", "mobile_fighters.aot"]
