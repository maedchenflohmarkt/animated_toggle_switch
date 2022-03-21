import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:animated_toggle_switch/src/properties.dart';
import 'package:flutter/material.dart';

import 'custom_animated_toggle_switch.dart';

typedef SizeIconBuilder<T> = Widget Function(BuildContext context,
    SizeProperties<T> local, DetailedGlobalToggleProperties<T> global);

typedef SimpleSizeIconBuilder<T> = Widget Function(T value, Size size);

typedef SimpleIconBuilder<T> = Widget Function(T value);

typedef RollingIconBuilder<T> = Widget Function(BuildContext context,
    RollingProperties<T> local, DetailedGlobalToggleProperties<T> global);

typedef SimpleRollingIconBuilder<T> = Widget Function(
    T value, Size size, bool foreground);

/// A version of IconBuilder for writing a own Animation on the change of the selected item.
typedef AnimatedIconBuilder<T> = Widget Function(
    BuildContext context,
    AnimatedToggleProperties<T> local,
    DetailedGlobalToggleProperties<T> global);

typedef IconBuilder<T> = Widget Function(BuildContext context,
    LocalToggleProperties<T> local, DetailedGlobalToggleProperties<T> global);

typedef ColorBuilder<T> = Color? Function(T value);

enum AnimationType { onSelected, onHover }

class AnimatedToggleSwitch<T> extends StatelessWidget {
  /// The currently selected value. It has to be set at [onChanged] or whenever for animating to this value.
  ///
  /// [current] has to be in [values] for working correctly.
  final T current;

  /// All possible values.
  final List<T> values;

  /// The IconBuilder for all icons with the specified size.
  final AnimatedIconBuilder<T>? animatedIconBuilder;

  /// Builder for the color of the indicator depending on the current value.
  final ColorBuilder<T>? colorBuilder;

  /// Duration of the motion animation.
  final Duration animationDuration;

  /// If null, [animationDuration] is taken.
  ///
  /// [iconAnimationDuration] defines the duration of the Animation built in [animatedIconBuilder].
  /// In some constructors this is the Duration of the size animation.
  final Duration? iconAnimationDuration;

  /// Curve of the motion animation.
  final Curve animationCurve;

  /// [iconAnimationCurve] defines the duration of the Animation built in [animatedIconBuilder].
  /// In some constructors this is the [Curve] of the size animation.
  final Curve iconAnimationCurve;

  /// Size of the indicator.
  final Size indicatorSize;

  /// Callback for selecting a new value. The new [current] should be set here.
  final Function(T)? onChanged;

  /// Width of the border of the switch. For deactivating please set this to 0.0 and set [borderColor] to Colors.transparent.
  final double borderWidth;

  /// BorderRadius of the border. If this is null, the standard BorderRadius is taken.
  final BorderRadiusGeometry? borderRadius;

  /// Standard color of the border of the switch. For deactivating please set this to Colors.transparent and set [borderWidth] to 0.0.
  final Color? borderColor;

  /// Color of the background.
  final Color? innerColor;

  /// Opacity for the icons.
  ///
  /// Please set [iconOpacity] and [selectedIconOpacity] to 1.0 for deactivating the AnimatedOpacity.
  final double iconOpacity;

  /// Opacity for the currently selected icon.
  ///
  /// Please set [iconOpacity] and [selectedIconOpacity] to 1.0 for deactivating the AnimatedOpacity.
  final double selectedIconOpacity;

  /// Space between the "indicator rooms" of the adjacent icons.
  final double dif;

  /// Total height of the widget.
  final double height;

  /// If null, the indicator is behind the icons. Otherwise an icon is in the indicator and is built using this Function.
  final CustomIndicatorBuilder<T>? foregroundIndicatorIconBuilder;

  /// Standard Indicator Color
  final Color? indicatorColor;

  /// A builder for the Color of the Border. Can be used alternatively to [borderColor].
  final ColorBuilder<T>? borderColorBuilder;

