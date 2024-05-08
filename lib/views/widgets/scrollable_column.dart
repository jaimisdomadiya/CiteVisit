part of 'widgets.dart';

class ScrollableColumn extends StatelessWidget {
  const ScrollableColumn({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding,
    this.primary,
    this.physics,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
    this.isScrollable = true,
  }) : withSafeArea = false;

  const ScrollableColumn.withSafeArea({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding,
    this.primary,
    this.physics,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
    this.isScrollable = true,
  }) : withSafeArea = true;

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis scrollDirection;
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final bool withSafeArea;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    Widget column = Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );

    Widget singleChildScrollView = SingleChildScrollView(
      padding: padding,
      physics: physics,
      primary: primary,
      reverse: reverse,
      controller: controller,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      scrollDirection: scrollDirection,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      child: column,
    );

    Widget child = isScrollable
        ? singleChildScrollView
        : Padding(padding: padding ?? EdgeInsets.zero, child: column);

    return withSafeArea ? SafeArea(child: child) : child;
  }
}

class FlexibleScrollView extends StatelessWidget {
  const FlexibleScrollView({
    super.key,
    this.padding,
    required this.children,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.hasScrollBody = false,
  }) : withSafeArea = false;

  const FlexibleScrollView.withSafeArea({
    super.key,
    this.padding,
    required this.children,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.hasScrollBody = false,
  }) : withSafeArea = true;

  final EdgeInsets? padding;
  final List<Widget> children;
  final bool withSafeArea;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final bool hasScrollBody;

  @override
  Widget build(BuildContext context) {
    Widget child = CustomScrollView(
      reverse: false,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: hasScrollBody,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Column(
              mainAxisSize: mainAxisSize,
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            ),
          ),
        )
      ],
    );
    return withSafeArea ? SafeArea(child: child) : child;
  }
}
