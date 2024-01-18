FROM dart:stable

WORKDIR /mf

COPY ./core /mf/core
COPY ./server /mf/server

RUN dart pub get -C core
RUN dart pub get -C server

RUN dart compile aot-snapshot server/bin/main.dart --output mobile_fighters_api.aot --target-os linux

EXPOSE 80

CMD ["dartaotruntime", "mobile_fighters_api.aot"]
