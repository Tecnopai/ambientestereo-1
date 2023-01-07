import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'internet_state.dart';

final internetStateProvider =
    StateNotifierProvider<IsConnectedNotifier, InternetState>((ref) {
  return IsConnectedNotifier(ref);
});

class IsConnectedNotifier extends StateNotifier<InternetState> {
  IsConnectedNotifier(
    this.ref,
  ) : super(InternetState.loading) {
    {
      _applyListener();
    }
  }

  final StateNotifierProviderRef ref;

  _applyListener() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      state = InternetState.disconnected;
    }

    var subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        debugPrint('Checking on internet connection');
        final isConnected = await InternetConnectionChecker().hasConnection;
        if (isConnected) {
          state = InternetState.connected;
        } else {
          state = InternetState.disconnected;
        }
        debugPrint('Internet is connected:$state');
      } else if (result == ConnectivityResult.none) {
        state = InternetState.disconnected;
      } else {
        debugPrint('What the status');
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });
  }
}
