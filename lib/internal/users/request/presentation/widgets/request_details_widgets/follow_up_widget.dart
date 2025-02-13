import 'package:flutter/material.dart';
import 'package:help_desk/internal/users/request/domain/entities/follow_up.dart';
import 'package:timelines_plus/timelines_plus.dart';

class FollowUpWidget extends StatelessWidget {
  final List<FollowUp> followUps;

  const FollowUpWidget({
    super.key,
    required this.followUps,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Movimientos',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height * 0.65,
              child: Timeline.tileBuilder(
                builder: TimelineTileBuilder.connected(
                  contentsAlign: ContentsAlign.basic,
                  nodePositionBuilder: (context, index) => 0.02,
                  itemExtentBuilder: (_, __) => 100.0,
                  contentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          followUps[index].status ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (followUps[index].email != null)
                          Text(
                            followUps[index].email!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        if (followUps[index].observations != null)
                          Text(followUps[index].observations!),
                      ],
                    ),
                  ),
                  indicatorBuilder: (context, index) => const DotIndicator(
                    color: Colors.blue,
                    size: 20.0,
                  ),
                  connectorBuilder: (context, index, type) => const SolidLineConnector(
                    color: Colors.blue,
                  ),
                  itemCount: followUps.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}