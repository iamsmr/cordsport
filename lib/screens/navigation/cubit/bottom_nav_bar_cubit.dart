import 'package:bloc/bloc.dart';
import 'package:codespot/enums/enums.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_bar_state.dart';


class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit()
      : super(const BottomNavBarState(selctedItem: BottomNavItem.home));

  void updateSelctedItem(BottomNavItem item) {
    if (item != state.selctedItem) {
      emit(BottomNavBarState(selctedItem: item));
    }
  }
}