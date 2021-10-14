import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Shimmer extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final Gradient gradient;
  const Shimmer({
    Key? key,
    required this.duration,
    required this.child,
    required this.gradient,
  }) : super(key: key);

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Shimer(
      widget.child,
      widget.gradient,
      _controller.value,
    );
  }
}

class _Shimer extends SingleChildRenderObjectWidget {
  final Gradient gradient;
  final double _percentage;

  const _Shimer(Widget child, this.gradient, this._percentage) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ShimmerFilter(_percentage, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter _shimmerFilter) {
    _shimmerFilter.percentage = _percentage;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  double _percentage;
  final Paint _clearPaint = Paint();
  final Gradient gradient;
  final Paint _gradientPaint;
  _ShimmerFilter(
    this._percentage,
    this.gradient,
  ) : _gradientPaint = Paint()..blendMode = BlendMode.srcIn;

  set percentage(double newValue) {
    if (newValue != _percentage) {
      _percentage = newValue;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final width = child!.size.width;
      final height = child!.size.height;

      final double rectWidth = width * 0.8;
      Rect rect;
      double dx;

      dx = _offset(offset.dx - rectWidth, offset.dx + width - (rectWidth * 0.5), _percentage);

      rect = Rect.fromLTWH(dx, offset.dy, rectWidth, height);
      _gradientPaint.shader = gradient.createShader(rect);

      context.canvas.saveLayer(offset & child!.size, _clearPaint);
      context.paintChild(child!, offset);
      context.canvas.drawRect(rect, _gradientPaint);
    }
  }

  double _offset(double start, double end, double percentage) {
    return start + ((end - start) * percentage);
  }

  @override
  bool get needsCompositing => child != null;
}
