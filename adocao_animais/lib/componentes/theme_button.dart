import 'package:adocao_animais/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return IconButton(
          onPressed: () {
            themeProvider.toggleTheme();
          },
          icon: themeProvider.isDarkMode
              ? const Icon(Icons.sunny)
              : const Icon(Icons.brightness_2_outlined));
    });
  }
}