FROM dart:stable

WORKDIR /mf
COPY ./core /mf/core
COPY ./server /mf/server

WORKDIR /mf/core
RUN dart pub get
RUN dart run build_runner build --delete-conflicting-outputs

WORKDIR /mf/server
RUN dart pub get
RUN dart run build_runner build --delete-conflicting-outputs

WORKDIR /mf
RUN dart compile aot-snapshot server/bin/main.dart --output mobile_fighters_api.aot --target-os linux

EXPOSE 80

CMD ["dartaotruntime", "mobile_fighters_api.aot"]