  /// Which iconAnimationType for the [animatedIconBuilder] should be taken?
  final AnimationType iconAnimationType;

  /// Which iconAnimationType for the indicator should be taken?
  final AnimationType indicatorAnimationType;

  /// Callback for tapping anywhere on the widget.
  final Function()? onTap;

  final IconArrangement _iconArrangement;

  final FittingMode fittingMode;

  final BoxBorder? foregroundBorder;

  /// Shadow for the indicator [Container].
  final List<BoxShadow> foregroundBoxShadow;

  /// Shadow for the [Container] in the background.
  final List<BoxShadow> boxShadow;

  final bool _iconsTappable;

  /// The minimum width of the indicator's hitbox.
  ///
  /// Helpful if the indicator is so small that you can hardly grip it.
  final double minTouchTargetSize;

  /// The direction in which the icons are arranged.
  ///
  /// If null, the [TextDirection] is taken from the [BuildContext].
  final TextDirection? textDirection;

  /// Constructor of AnimatedToggleSwitch with all possible settings.
  ///
  /// Consider using [CustomAnimatedToggleSwitch] for maximum customizability.
  const AnimatedToggleSwitch.custom({
    Key? key,
    required this.current,
    required this.values,
    this.animatedIconBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    this.indicatorSize = const Size(48.0, double.infinity),
    this.onChanged,
    this.borderWidth = 2,
    this.borderColor,
    this.innerColor,
    this.indicatorColor,
    this.colorBuilder,
    this.iconAnimationCurve = Curves.easeOutBack,
    this.iconAnimationDuration,
    this.iconOpacity = 0.5,
    this.borderRadius,
    this.dif = 0.0,
    this.foregroundIndicatorIconBuilder,
    this.selectedIconOpacity = 1.0,
    this.height = 50.0,
    this.borderColorBuilder,
    this.iconAnimationType = AnimationType.onSelected,
    this.indicatorAnimationType = AnimationType.onSelected,
    this.onTap,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    this.foregroundBorder,
    this.foregroundBoxShadow = const [],
    this.boxShadow = const [],
    this.minTouchTargetSize = 48.0,
    this.textDirection,
  })  : this._iconArrangement = IconArrangement.row,
        this._iconsTappable = true,
        super(key: key);

  /// Provides an [AnimatedToggleSwitch] with the standard size animation of the icons.
  ///
  /// Maximum one builder of [iconBuilder] and [customIconBuilder] must be provided.
  AnimatedToggleSwitch.size({
    Key? key,
    required this.current,
    required this.values,
    SimpleSizeIconBuilder<T>? iconBuilder,
    SizeIconBuilder<T>? customIconBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    this.indicatorSize = const Size(48.0, double.infinity),
    this.onChanged,
    this.borderWidth = 2,
    this.borderColor,
    this.innerColor,
    this.indicatorColor,
    this.colorBuilder,
    iconSize = const Size(23.0, 23.0),
    selectedIconSize = const Size(34.5, 34.5),
    this.iconAnimationCurve = Curves.easeOutBack,
    this.iconAnimationDuration,
    this.iconOpacity = 0.5,
    this.borderRadius,
    this.dif = 0.0,
    this.foregroundIndicatorIconBuilder,
    this.selectedIconOpacity = 1.0,
    this.height = 50.0,
    this.borderColorBuilder,
    this.iconAnimationType = AnimationType.onSelected,
    this.indicatorAnimationType = AnimationType.onSelected,
    this.onTap,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    this.foregroundBorder,
    this.foregroundBoxShadow = const [],
    this.boxShadow = const [],
    this.minTouchTargetSize = 48.0,
    this.textDirection,
  })  : animatedIconBuilder = _iconSizeBuilder<T>(
            iconBuilder, customIconBuilder, iconSize, selectedIconSize),
        this._iconArrangement = IconArrangement.row,
        this._iconsTappable = true,
        super(key: key);

