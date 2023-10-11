import 'dart:ffi';

import '../helpter/log_utils.dart';


export 'dio_utils.dart';

class HttpLog{
  static void d(String msg){
    Log.d(msg,tag: "HTTP");
  }
  static void json(String msg){
    Log.json(msg,tag: "HTTP");
  }
  static void e(String msg){
    Log.e(msg,tag: "HTTP");
  }
}

