import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomBarIndexProvider = StateProvider<int>((ref) => 2);

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomBarIndexProvider);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.85),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: selectedIndex == 0 ? Color(0xFFFFA726) : Colors.white,
              ),
              onPressed:
                  () => ref.read(bottomBarIndexProvider.notifier).state = 0,
              tooltip: 'Messages',
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: selectedIndex == 1 ? Color(0xFFFFA726) : Colors.white,
              ),
              onPressed:
                  () => ref.read(bottomBarIndexProvider.notifier).state = 1,
              tooltip: 'Notifications',
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color:
                    selectedIndex == 2 ? Color(0xFFFFA726) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed:
                    () => ref.read(bottomBarIndexProvider.notifier).state = 2,
                tooltip: 'Home',
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: selectedIndex == 3 ? Color(0xFFFFA726) : Colors.white,
              ),
              onPressed:
                  () => ref.read(bottomBarIndexProvider.notifier).state = 3,
              tooltip: 'Favorites',
            ),
            IconButton(
              icon: Icon(
                Icons.person_outline,
                color: selectedIndex == 4 ? Color(0xFFFFA726) : Colors.white,
              ),
              onPressed:
                  () => ref.read(bottomBarIndexProvider.notifier).state = 4,
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
