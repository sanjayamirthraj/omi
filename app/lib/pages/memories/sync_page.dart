import 'package:flutter/material.dart';
import 'package:friend_private/pages/memories/widgets/sync_animation.dart';
import 'package:friend_private/providers/memory_provider.dart';
import 'package:friend_private/utils/other/temp.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

import 'synced_memories_page.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  bool _isAnimating = false;

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        Provider.of<MemoryProvider>(context, listen: false).clearSyncResult();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sync Memories'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Consumer<MemoryProvider>(
          builder: (context, memoryProvider, child) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  child!,
                  const SizedBox(height: 80),
                  memoryProvider.isSyncing || memoryProvider.syncCompleted
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          decoration: BoxDecoration(
                            border: const GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(127, 208, 208, 208),
                                Color.fromARGB(127, 188, 99, 121),
                                Color.fromARGB(127, 86, 101, 182),
                                Color.fromARGB(127, 126, 190, 236)
                              ]),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              _toggleAnimation();
                              await memoryProvider.syncWals();
                              _toggleAnimation();
                            },
                            child: const Text(
                              'Sync Now',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  memoryProvider.isSyncing
                      ? Text(
                          '${(memoryProvider.walsSyncedProgress * 100).toInt()}% synced',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 10,
                  ),
                  memoryProvider.syncCompleted && memoryProvider.syncResult != null
                      ? Column(
                          children: [
                            const Text(
                              'Memories Synced Successfully 🎉',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            (memoryProvider.syncResult!['new_memories'].isNotEmpty ||
                                    memoryProvider.syncResult!['updated_memories'].isNotEmpty)
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                    decoration: BoxDecoration(
                                      border: const GradientBoxBorder(
                                        gradient: LinearGradient(colors: [
                                          Color.fromARGB(127, 208, 208, 208),
                                          Color.fromARGB(127, 188, 99, 121),
                                          Color.fromARGB(127, 86, 101, 182),
                                          Color.fromARGB(127, 126, 190, 236)
                                        ]),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        routeToPage(context, const SyncedMemoriesPage());
                                      },
                                      child: const Text(
                                        'View Synced Memories',
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            );
          },
          child: RepaintBoundary(
            child: SyncAnimation(
              isAnimating: _isAnimating,
              onStart: () {},
              onStop: () {},
              dotsPerRing: 12,
            ),
          ),
        ),
      ),
    );
  }
}
