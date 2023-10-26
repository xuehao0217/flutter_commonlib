
import 'package:flutter_commonlib/base/mvvm/base_view_model.dart';
import 'package:get/state_manager.dart';

import '../../widget/state_layout.dart';

class LoadingStateViewModel extends BaseViewModel{

  final Rx<LoadState> loadState = Rx<LoadState>(LoadState.State_Loading);

}