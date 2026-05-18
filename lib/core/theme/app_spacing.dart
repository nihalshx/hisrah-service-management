/// Central spacing and sizing constants.
///
/// All padding, margin, and radius values must reference these constants
/// rather than using raw doubles in widgets.
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  static const double dialogRadius = 8.0;
  static const double cardRadius = 8.0;
  static const double buttonRadius = 6.0;
  static const double inputRadius = 6.0;

  /// Constraint widths for responsive dialog sizing.
  static const double dialogMinWidth = 480.0;
  static const double dialogMaxWidth = 620.0;
}
