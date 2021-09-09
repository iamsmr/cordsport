part of 'bottom_nav_bar_cubit.dart';

class BottomNavBarState extends Equatable {
  final BottomNavItem selctedItem;

  const BottomNavBarState({required this.selctedItem});

  @override
  List<Object> get props => [selctedItem];
}