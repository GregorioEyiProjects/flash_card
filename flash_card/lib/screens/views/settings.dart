import 'dart:math';

import 'package:flash_card/app_colors.dart';
import 'package:flash_card/provider/theme_provider.dart';
import 'package:flash_card/screens/widgets/settings/photo_and_usernamer_section.dart';
import 'package:flash_card/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeData? isDarkMode;
  bool toggleWhenModeChanges = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //photo and username section
              PhotoAndUsernamerSection(),

              //Dark/white mode switch
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Text to show the current mode
                    Text(
                      Provider.of<ThemeProvider>(
                                context,
                                listen: false,
                              ).isDarkMode ==
                              true
                          ? "Dark Mode"
                          : "Light Mode",
                      style: textTheme.headlineSmall /* const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: AppColors.greyColor,
                      ) */,
                    ),

                    //Switch to change the mode
                    Switch(
                      value:
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).isDarkMode,
                      activeTrackColor:
                          toggleWhenModeChanges
                              ? AppColors.backgroundColorDark
                              : Colors.white.withValues(alpha: 0.8),

                      onChanged: (value) {
                        setState(() {
                          // isDarkMode = value;
                          //Change the theme
                          debugPrint("Current value is :$value");
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).toggleTheme2(value);
                          /* debugPrint(
                            "Title for the Mode: ${isDarkMode ? "Dark Mode" : "Light Mode"}",
                          ); */
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