  /// All size values ([indicatorWidth], [iconSize], [selectedIconSize]) are relative to the specified height.
  /// (So an [indicatorWidth] of 1.0 means equality of [height] - 2*[borderWidth] and [indicatorWidth])
  ///
  /// Maximum one builder of [iconBuilder] and [customIconBuilder] must be provided.
  AnimatedToggleSwitch.sizeByHeight({
    Key? key,
    this.height = 50.0,
    required this.current,
    required this.values,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    Size indicatorSize = const Size(1.0, 1.0),
    SimpleSizeIconBuilder<T>? iconBuilder,
    SizeIconBuilder<T>? customIconBuilder,
    this.onChanged,
    this.borderWidth = 2,
    this.borderColor,
    this.innerColor,
    this.indicatorColor,
    this.colorBuilder,
    iconSize = const Size(0.5, 0.5),
    selectedIconSize = const Size(0.75, 0.75),
    this.iconAnimationCurve = Curves.easeOutBack,
    this.iconAnimationDuration,
    this.iconOpacity = 0.5,
    this.borderRadius,
    dif = 0.0,
    this.foregroundIndicatorIconBuilder,
    this.selectedIconOpacity = 1.0,
    this.borderColorBuilder,
    this.iconAnimationType = AnimationType.onSelected,
    this.indicatorAnimationType = AnimationType.onSelected,
    this.onTap,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    this.foregroundBorder,
    this.foregroundBoxShadow = const [],
    this.boxShadow = const [],
    this.minTouchTargetSize = 48.0,
    this.textDirection,
  })  : this.indicatorSize = indicatorSize * (height - 2 * borderWidth),
        this.dif = dif * (height - 2 * borderWidth),
        animatedIconBuilder = _iconSizeBuilder<T>(
            iconBuilder,
            customIconBuilder,
            iconSize * (height + 2 * borderWidth),
            selectedIconSize * (height + 2 * borderWidth)),
        this._iconArrangement = IconArrangement.row,
        this._iconsTappable = true,
        super(key: key);

  static AnimatedIconBuilder<T>? _iconSizeBuilder<T>(
      SimpleSizeIconBuilder<T>? iconBuilder,
      SizeIconBuilder<T>? customIconBuilder,
      Size iconSize,
      Size selectedIconSize) {
    assert(iconBuilder == null || customIconBuilder == null);
    if (customIconBuilder == null && iconBuilder != null)
      customIconBuilder = (c, l, g) => iconBuilder(l.value, l.iconSize);
    return customIconBuilder == null
        ? null
        : (context, local, global) => customIconBuilder!(
              context,
              SizeProperties.fromAnimated(
                  iconSize: Size(
                      iconSize.width +
                          (selectedIconSize.width - iconSize.width) *
                              local.animationValue,
                      iconSize.height +
                          (selectedIconSize.height - iconSize.height) *
                              local.animationValue),
                  properties: local),
              global,
            );
  }

  /// Another version of [AnimatedToggleSwitch.custom].
  ///
  /// All size values ([indicatorWidth]) are relative to the specified height.
  /// (So an [indicatorWidth] of 1.0 means equality of [height] - 2*[borderWidth] and [indicatorWidth])
  ///
  /// Consider using [CustomAnimatedToggleSwitch] for maximum customizability.
  const AnimatedToggleSwitch.customByHeight({
    Key? key,
    this.height = 50.0,
    required this.current,
    required this.values,
    this.animatedIconBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    Size indicatorSize = const Size(1.0, 1.0),
    this.onChanged,
    this.borderWidth = 2,
    this.borderColor,
    this.innerColor,
    this.indicatorColor,
    this.colorBuilder,
    this.iconAnimationCurve = Curves.easeOutBack,
    this.iconAnimationDuration,
    this.iconOpacity = 0.5,
    this.borderRadius,
    dif = 0.0,
    this.foregroundIndicatorIconBuilder,
    this.selectedIconOpacity = 1.0,
    this.borderColorBuilder,
    this.iconAnimationType = AnimationType.onSelected,
    this.indicatorAnimationType = AnimationType.onSelected,
    this.onTap,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    this.foregroundBorder,
    this.foregroundBoxShadow = const [],
    this.boxShadow = const [],
    this.minTouchTargetSize = 48.0,
    this.textDirection,
  })  : this.dif = dif * (height - 2 * borderWidth),
        this.indicatorSize = indicatorSize * (height - 2 * borderWidth),
        this._iconArrangement = IconArrangement.row,
        this._iconsTappable = true,
        super(key: key);

