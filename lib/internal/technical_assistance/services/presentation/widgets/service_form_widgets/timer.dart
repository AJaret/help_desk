import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerWidget extends StatefulWidget {
  final StopWatchTimer stopWatchTimer;

  const TimerWidget({super.key, required this.stopWatchTimer});

  @override
  State<TimerWidget> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<TimerWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() {
    widget.stopWatchTimer.onStopTimer();
    widget.stopWatchTimer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: StreamBuilder<int>(
            stream: widget.stopWatchTimer.rawTime,
            initialData: 0,
            builder: (context, snapshot) {
              final displayTime = StopWatchTimer.getDisplayTime(snapshot.data!, milliSecond: false);
              return Text(
                displayTime,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ],
    );
  }
}
