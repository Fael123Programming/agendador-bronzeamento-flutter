import 'package:flutter/material.dart';

class RotatingSun extends StatefulWidget {
  final double size;

  const RotatingSun({super.key, required this.size});

  @override
  State<RotatingSun> createState() => _RotatingSunState();
}

class _RotatingSunState extends State<RotatingSun> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      alignment: Alignment.center,
      turns: _animationController,
      child: Icon(
        Icons.wb_sunny, 
        color: Theme.of(context).colorScheme.primary,
        size: widget.size,
      ),
    );
  }
}