import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mistpine/color.dart';
import 'package:mistpine/backend/data.dart';
import 'package:mistpine/backend/audio_service.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final PageController _pageController = PageController(viewportFraction: 0.6);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: DefaultTabController(
        length: 3,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Container(
                height: kToolbarHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: TabBar(
                  isScrollable: false,
                  padding: EdgeInsets.all(4.0),
                  labelColor: AppColors.background,
                  unselectedLabelColor: AppColors.subtext,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: AppColors.text.withValues(alpha: 0.5),
                  ),
                  tabs: [
                    Tab(text: 'Album'),
                    Tab(text: 'Artist'),
                    Tab(text: 'Track'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Album
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: albums.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onDoubleTap: () {
                              setState(() {
                                for (var track in tracks) {
                                  if (track.album == albums[index].albumName) {
                                    queue.add(track);
                                  }
                                }
                              });

                              audioService.setPlaylist(queue);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Text(
                                      'Added to queue.',
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
                            child: Card(
                              color: Colors.black.withValues(alpha: 0.5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                child: Image.asset(albums[index].cover),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Artist
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        pageSnapping: true,
                        itemCount: artists.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onDoubleTap: () {
                                    setState(() {
                                      for (var track in tracks) {
                                      if (track.artist ==
                                          artists[index].artistName) {
                                        queue.add(track);
                                      }
                                    }
                                    });

                                    audioService.setPlaylist(queue);
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(
                                          child: Text(
                                            'Added to queue.',
                                            style: TextStyle(
                                              color: AppColors.text,
                                            ),
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: StadiumBorder(),
                                        backgroundColor: AppColors.background,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 100.0,
                                    backgroundImage: AssetImage(
                                      artists[index].profile,
                                    ),
                                  ),
                                ),
                                Text(
                                  artists[index].artistName,
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Track
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView.builder(
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 70,
                            child: GestureDetector(
                              onDoubleTap: () {
                              setState(() {
                                queue.add(tracks[index]);
                              });

                              audioService.setPlaylist(queue);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Text(
                                      'Added to queue.',
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
                              child: Card(
                                color: Colors.black.withValues(alpha: 0.5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        tracks[index].cover,
                                        height: 40,
                                        width: 40,
                                      ),
                                      Text(
                                        tracks[index].trackName,
                                        style: TextStyle(
                                          color: AppColors.text,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
