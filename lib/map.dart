import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mp_test/widgets/bottom_app_bar.dart';
import 'package:popover/popover.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final LatLng _center = LatLng(59.9343, 30.3351);

  late AnimationController _bottomBarController;
  late Animation<Offset> _bottomBarOffsetAnimation;

  final GlobalKey _layersButtonKey = GlobalKey();

  final List<LatLng> _markerPositions = [
    LatLng(59.9386, 30.3141),
    LatLng(59.9295, 30.3297),
    LatLng(59.9270, 30.3609),
    LatLng(59.9430, 30.3430),
    LatLng(59.9200, 30.3500),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _bottomBarController.forward();
      }
    });
  }

  @override
  void dispose() {
    _bottomBarController.dispose();
    super.dispose();
  }

  void _showListPopover() {
    final buttonContext = _layersButtonKey.currentContext;

    if (buttonContext != null) {
      showPopover(
        context: buttonContext,
        bodyBuilder: (context) => const ListPopoverContent(),
        direction: PopoverDirection.top,
        width: 200,
        height: 190,
        arrowHeight: 0,
        arrowWidth: 0,
        backgroundColor: Color.fromRGBO(249, 245, 237, 1),
        barrierColor: Colors.transparent,
        radius: 25,
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 12.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers:
                      _markerPositions
                          .map(
                            (pos) => Marker(
                              width: 48,
                              height: 48,
                              point: pos,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFA726),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.apartment,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 56,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(Icons.search, color: Color(0xFF9F987E)),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Saint Petersburg',
                            style: TextStyle(
                              color: Color(0xFF9F987E),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Color(0xFF9F987E)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            bottom: 120,
            child: Column(
              children: [
                GestureDetector(
                  key: _layersButtonKey,
                  onTap: _showListPopover,
                  child: _CircleIcon(icon: Icons.layers_outlined),
                ),

                const SizedBox(height: 16),

                _CircleIcon(icon: Icons.navigation_outlined),
              ],
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
          Positioned(
            right: 20,
            bottom: 120,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Color.fromRGBO(66, 66, 66, 0.85),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: const [
                  Icon(Icons.list, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'List of variants',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListPopoverContent extends StatelessWidget {
  const ListPopoverContent({super.key});

  static const Color _textColor = Color(0xFFA5957E);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPopoverOption(context, Icons.deck_outlined, 'Cozy areas'),
          _buildPopoverOption(context, Icons.attach_money, 'Price'),
          _buildPopoverOption(
            context,
            Icons.apartment_outlined,
            'Infrastructure',
          ),
          _buildPopoverOption(
            context,
            Icons.layers_clear_outlined,
            'Without any layer',
          ),
        ],
      ),
    );
  }

  Widget _buildPopoverOption(BuildContext context, IconData icon, String text) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFFFFA726), size: 20),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(color: _textColor, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  const _CircleIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Color.fromRGBO(66, 66, 66, 0.85),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}

class NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const NavIcon({super.key, required this.icon, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration:
          selected
              ? const BoxDecoration(
                color: Color(0xFFFFA726),
                shape: BoxShape.circle,
              )
              : null,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}