  /// Special version of [AnimatedToggleSwitch.customByHeight].
  ///
  /// It is not recommended to use [indicatorSize] and [selectedIconSize]
  /// but use the foreground argument of [iconBuilder] to determine which size to use.
  /// If you still want to get the sizes in the builder, you have to use the [customIconBuilder] instead of [iconBuilder].
  ///
  /// All size values ([indicatorWidth], [indicatorSize], [selectedIconSize]) are relative to the specified height.
  /// (So an [indicatorWidth] of 1.0 means equality of [height] - 2*[borderWidth] and [indicatorWidth])
  ///
  /// Maximum one builder of [iconBuilder] and [customIconBuilder] must be provided.
  AnimatedToggleSwitch.rollingByHeight({
    Key? key,
    this.height = 50.0,
    required this.current,
    required this.values,
    SimpleRollingIconBuilder<T>? iconBuilder,
    RollingIconBuilder<T>? customIconBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    Size indicatorSize = const Size(1.0, 1.0),
    this.onChanged,
    this.borderWidth = 2,
    this.borderColor,
    this.innerColor,
    this.indicatorColor,
    this.colorBuilder,
    double iconRadius = 0.25,
    double selectedIconRadius = 0.35,
    this.iconOpacity = 0.5,
    this.borderRadius,
    double dif = 0.0,
    this.borderColorBuilder,
    this.indicatorAnimationType = AnimationType.onSelected,
    this.onTap,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    this.foregroundBorder,
    this.foregroundBoxShadow = const [],
    this.boxShadow = const [],
    this.minTouchTargetSize = 48.0,
    this.textDirection,
  })  : this.iconAnimationCurve = Curves.linear,
        this.dif = dif * (height - 2 * borderWidth),
        this.iconAnimationDuration = Duration.zero,
        this.indicatorSize = indicatorSize * (height - 2 * borderWidth),
        this.selectedIconOpacity = iconOpacity,
        this.iconAnimationType = AnimationType.onSelected,
        this.foregroundIndicatorIconBuilder =
            _rollingForegroundIndicatorIconBuilder<T>(
                values,
                iconBuilder,
                customIconBuilder,
                Size.square(
                    selectedIconRadius * 2 * (height - 2 * borderWidth))),
        animatedIconBuilder = _standardIconBuilder(
            iconBuilder,
            customIconBuilder,
            Size.square(iconRadius * 2 * (height - 2 * borderWidth)),
            Size.square(iconRadius * 2 * (height - 2 * borderWidth))),
        this._iconArrangement = IconArrangement.row,
        this._iconsTappable = true,
        super(key: key);

