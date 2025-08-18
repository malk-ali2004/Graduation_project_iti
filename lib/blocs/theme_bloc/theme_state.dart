import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;
  final bool isDark;

  const ThemeState({required this.themeData, required this.isDark});

  factory ThemeState.light() =>
      ThemeState(themeData: ThemeData.light(), isDark: false);

  factory ThemeState.dark() =>
      ThemeState(themeData: ThemeData.dark(), isDark: true);

  @override
  List<Object?> get props => [themeData, isDark];
}
