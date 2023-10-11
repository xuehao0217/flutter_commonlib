
import 'dart:async';

import 'package:event_bus/event_bus.dart';
// https://pub-web.flutter-io.cn/packages/event_bus/example
class EventBusHelper{
  static EventBus eventBus = EventBus();

  static StreamSubscription<T> listen<T>(Function(T) f)=> eventBus.on<T>().listen((event) {
    f.call(event);
  });

  static on<T>() => eventBus.on<T>();

  static post<T>(T data){
    eventBus.fire(data);
  }
}