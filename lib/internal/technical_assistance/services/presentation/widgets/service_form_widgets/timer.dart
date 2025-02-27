import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});
  
  @override
  State<TimerWidget> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<TimerWidget> with WidgetsBindingObserver {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() {
    _stopWatchTimer.onStopTimer();
    _stopWatchTimer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.resumed) {
      pauseTimer();
    }else{
      resumeTimer();
    }
  }

  void pauseTimer() {
    _stopWatchTimer.onStopTimer();
  }

  void resumeTimer() {
    _stopWatchTimer.onStartTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
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