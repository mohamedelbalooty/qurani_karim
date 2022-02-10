import 'package:flutter/material.dart';

class MyPopUpMenuItem<T> extends PopupMenuItem<T> {
  final Function onClick;
  final Widget child;
  final T value;

  const MyPopUpMenuItem(
      {@required this.child, @required this.onClick, this.value})
      : super(child: child, value: value);

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopUpMenuItemState();
  }
}

class MyPopUpMenuItemState<T, PopUpMenuItem>
    extends PopupMenuItemState<T, MyPopUpMenuItem<T>> {
  @override
  void handleTap() {
    widget.onClick();
  }
}