  /// Defining a rolling animation using the [foregroundIndicatorIconBuilder] of [AnimatedToggleSwitch].
  ///
  /// It is not recommended to use [indicatorSize] and [selectedIconSize]
  /// but use the foreground argument of [iconBuilder] to determine which size to use.
  /// If you still want to get the sizes in the builder, you have to use the [customIconBuilder] instead of [iconBuilder].
  ///
  /// Maximum one builder of [iconBuilder] and [customIconBuilder] must be provided.
  AnimatedToggleSwitch.rolling({
    Key? key,
    required this.current,
    required this.values,
    SimpleRollingIconBuilder<T>? iconBuilder,
    RollingIconBuilder<T>? customIconBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    this.indicatorSize = const Size(46.0, double.infinity),
    this.onChanged,
    this.borderWidth = 2,
    this.borderColor,
    this.innerColor,
    this.indicatorColor,
    this.colorBuilder,
    double iconRadius = 11.5,
    double selectedIconRadius = 16.1,
    this.iconOpacity = 0.5,
    this.borderRadius,
    this.dif = 0.0,
    this.height = 50.0,
    this.borderColorBuilder,
    this.indicatorAnimationType = AnimationType.onSelected,
    this.onTap,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    this.foregroundBorder,
    this.foregroundBoxShadow = const [],
    this.boxShadow = const [],
    this.minTouchTargetSize = 48.0,
    this.textDirection,
  })  : this.iconAnimationCurve = Curves.linear,
        this.iconAnimationDuration = Duration.zero,
        this.selectedIconOpacity = iconOpacity,
        this.iconAnimationType = AnimationType.onSelected,
        this.foregroundIndicatorIconBuilder =
            _rollingForegroundIndicatorIconBuilder<T>(values, iconBuilder,
                customIconBuilder, Size.square(selectedIconRadius * 2)),
        this.animatedIconBuilder = _standardIconBuilder(
            iconBuilder,
            customIconBuilder,
            Size.square(iconRadius * 2),
            Size.square(iconRadius * 2)),
        this._iconArrangement = IconArrangement.row,
        this._iconsTappable = true,
        super(key: key);

  static CustomIndicatorBuilder<T> _rollingForegroundIndicatorIconBuilder<T>(
      List<T> values,
      SimpleRollingIconBuilder<T>? iconBuilder,
      RollingIconBuilder<T>? customIconBuilder,
      Size iconSize) {
    assert(iconBuilder == null || customIconBuilder == null);
    if (customIconBuilder == null && iconBuilder != null)
      customIconBuilder =
          (c, l, g) => iconBuilder(l.value, l.iconSize, l.foreground);
    return (context, global) {
      if (customIconBuilder == null) return SizedBox();
      double distance = global.dif + global.indicatorSize.width;
      double angleDistance = distance /
          iconSize.longestSide *
          2 *
          (global.textDirection == TextDirection.rtl ? -1.0 : 1.0);
      final pos = global.position;
      int first = pos.floor();
      double transitionValue = pos - first;
      return Stack(
        children: [
          Transform.rotate(
            angle: transitionValue * angleDistance,
            child: Opacity(
                opacity: 1 - transitionValue,
                child: customIconBuilder(
                    context,
                    RollingProperties(
                      iconSize: iconSize,
                      foreground: true,
                      value: values[first],
                      index: first,
                    ),
                    global)),
          ),
          if (first != pos)
            Transform.rotate(
              angle: (transitionValue - 1) * angleDistance,
              child: Opacity(
                  opacity: transitionValue,
                  child: customIconBuilder(
                      context,
                      RollingProperties(
                        iconSize: iconSize,
                        foreground: true,
                        value: values[pos.ceil()],
                        index: first,
                      ),
                      global)),
            ),
        ],
      );
    };
  }

  static AnimatedIconBuilder<T>? _standardIconBuilder<T>(
      SimpleRollingIconBuilder<T>? iconBuilder,
      RollingIconBuilder<T>? customIconBuilder,
      Size iconSize,
      Size selectedIconSize) {
    assert(iconBuilder == null || customIconBuilder == null);
    if (customIconBuilder == null && iconBuilder != null)
      customIconBuilder =
          (c, l, g) => iconBuilder(l.value, l.iconSize, l.foreground);
    return customIconBuilder == null
        ? null
        : (t, local, global) => customIconBuilder!(
              t,
              RollingProperties.fromLocal(
                  iconSize: iconSize, foreground: false, properties: local),
              global,
            );
  }

