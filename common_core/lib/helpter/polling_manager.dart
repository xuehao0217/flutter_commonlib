import 'dart:async';
import 'dart:ui';


//轮询模式（不传 total）
// final polling = TimerManager(
//   interval: Duration(seconds: 2),
//   onTick: (_) {
//     print("轮询一次");
//   },
// );
//
// polling.start();


//倒计时模式（传 total）
// final countdown = UniversalManager(
//   total: 5, // 倒计时 5 次
//   interval: Duration(seconds: 1),
//   onTick: (remaining) {
//     print("剩余: $remaining");
//   },
//   onComplete: () {
//     print("倒计时结束");
//   },
// );
//
// countdown.start();


typedef TickCallback = void Function(int? remaining);

class TimerManager {
  Timer? _timer;
  final Duration interval;        // 每次间隔
  final int? total;               // 总次数/秒数 (null 表示无限轮询)
  int? _remaining;
  final TickCallback onTick;      // 每次回调 (remaining==null 表示轮询)
  final VoidCallback? onComplete; // 倒计时结束回调

  TimerManager({
    required this.interval,
    required this.onTick,
    this.total,
    this.onComplete,
  }) : _remaining = total;

  void start() {
    stop();
    _remaining = total;

    // 如果是倒计时，立即触发一次
    if (total != null) {
      onTick(_remaining);
    }

    _timer = Timer.periodic(interval, (_) {
      if (total == null) {
        // 无限轮询
        onTick(null);
      } else {
        // 倒计时模式
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

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isRunning => _timer != null;

  int? get remaining => _remaining;

  void dispose() => stop();
}
