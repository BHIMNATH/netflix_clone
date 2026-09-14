import 'package:flutter/material.dart';

import '../../app/app_shell.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Netflix logo
                    Image.asset(
                      'assets/netflix_logo.png',
                      width: 190,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'NETFLIX',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 65),

                    // Profiles
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 28,
                      runSpacing: 30,
                      children: [
                        _ProfileItem(
                          name: 'Emenalo',
                          color: const Color(0xFF2196F3),
                          onTap: () => _openHome(context),
                        ),
                        _ProfileItem(
                          name: 'Onyeka',
                          color: const Color(0xFFFFD21F),
                          onTap: () => _openHome(context),
                        ),
                        _ProfileItem(
                          name: 'Thelma',
                          color: const Color(0xFFFF2020),
                          onTap: () => _openHome(context),
                        ),
                        _ProfileItem(
                          name: 'Kids',
                          isKids: true,
                          onTap: () => _openHome(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 55),

                    // Add Profile
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.20),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 42,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Add Profile',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 12,
              right: 18,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String name;
  final Color? color;
  final bool isKids;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.name,
    required this.onTap,
    this.color,
    this.isKids = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
            // Profile image
            _ProfileAvatar(color: color, isKids: isKids),

            const SizedBox(height: 10),

            // Profile name
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final Color? color;
  final bool isKids;

  const _ProfileAvatar({this.color, this.isKids = false});

  @override
  Widget build(BuildContext context) {
    if (isKids) {
      return Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3F51B5),
              Color(0xFF9C27B0),
              Color(0xFFE91E63),
              Color(0xFFFF9800),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.30),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'kids',
            style: TextStyle(
              color: Color(0xFFFFD83D),
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        color: color ?? Colors.grey,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: (color ?? Colors.white).withValues(alpha: 0.30),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomPaint(painter: _SmilePainter()),
    );
  }
}

class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Left eye
    canvas.drawCircle(Offset(size.width * 0.30, size.height * 0.38), 7, paint);

    // Right eye
    canvas.drawCircle(Offset(size.width * 0.70, size.height * 0.38), 7, paint);

    // Smile
    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();

    smilePath.moveTo(size.width * 0.27, size.height * 0.54);

    smilePath.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.72,
      size.width * 0.73,
      size.height * 0.54,
    );

    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
