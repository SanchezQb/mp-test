import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mp_test/widgets/bottom_app_bar.dart';

class GridItem {
  final String imagePath;
  final String title;

  GridItem({required this.imagePath, required this.title});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _bottomBarController;
  late Animation<Offset> _bottomBarOffsetAnimation;

  late AnimationController _introController;
  late Animation<double> _locationWidthAnimation;
  late Animation<double> _locationFadeAnimation;
  late Animation<double> _greetingFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<int> _buyCountAnimation;
  late Animation<int> _rentCountAnimation;
  late Animation<double> _buyCardScaleAnimation;
  late Animation<double> _rentCardScaleAnimation;
  late Animation<double> _gridFadeAnimation;

  late AnimationController _avatarController;
  late Animation<double> _avatarScaleAnimation;

  final int _buyTarget = 1034;
  final int _rentTarget = 2212;

  final NumberFormat _numberFormat = NumberFormat("#,##0", "en_US");
  String _formatNumber(int number) {
    try {
      return _numberFormat.format(number).replaceAll(',', ' ');
    } catch (e) {
      return number.toString();
    }
  }

  final List<GridItem> _gridItems = [
    GridItem(imagePath: 'assets/images/house3.png', title: 'Gladkova St, 25'),
    GridItem(imagePath: 'assets/images/house1.png', title: 'Gubina St., 11'),
    GridItem(imagePath: 'assets/images/house4.png', title: 'Trefoleva St., 43'),
    GridItem(imagePath: 'assets/images/house2.png', title: 'Sedova St., 22'),
  ];

  @override
  void initState() {
    super.initState();

    _bottomBarController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bottomBarOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _bottomBarController, curve: Curves.easeOut),
    );

    _introController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _locationWidthAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _locationFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _greetingFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.05, 0.5, curve: Curves.easeIn),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOut),
      ),
    );

    _buyCountAnimation = IntTween(begin: 0, end: _buyTarget).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );
    _rentCountAnimation = IntTween(begin: 0, end: _rentTarget).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );

    _buyCardScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );
    _rentCardScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _gridFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    );

    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    _avatarScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeOutBack),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _introController.forward();
        _avatarController.forward();
        _bottomBarController.forward();
      }
    });
  }

  @override
  void dispose() {
    _bottomBarController.dispose();
    _introController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Widget _buildGridItem(BuildContext context, GridItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey[600],
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.18),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color.fromRGBO(255, 255, 255, 0.30),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double bottomPaddingForNavBar = 90.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0XFFF4D9BD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: SizeTransition(
            axis: Axis.horizontal,
            axisAlignment: -1.0,
            sizeFactor: _locationWidthAnimation,
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: FadeTransition(
                  opacity: _locationFadeAnimation,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF9F987E),
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Saint Petersburg',
                        style: TextStyle(
                          color: Color(0xFF9F987E),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            ScaleTransition(
              scale: _avatarScaleAnimation,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: const AssetImage(
                      'assets/images/avatar.png',
                    ),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                ),
              ),
            ),
          ],
        ),

        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 8.0,
                  bottom: bottomPaddingForNavBar,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _greetingFadeAnimation,
                      child: const Text(
                        'Hi, Marina',
                        style: TextStyle(
                          color: Color(0xFF9F987E),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRect(
                      child: SlideTransition(
                        position: _titleSlideAnimation,
                        child: const Text(
                          "let's select your\nperfect place",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 32,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ScaleTransition(
                            scale: _buyCardScaleAnimation,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFA726),
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'BUY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AnimatedBuilder(
                                      animation: _buyCountAnimation,
                                      builder: (context, child) {
                                        return Text(
                                          _formatNumber(
                                            _buyCountAnimation.value,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'offers',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ScaleTransition(
                            scale: _rentCardScaleAnimation,
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.7),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'RENT',
                                    style: TextStyle(
                                      color: Color(0xFF9F987E),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedBuilder(
                                    animation: _rentCountAnimation,
                                    builder: (context, child) {
                                      return Text(
                                        _formatNumber(
                                          _rentCountAnimation.value,
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF9F987E),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'offers',
                                    style: TextStyle(
                                      color: Color(0xFF9F987E),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    FadeTransition(
                      opacity: _gridFadeAnimation,
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,

                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1.0,
                            child: _buildGridItem(context, _gridItems[0]),
                          ),

                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 2.0,
                            child: _buildGridItem(context, _gridItems[1]),
                          ),

                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1.0,
                            child: _buildGridItem(context, _gridItems[2]),
                          ),

                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1.0,
                            child: _buildGridItem(context, _gridItems[3]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: SlideTransition(
                position: _bottomBarOffsetAnimation,
                child: BottomBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
