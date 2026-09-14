import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
          children: [
            _ProfilesSection(),

            const SizedBox(height: 18),

            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, color: Colors.white70, size: 16),
                label: const Text(
                  'Manage Profiles',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              '▣  Tell friends about Netflix.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Sit quam dui, vivamus bibendum. A morbi tortor ut felis '
              'non accumsan accumsan quis. Massa, sed ut ipsum aliquam '
              'enim posuere porta.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {},
              child: const Text(
                'Terms & Conditions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const Text(
                      'https://netflix.com/share',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _copyLink(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      'Copy Link',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SocialButton(
                    icon: Icons.chat,
                    label: 'WhatsApp',
                    iconColor: const Color(0xFF25D366),
                    onTap: () {},
                  ),
                  _VerticalDivider(),
                  _SocialButton(
                    icon: Icons.facebook,
                    label: 'Facebook',
                    iconColor: const Color(0xFF1877F2),
                    onTap: () {},
                  ),
                  _VerticalDivider(),
                  _SocialButton(
                    icon: Icons.mail,
                    label: 'Gmail',
                    iconColor: const Color(0xFFEA4335),
                    onTap: () {},
                  ),
                  _VerticalDivider(),
                  _SocialButton(
                    icon: Icons.more_horiz,
                    label: 'More',
                    iconColor: Colors.white,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            _MenuItem(
              icon: Icons.check,
              title: 'My List',
              largeIcon: true,
              onTap: () {},
            ),

            const Divider(height: 1, color: Colors.white12),

            _MenuItem(title: 'App Settings', onTap: () {}),

            _MenuItem(title: 'Account', onTap: () {}),

            _MenuItem(title: 'Help', onTap: () {}),

            _MenuItem(
              title: 'Sign Out',
              onTap: () {
                _showSignOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _copyLink(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Link copied')));
  }

  void _showSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF202020),
          title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfilesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Profile(name: 'Emenalo', color: const Color(0xFF2196F3)),
        _Profile(name: 'Onyeka', color: const Color(0xFFFFD21F)),
        _Profile(name: 'Thelma', color: const Color(0xFFFF2424)),
        _Profile(name: 'Kids', color: const Color(0xFF2196F3), kids: true),
        _AddProfile(),
      ],
    );
  }
}

class _Profile extends StatelessWidget {
  final String name;
  final Color color;
  final bool kids;

  const _Profile({required this.name, required this.color, this.kids = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: kids
              ? const Center(
                  child: Text(
                    'kids',
                    style: TextStyle(
                      color: Color(0xFFFFD83D),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              : CustomPaint(painter: _SmilePainter()),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _AddProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(Icons.add, color: Colors.white70, size: 32),
        ),
        const SizedBox(height: 6),
        const Text('', style: TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 29),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 38, color: Colors.white30);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final bool largeIcon;

  const _MenuItem({
    this.icon,
    required this.title,
    required this.onTap,
    this.largeIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: largeIcon ? 30 : 22),
              const SizedBox(width: 12),
            ],
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.30, size.height * 0.37), 4, paint);

    canvas.drawCircle(Offset(size.width * 0.70, size.height * 0.37), 4, paint);

    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(size.width * 0.28, size.height * 0.53);

    path.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.69,
      size.width * 0.72,
      size.height * 0.53,
    );

    canvas.drawPath(path, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
