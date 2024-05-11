import 'package:flutter_riverpod/flutter_riverpod.dart';

///This provider class is responsible for storing the index
///of the current screen which we move between 
///from the bottom navigation bar in the main layout screen
class CurrentScreenNotifier extends StateNotifier<int> 
{
  CurrentScreenNotifier() : super(0);
  int _previousScreen = 0;
  void  updateCurrentScreen(int screen)
  {
    _previousScreen = state;
    state  = screen;
  }
  ///This is useful for the add post screen where we want
  ///to go back to the latest screen after returning from it
  void returnToPrevious()
  {
    state = _previousScreen;
  }
}

final currentScreenProvider = StateNotifierProvider<CurrentScreenNotifier, int>((ref){
   return CurrentScreenNotifier();
});