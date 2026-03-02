import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class DocumentScannerScreen extends StatefulWidget {
  const DocumentScannerScreen({super.key});
  @override
  State<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<DocumentScannerScreen>
    with SingleTickerProviderStateMixin {
  bool _flashOn = false;
  bool _isProcessing = false;
  bool _isDone = false;
  late AnimationController _scanAnim;
  late Animation<double> _scanPos;

  @override
  void initState() {
    super.initState();
    _scanAnim = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _scanPos = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _scanAnim, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _scanAnim.dispose(); super.dispose(); }

  Future<void> _capture() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _isProcessing = false; _isDone = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera simulation
            Container(
              color: const Color(0xFF0A0A0A),
              child: Center(
                child: _isDone
                    ? _ResultView()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Viewfinder frame
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 280, height: 380,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.gold, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _isProcessing
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
                                            const SizedBox(height: 16),
                                            const Text('Распознавание текста...', style: TextStyle(color: AppColors.gold, fontSize: 13, fontFamily: 'Inter')),
                                          ],
                                        ),
                                      )
                                    : AnimatedBuilder(
                                        animation: _scanPos,
                                        builder: (_, __) => Stack(
                                          children: [
                                            Positioned(
                                              top: _scanPos.value * 340 + 20,
                                              left: 0, right: 0,
                                              child: Container(
                                                height: 2,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [Colors.transparent, AppColors.gold, Colors.transparent],
                                                  ),
                                                  boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.5), blurRadius: 8)],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              // Corner decorations
                              ...[
                                const Positioned(top: 0, left: 0, child: _Corner()),
                                const Positioned(top: 0, right: 0, child: _Corner(flipH: true)),
                                const Positioned(bottom: 0, left: 0, child: _Corner(flipV: true)),
                                const Positioned(bottom: 0, right: 0, child: _Corner(flipH: true, flipV: true)),
                              ],
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text('Наведите на документ', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Inter')),
                        ],
                      ),
              ),
            ),
            // Top bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                    const Spacer(),
                    const Text('Сканер', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _flashOn = !_flashOn),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: _flashOn ? AppColors.gold : Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                        child: Icon(Icons.flash_on, color: _flashOn ? AppColors.primaryBackground : Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom controls
            if (!_isDone)
              Positioned(
                bottom: 40, left: 0, right: 0,
                child: Column(
                  children: [
                    Text(
                      'OCR • Распознавание текста',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 24),
                    // Capture button
                    GestureDetector(
                      onTap: _isProcessing ? null : _capture,
                      child: Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.5), blurRadius: 20)],
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryBackground, size: 32),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final bool flipH;
  final bool flipV;
  const _Corner({this.flipH = false, this.flipV = false});
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: flipH ? -1 : 1,
      scaleY: flipV ? -1 : 1,
      child: SizedBox(width: 24, height: 24,
        child: CustomPaint(painter: _CornerPainter())),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.gold..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }
  @override
  bool shouldRepaint(_) => false;
}

class _ResultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 48),
          const SizedBox(height: 12),
          const Text('Текст распознан!', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Text(
              'ДОГОВОР АРЕНДЫ ЖИЛОГО ПОМЕЩЕНИЯ\n\nгор. Алматы «02» марта 2026 г.\n\nАрендодатель: Иванов И.И.\nАрендатор: Петров П.П.\n\nПредмет договора: квартира по адресу...',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter', height: 1.5),
            ),
          ),
          const SizedBox(height: 20),
          GoldButton(text: 'Сохранить в библиотеку', onTap: () => context.push(AppRoutes.documentLibrary)),
          const SizedBox(height: 10),
          GoldButton(text: 'Сканировать ещё', isOutlined: true, onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
