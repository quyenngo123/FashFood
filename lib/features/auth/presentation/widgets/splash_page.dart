import 'package:flutter/material.dart';
import '../pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE3F2FD)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50), // Lùi bố cục xuống
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      // Đổ bóng chính tạo chiều sâu
                      BoxShadow(
                        color: const Color(0xFF0D47A1).withOpacity(0.15),
                        blurRadius: 40,
                        spreadRadius: 2,
                        offset: const Offset(0, 15),
                      ),
                      // Đổ bóng phụ tạo độ nổi khối (3D effect)
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 20,
                        spreadRadius: -5,
                        offset: const Offset(0, -10),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF0D47A1).withOpacity(0.08),
                      width: 2,
                    ),
                  ),
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: CustomPaint(painter: _LogoPainter()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    'FAST FOOD',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0D47A1),
                      letterSpacing: 6.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 5,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Đệm dưới để không bị trống
          ],
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    _drawBurger(canvas, Offset(cx - 48, cy + 28), 28);
    _drawFries(canvas, Offset(cx - 42, cy - 22), 26);
    _drawBurger(canvas, Offset(cx + 42, cy - 18), 26);
    _drawFries(canvas, Offset(cx + 46, cy + 24), 22);
    _drawLightning(canvas, size);
  }

  void _drawBurger(Canvas canvas, Offset center, double r) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Bóng đổ dưới các lớp
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Bun trên (Vàng ươm)
    paint.color = const Color(0xFFC8860A);
    final bunPath = Path()..addArc(Rect.fromCenter(center: center.translate(0, -r * 0.3), width: r * 2.1, height: r * 1.1), 3.14, 3.14);
    canvas.drawPath(bunPath, paint);

    // Thêm hạt vừng (Sesame seeds)
    paint.color = Colors.white.withOpacity(0.7);
    canvas.drawCircle(center.translate(-r * 0.4, -r * 0.6), 1.5, paint);
    canvas.drawCircle(center.translate(r * 0.2, -r * 0.7), 1.5, paint);
    canvas.drawCircle(center.translate(r * 0.5, -r * 0.5), 1.5, paint);

    // Thịt (Nâu đậm)
    paint.color = const Color(0xFF5D2E00);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: r * 2.1, height: r * 0.4), const Radius.circular(4)), paint);

    // Rau (Xanh tươi)
    paint.color = const Color(0xFF4CAF50);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center.translate(0, r * 0.25), width: r * 2.2, height: r * 0.2), const Radius.circular(2)), paint);

    // Bun dưới
    paint.color = const Color(0xFFE6A020);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center.translate(0, r * 0.55), width: r * 1.9, height: r * 0.4), const Radius.circular(8)), paint);
  }

  void _drawFries(Canvas canvas, Offset center, double r) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Hộp khoai (Đỏ đậm)
    paint.color = const Color(0xFFB71C1C);
    final boxPath = Path()
      ..moveTo(center.dx - r * 0.7, center.dy)
      ..lineTo(center.dx + r * 0.7, center.dy)
      ..lineTo(center.dx + r * 0.5, center.dy + r * 1.1)
      ..lineTo(center.dx - r * 0.5, center.dy + r * 1.1)
      ..close();
    canvas.drawPath(boxPath, paint);

    // Khoai tây (Vàng sáng)
    paint.color = const Color(0xFFFFEB3B);
    for (int i = -1; i <= 1; i++) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center.translate(i * r * 0.45, -r * 0.5), width: r * 0.25, height: r * 0.95), const Radius.circular(4)), paint);
    }
  }

  void _drawLightning(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final lightningPath = Path()
      ..moveTo(cx + 8, cy - 75)
      ..lineTo(cx - 20, cy - 5)
      ..lineTo(cx + 6, cy - 5)
      ..lineTo(cx - 8, cy + 75)
      ..lineTo(cx + 22, cy + 8)
      ..lineTo(cx - 4, cy + 8)
      ..close();

    // Outer Glow (Phát sáng)
    final glowPaint = Paint()
      ..color = const Color(0xFF42A5F5).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(lightningPath, glowPaint);

    // Gradient chính của tia sét
    final gradientPaint = Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF64B5F6), Color(0xFF0D47A1)]).createShader(Rect.fromLTWH(cx - 30, cy - 80, 60, 160));
    canvas.drawPath(lightningPath, gradientPaint);

    // Viền trắng sắc nét
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(lightningPath, borderPaint);

    // Ánh sáng highlight bên trong
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.5)..style = PaintingStyle.fill;
    final highlightPath = Path()
      ..moveTo(cx + 4, cy - 60)
      ..lineTo(cx - 10, cy - 10)
      ..lineTo(cx + 2, cy - 10)
      ..lineTo(cx - 2, cy + 20)
      ..close();
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
