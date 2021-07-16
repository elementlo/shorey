import 'package:flutter/material.dart';

import 'view_state.dart';
///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///

class ViewStateModel with ChangeNotifier {
  bool _disposed = false;

  ViewState _viewState;
  ViewStateError? _viewStateError;

  ViewStateModel({ViewState? viewState})
      : _viewState = viewState ?? ViewState.idle;

  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
    notifyListeners();
  }

  ViewStateError? get viewStateError => _viewStateError;

  bool get isLoading => viewState == ViewState.loading;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  void setIdle() {
    _viewState = ViewState.idle;
    notifyListeners();
  }

  void setBusy() {
    _viewState = ViewState.loading;
    notifyListeners();
  }

  void setEmpty() {
    _viewState = ViewState.empty;
    notifyListeners();
  }

  void setError({e, stackTrace, String? message}) {
    ViewStateErrorType errorType = ViewStateErrorType.defaultError;
    viewState = ViewState.error;
    _viewStateError = ViewStateError(
      errorType,
      message: message,
      errorMessage: e?.toString(),
    );
    notifyListeners();
  }

  @override
  String toString() {
    return 'ViewStateModel{_viewState: $_viewState, _viewStateError: $_viewStateError}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