  /// Defining an rolling animation using the [foregroundIndicatorIconBuilder] of [AnimatedToggleSwitch].
  ///
  /// Maximum one builder of [iconBuilder] and [customIconBuilder] must be provided.
  /// Maximum one builder of [textBuilder] and [customTextBuilder] must be provided.
  AnimatedToggleSwitch.dual({
    Key? key,
    required this.current,
    required T first,
    required T second,
    SimpleIconBuilder<T>? iconBuilder,
    IconBuilder<T>? customIconBuilder,
    SimpleIconBuilder<T>? textBuilder,
    AnimatedIconBuilder<T>? customTextBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    this.indicatorSize = const Size(46.0, double.infinity),
    this.onChanged,
    this.borderWidth = 2,
    this.borderColor,
    this.innerColor,
    this.indicatorColor,
    this.colorBuilder,
    double iconRadius = 16.1,
    this.borderRadius,
    this.dif = 40.0,
    this.height = 50.0,
    this.iconAnimationDuration = const Duration(milliseconds: 500),
    this.iconAnimationCurve = Curves.easeInOut,
    this.borderColorBuilder,
    this.indicatorAnimationType = AnimationType.onHover,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    Function()? onTap,
    this.foregroundBorder,
    this.foregroundBoxShadow = const [],
    this.boxShadow = const [],
    this.minTouchTargetSize = 48.0,
    this.textDirection,
    EdgeInsetsGeometry textMargin = const EdgeInsets.symmetric(horizontal: 8.0),
  })  : this.iconOpacity = 1.0,
        this.selectedIconOpacity = 1.0,
        this.values = [first, second],
        this.iconAnimationType = AnimationType.onHover,
        this.onTap = onTap ?? _dualOnTap(onChanged, [first, second], current),
        this.foregroundIndicatorIconBuilder =
            _rollingForegroundIndicatorIconBuilder(
                [first, second],
                iconBuilder == null ? null : (v, s, f) => iconBuilder(v),
                customIconBuilder,
                Size.square(iconRadius * 2)),
        this.animatedIconBuilder = _dualIconBuilder(
            textBuilder,
            customTextBuilder,
            Size.square(iconRadius * 2),
            [first, second],
            textMargin),
        this._iconArrangement = IconArrangement.overlap,
        this._iconsTappable = false,
        super(key: key);

  static Function() _dualOnTap<T>(
      Function(T)? onChanged, List<T> values, T current) {
    return () =>
        onChanged?.call(values.firstWhere((element) => element != current));
  }

  static AnimatedIconBuilder<T>? _dualIconBuilder<T>(
      SimpleIconBuilder<T>? textBuilder,
      AnimatedIconBuilder<T>? customTextBuilder,
      Size iconSize,
      List<T> values,
      EdgeInsetsGeometry textMargin) {
    assert(textBuilder == null || customTextBuilder == null);
    return (context, local, global) {
      bool start = local.index == 0;
      int index = start ? 1 : 0;
      T value = values[index];
      return Padding(
        padding: textMargin,
        child: Align(
          alignment: start
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd,
          child: Opacity(
              opacity: 1 - local.animationValue,
              child: textBuilder?.call(value) ??
                  customTextBuilder?.call(
                    context,
                    local.copyWith(
                      value: value,
                      index: index,
                    ),
                    global,
                  )),
        ),
      );
    };
  }

  // END OF CONSTRUCTOR SECTION

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    BorderRadiusGeometry borderRadius = this.borderRadius ??
        BorderRadius.all(
          Radius.circular(height / 2),
        );
    Color indicatorColor = this.indicatorColor ?? theme.colorScheme.secondary;

