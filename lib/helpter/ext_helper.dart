import 'dart:core';
import 'dart:core';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_commonlib/helpter/logger_utils.dart';

import 'log_utils.dart';

// str?.let((data) => {
// Log.logger.e("let  非空  ${data}")
// });
extension ObjectExtLet on Object {
  Object let(Function(Object data) function) {
    if (ObjectUtil.isNotEmpty(this)) {
      return function.call(this);
    } else {
      return this;
    }
  }

}

extension Let<T> on T {
  R? let<R>(R Function(T it) block) {
    if (this == null) {
      return null;
    } else {
      return block(this);
    }
  }

  T also(void Function(T it) block) {
    if (this != null) {
      block(this);
    }
    return this;
  }
}



extension LetRunApply<T> on T {
  /// let 函数与之前的示例相同，它接受一个闭包并返回其结果。
  R let<R>(R Function(T) block) {
    return block(this);
  }

  /// run 函数也与之前的示例相同，它接受一个闭包但不返回任何内容。
  void run(void Function(T) block) {
    block(this);
  }

  /// apply 函数它接受一个闭包并在当前对象上执行该闭包。然后，它返回当前对象本身
  T apply(void Function(T) block) {
    block(this);
    return this;
  }
}



extension StringLog on String {
  String? logger() {
      LoggerUtils.d(this);
  }
}

