import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ColorUtils {
  static Color contrastColor({required Color bg, required Color c1, required Color c2}) {
    int contrastColor1 = _colorDiff(bg, c1);
    int contrastColor2 = _colorDiff(bg, c2);

    if (contrastColor1 >= contrastColor2) {
      return c1;
    }
    return c2;
  }

  static Color similarColor({required Color bg, required Color c1, required Color c2}) {
    int contrastColor1 = _colorDiff(bg, c1);
    int contrastColor2 = _colorDiff(bg, c2);

    if (contrastColor1 >= contrastColor2) {
      return c2;
    }
    return c1;
  }

  static int _colorDiff(Color color1, Color color2) {
    return ((max(color1.red, color2.red) - min(color1.red, color2.red)) +
            (max(color1.green, color2.green) - min(color1.green, color2.green)) +
            (max(color1.blue, color2.blue) - min(color1.blue, color2.blue)))
        .toInt();
  }

  static Color getColorFromHUE(Color color, {double anglePalette = 225}) {
    assert(anglePalette >= 0 && anglePalette <= 360);
    HSLColor hslColor = HSLColor.fromColor(color);
    double hue = hslColor.hue + anglePalette;
    return hslColor
        .withHue(hue > 360 ? hue - 360 : hue)
        .withLightness(1 - hslColor.lightness) //hslColor.lightness) //pow(hslColor.lightness, 1).toDouble())
        //.withSaturation(1 - pow(hslColor.saturation, 0).toDouble()) //hslColor.saturation) //pow(hslColor.saturation, 1).toDouble())
        .toColor();
  }
}
