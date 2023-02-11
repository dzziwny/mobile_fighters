import 'package:rxdart/rxdart.dart';

extension RxDartExtensions<T> on Stream<T?> {
  Stream<T> skipNull() => flatMap<T>(
        (T? value) async* {
          if (value != null) yield value;
        },
      );
}
