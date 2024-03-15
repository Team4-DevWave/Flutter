import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentScreenNotifier extends StateNotifier<int> 
{
  CurrentScreenNotifier() : super(0);
  int _previousScreen = 0;
  void  updateCurrentScreen(int screen)
  {
    _previousScreen = state;
    state  = screen;
  }
  void returnToPrevious()
  {
    state = _previousScreen;
  }
}

final currentScreenProvider = StateNotifierProvider<CurrentScreenNotifier, int>((ref){
   return CurrentScreenNotifier();
});