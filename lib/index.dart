import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_test/home.dart';
import 'package:mp_test/map.dart';
import 'package:mp_test/widgets/bottom_app_bar.dart';

class IndexPage extends ConsumerWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomBarIndexProvider);

    const pages = [MapPage(), Home(), Home(), Home()];
    return pages[selectedIndex];
  }
}
