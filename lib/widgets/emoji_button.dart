import 'package:flutter/material.dart';

class EmojiButton extends StatelessWidget {
  const EmojiButton({
    Key? key,
    this.buttonLabel,
    this.buttonIcon,
    this.ontap,
    required this.size,
    this.isActive,
    this.icon,
  }) : super(key: key);
  final buttonLabel;
  final buttonIcon;
  final ontap;
  final isActive;
  final Size size;
  final icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(1, 6), blurRadius: 5.0)
          ],
          gradient: isActive
              ? const LinearGradient(
                  stops: [0.0, 1.0],
                  colors: <Color>[
                    Color.fromARGB(255, 179, 207, 92),
                    Color.fromARGB(255, 179, 207, 92),
                  ],
                )
              : const LinearGradient(
                  stops: [1.0, 1.0],
                  colors: <Color>[Colors.white, Colors.white],
                ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
