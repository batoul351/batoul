import 'package:flutter/material.dart';

Color getBackground(BuildContext context) =>
    Theme.of(context).scaffoldBackgroundColor;

Color getTextColor(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

Color getAccent(BuildContext context) =>
    Theme.of(context).primaryColor;

Color getIconColor(BuildContext context) =>
    Theme.of(context).iconTheme.color ?? Colors.grey;

TextStyle getTitleStyle(BuildContext context) =>
    Theme.of(context).textTheme.titleLarge ?? const TextStyle();

TextStyle getBodyStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
Color getCardColor(BuildContext context) =>
    Theme.of(context).cardColor;

Color getAppBarTextColor(BuildContext context) =>
    Theme.of(context).appBarTheme.foregroundColor ?? Colors.white;
