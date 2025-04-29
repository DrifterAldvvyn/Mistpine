import 'package:flutter/material.dart';
import 'package:mistpine/backend/data.dart';
import 'dart:ui';
import 'package:provider/provider.dart';

import 'package:mistpine/color.dart';
import 'package:mistpine/widget/library.dart';
import 'package:mistpine/widget/player.dart';
import 'package:mistpine/widget/queue.dart';
import 'package:mistpine/backend/audio_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  double _sheetExtent = 0.1;

  @override
  void initState() {
    super.initState();

    _sheetController.addListener(() {
      setState(() {
        _sheetExtent = _sheetController.size;
      });
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxOffset = -MediaQuery.of(context).size.height * 0.18;
    final double translation = maxOffset * ((_sheetExtent - 0.1) / (0.6 - 0.1));
    final audioService = Provider.of<AudioService>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Opacity(
            opacity: 1.0,
            child: Image.asset(
              'assets/textures/background.jpg',
              color: AppColors.pine,
              colorBlendMode: BlendMode.color,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Opacity(
            opacity: 0.45,
            child: Image.asset(
              'assets/textures/grain.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Transform.translate(
            offset: Offset(0, translation),
            child: Column(
              children: [
                // Player
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.18,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.01),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Player(),
                        ),
                      ),
                    ),
                  ),
                ),
                // Queue
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 32.0,
                      right: 32.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Queue',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              queue.clear();
                              audioService.setPlaylist(queue);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    'Queue cleared.',
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
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.text.withValues(
                              alpha: 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.55,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.01),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Queue(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Library
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.75,
            controller: _sheetController,
            builder: (BuildContext context, ScrollController scrollController) {
              return Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'assets/textures/background1.jpg',
                        color: AppColors.pine,
                        colorBlendMode: BlendMode.color,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.45,
                      child: Image.asset(
                        'assets/textures/grain.png',
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: 2.0,
                        color: AppColors.text.withValues(alpha: 0.1),
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.text,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Library',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Library(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