    return CustomAnimatedToggleSwitch<T>(
        animationCurve: animationCurve,
        animationDuration: animationDuration,
        fittingMode: fittingMode,
        dif: dif,
        height: height,
        onTap: onTap,
        current: current,
        values: values,
        onChanged: onChanged,
        indicatorSize: indicatorSize,
        iconArrangement: _iconArrangement,
        iconsTappable: _iconsTappable,
        minTouchTargetSize: minTouchTargetSize,
        textDirection: textDirection,
        backgroundIndicatorBuilder: foregroundIndicatorIconBuilder != null
            ? null
            : (context, properties) => _indicatorBuilder(
                context, properties, indicatorColor, borderRadius),
        foregroundIndicatorBuilder: foregroundIndicatorIconBuilder == null
            ? null
            : (context, properties) => _indicatorBuilder(
                context, properties, indicatorColor, borderRadius),
        iconBuilder: (context, local, global) => _animatedOpacityIcon(
            _animatedSizeIcon(context, local, global), local.value == current),
        padding: EdgeInsets.all(borderWidth),
        wrapperBuilder: (context, properties, child) =>
            TweenAnimationBuilder<Color?>(
              duration: animationDuration,
              tween: ColorTween(
                begin: borderColorBuilder?.call(current) ??
                    borderColor ??
                    theme.colorScheme.secondary,
                end: borderColorBuilder?.call(current) ??
                    borderColor ??
                    theme.colorScheme.secondary,
              ),
              builder: (c, color, _) => Container(
                clipBehavior: Clip.hardEdge,
                foregroundDecoration: BoxDecoration(
                  border: Border.all(color: color!, width: borderWidth),
                  borderRadius: borderRadius,
                ),
                decoration: BoxDecoration(
                  color: innerColor ?? theme.scaffoldBackgroundColor,
                  borderRadius: borderRadius,
                  boxShadow: boxShadow,
                ),
                child: child,
              ),
            ));
  }

  Widget _indicatorBuilder(
      BuildContext context,
      DetailedGlobalToggleProperties<T> properties,
      Color indicatorColor,
      BorderRadiusGeometry borderRadius) {
    double pos = properties.position;
    return indicatorAnimationType == AnimationType.onSelected
        ? TweenAnimationBuilder<Color?>(
        child: foregroundIndicatorIconBuilder?.call(context, properties),
            duration: animationDuration,
            tween: ColorTween(
                begin: indicatorColor,
                end: colorBuilder?.call(current) ?? indicatorColor),
            builder: (c, color, child) => _customIndicatorBuilder(
                properties.indicatorSize, color!, borderRadius, child))
        : _customIndicatorBuilder(
            properties.indicatorSize,
            Color.lerp(
                    colorBuilder?.call(values[pos.floor()]) ?? indicatorColor,
                    colorBuilder?.call(values[pos.ceil()]) ?? indicatorColor,
                    pos - pos.floor()) ??
                indicatorColor,
            borderRadius,
            foregroundIndicatorIconBuilder?.call(context, properties));
  }

  Widget _animatedSizeIcon(BuildContext context, LocalToggleProperties<T> local,
      DetailedGlobalToggleProperties<T> global) {
    if (animatedIconBuilder == null) return SizedBox();
    switch (iconAnimationType) {
      case AnimationType.onSelected:
        return TweenAnimationBuilder(
          curve: iconAnimationCurve,
          duration: iconAnimationDuration ?? animationDuration,
          tween: Tween<double>(
              begin: 0.0, end: local.value == global.current ? 1.0 : 0.0),
          builder: (c, value, child) {
            return animatedIconBuilder!(
              c,
              AnimatedToggleProperties.fromLocal(
                  animationValue: value as double, properties: local),
              global,
            );
          },
        );
      case AnimationType.onHover:
        double animationValue = 0.0;
        double localPosition =
            global.position - global.position.floorToDouble();
        if (values[global.position.floor()] == local.value)
          animationValue = 1 - localPosition;
        else if (values[global.position.ceil()] == local.value)
          animationValue = localPosition;
        return animatedIconBuilder!(
          context,
          AnimatedToggleProperties.fromLocal(
              animationValue: animationValue, properties: local),
          global,
        );
    }
  }

  Widget _animatedOpacityIcon(Widget icon, bool active) {
    return iconOpacity >= 1.0 && selectedIconOpacity >= 1.0
        ? icon
        : AnimatedOpacity(
            opacity: active ? selectedIconOpacity : iconOpacity,
            duration: animationDuration,
            child: icon,
          );
  }

  Widget _customIndicatorBuilder(Size size, Color color,
      BorderRadiusGeometry borderRadius, Widget? child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: foregroundBorder,
        boxShadow: foregroundBoxShadow,
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
