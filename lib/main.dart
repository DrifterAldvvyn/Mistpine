import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:mistpine/page/dashboard.dart';
import 'package:mistpine/backend/audio_service.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.mistpine.channel.audio',
    androidNotificationChannelName: 'Mistpine Audio Playback',
    androidNotificationOngoing: true,
    androidShowNotificationBadge: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'TWKEverett',
          // pageTransitionsTheme: const PageTransitionsTheme(
          //   builders: {
          //     // Set the predictive back transitions for Android.
          //     TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          //   },
          // ),
        ),
        home: Dashboard(),
        
      ),
    );
  }
}
