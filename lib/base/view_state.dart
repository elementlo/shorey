///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2/4/21
/// Description:
///


///页面状态类型
enum ViewState {
  idle,//空闲
  loading,//加载中
  empty,//无数据
  error,//加载失败
}

///错误类型
enum ViewStateErrorType {
  defaultError,
  networkTimeoutError,//网络超时
  unauthorizedError,//未授权（一般为未登录）
}

class ViewStateError {
  ViewStateErrorType _errorType;
  String message;
  String errorMessage;

  ViewStateError(this._errorType, {this.message, this.errorMessage}) {
    _errorType ??= ViewStateErrorType.defaultError;
    message ??= errorMessage;
  }
  ViewStateErrorType get errorType => _errorType;

  @override
  String toString() {
    return 'ViewStateError{_errorType: $_errorType, message: $message, errorMessage: $errorMessage}';
  }


}