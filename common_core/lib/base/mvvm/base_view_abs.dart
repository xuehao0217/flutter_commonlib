/// ViewModel 侧可见的页面能力：加载态、Toast、以及一次性 [initData]。
abstract class AbsBaseView {
  void showLoading();

  void hideLoading();

  void showToast(String string);

  void initData();
}