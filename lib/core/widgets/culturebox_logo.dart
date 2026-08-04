import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_theme.dart';

class CultureBoxLogo extends StatelessWidget {
  final double fontSize;
  final bool showFullTitle;

  const CultureBoxLogo({
    super.key,
    this.fontSize = 18.0,
    this.showFullTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.logoGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
          children: [
            const TextSpan(
              text: 'CULTUREBOX',
            ),
            if (showFullTitle) ...[
              const TextSpan(text: ' '),
              TextSpan(
                text: 'TV NETWORK',
                style: GoogleFonts.inter(
                  fontSize: fontSize * 0.85,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
