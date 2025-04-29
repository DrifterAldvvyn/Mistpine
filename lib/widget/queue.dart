import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mistpine/color.dart';
import 'package:mistpine/backend/data.dart';
import 'package:mistpine/backend/audio_service.dart';

class Queue extends StatelessWidget {
  const Queue({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: queue.length,
        itemBuilder: (context, index) {
          final item = queue[index];
          return Dismissible(
            key: Key(item.trackName),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              queue.removeAt(index);

              audioService.setPlaylist(queue);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      'Removed item.',
                      style: TextStyle(color: AppColors.text),
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: StadiumBorder(),
                  backgroundColor: AppColors.background,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.65),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: SizedBox(
              height: 70,
              child: Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2.0,
                    color: AppColors.text.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(queue[index].cover, height: 40, width: 40),
                      Text(
                        queue[index].trackName,
                        style: TextStyle(color: AppColors.text, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
