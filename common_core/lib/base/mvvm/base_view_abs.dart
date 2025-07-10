import 'dart:io';

abstract class AbsBaseView {
  void showLoading();

  void hideLoading();

  void showToast(String string);

  void initData();
}