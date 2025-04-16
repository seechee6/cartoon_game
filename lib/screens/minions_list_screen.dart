import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/minions_data.dart';
import '../models/minion.dart';
import 'minion_detail_screen.dart';

class MinionsListScreen extends StatefulWidget {
  const MinionsListScreen({super.key});

  @override
  State<MinionsListScreen> createState() => _MinionsListScreenState();
}

class _MinionsListScreenState extends State<MinionsListScreen> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  String? currentlyPlayingMinion;

  @override
  void initState() {
    super.initState();
    // Initialize AudioPlayer with a slight delay to ensure the plugin is registered
    Future.delayed(Duration.zero, () {
      audioPlayer = AudioPlayer();
      audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
          if (!isPlaying) {
            currentlyPlayingMinion = null;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minions Collection'),
        backgroundColor: const Color(0xFFFFE205), // Minion yellow
        foregroundColor: Colors.black,
      ),
      floatingActionButton: isPlaying
          ? FloatingActionButton.extended(
              onPressed: () {
                audioPlayer.stop();
                setState(() {
                  isPlaying = false;
                  currentlyPlayingMinion = null;
                });
              },
              backgroundColor: Colors.red,
              icon: const Icon(Icons.stop),
              label: Text('Stop ${currentlyPlayingMinion ?? "audio"}'),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE205), Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: minionsData.length,
          itemBuilder: (context, index) {
            final Minion minion = minionsData[index];
            
            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MinionDetailScreen(minion: minion),
                    ),
                  );
                },
                onLongPress: () async {
                  if (minion.soundFile != null) {
                    try {
                      await audioPlayer.stop(); // Stop any playing sound
                      await audioPlayer.play(AssetSource(minion.soundFile!));
                      setState(() {
                        currentlyPlayingMinion = minion.name;
                      });
                      
                      // Show which minion sound is playing
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Playing ${minion.name}\'s sound'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error playing sound: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                borderRadius: BorderRadius.circular(16.0),
                child: Row(
                  children: [
                    Hero(
                      tag: 'minion-${minion.id}',
                      child: Container(
                        width: 100,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            bottomLeft: Radius.circular(16.0),
                          ),
                          image: DecorationImage(
                            image: AssetImage(minion.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              minion.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              minion.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${minion.funFacts.length} Fun Facts',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            if (minion.soundFile != null)
                              Row(
                                children: [
                                  const Icon(Icons.volume_up, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Long press to hear sound',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueAccent[700],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 