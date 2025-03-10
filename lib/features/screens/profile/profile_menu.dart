import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.trailingIcon = LineAwesomeIcons.angle_right_solid, // Default right arrow
    this.style,
    this.textColor, // Added missing textColor property
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final IconData trailingIcon;
  final TextStyle? style;
  final Color? textColor; // Added textColor field

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDark = theme.brightness == Brightness.dark;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primary.withOpacity(0.1),
        ),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(
        title,
        style: style ??
            theme.textTheme.bodyMedium?.copyWith(
              color: textColor ?? theme.textTheme.bodyMedium?.color,
            ),
      ),
      trailing: endIcon
          ? Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        ),
        child: Icon(
          trailingIcon,
          size: 18.0,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      )
          : null,
    );
  }
}


