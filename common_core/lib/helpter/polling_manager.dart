import 'dart:async';
import 'dart:ui';

void main() {
  // 倒计时模式
  final countdown = TimerManager(
    total: 5,/// 倒计时 5 次 total 为 null 就是轮询  /
    interval: Duration(seconds: 1),
    onTick: (remaining) => print("剩余: $remaining"),
    onComplete: () => print("倒计时结束"),
  );

  countdown.start();

  // 2 秒后暂停
  Future.delayed(Duration(seconds: 2), () {
    countdown.pause();
    print("暂停: ${countdown.remaining}");
  });

  // 3 秒后继续
  Future.delayed(Duration(seconds: 5), () {
    countdown.resume();
    print("继续");
  });
}

/// 定时器模式
enum TimerMode { polling, countdown }

typedef TickCallback = void Function(int? remaining);

class TimerManager {
  Timer? _timer;
  TimerMode _mode;
  final Duration interval; // 每次间隔
  final int? total; // 总次数/秒数 (null 表示无限轮询)
  int? _remaining; // 倒计时剩余次数
  final TickCallback onTick; // 每次回调 (remaining==null 表示轮询)
  final VoidCallback? onComplete; // 倒计时结束回调
  bool _isPaused = false;

  /// [interval] 定时器间隔
  /// [onTick] 每次触发回调
  /// [total] 倒计时总次数，如果为 null 则为轮询模式
  /// [onComplete] 倒计时结束回调
  /// [immediate] 是否立即触发一次 onTick
  TimerManager({
    required this.interval,
    required this.onTick,
    this.total,
    this.onComplete,
    bool immediate = true,
  }) : _mode = total == null ? TimerMode.polling : TimerMode.countdown,
       _remaining = total {
    // 立即触发一次回调（可选）
    if (immediate && _mode == TimerMode.countdown && total != null) {
      onTick(_remaining);
    }
  }

  /// 启动定时器
  void start() {
    stop();
    _remaining = total;
    _isPaused = false;

    _timer = Timer.periodic(interval, (_) {
      if (_isPaused) return;

      if (_mode == TimerMode.polling) {
        onTick(null);
      } else {
        _remaining = (_remaining ?? 0) - 1;
        if ((_remaining ?? 0) > 0) {
          onTick(_remaining);
        } else {
          onTick(0);
          stop();
          onComplete?.call();
        }
      }
    });
  }

  /// 暂停定时器
  void pause() {
    _isPaused = true;
  }

  /// 恢复定时器
  void resume() {
    _isPaused = false;
  }

  /// 停止并重置定时器
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isPaused = false;
    _remaining = total;
  }

  /// 是否正在运行
  bool get isRunning => _timer != null && !_isPaused;

  /// 是否暂停
  bool get isPaused => _isPaused;

  /// 当前剩余次数（倒计时模式），轮询模式返回 null
  int? get remaining => _remaining;

  /// 模式类型
  TimerMode get mode => _mode;

  /// 销毁
  void dispose() => stop();
}
