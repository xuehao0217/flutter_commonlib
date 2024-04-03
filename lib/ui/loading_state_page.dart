

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/helpter/widget_ext_helper.dart';
import 'package:flutter_commonlib/ui/vm/loading_state_view_model.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../base/mvvm/base_stateful_widget.dart';
import '../widget/common_widget.dart';
import '../widget/state_layout.dart';

class LoadingStatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadingState();
}

class _LoadingState  extends BaseStatefulWidget<LoadingStatePage,LoadingStateViewModel> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      children: [
        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: Colors.blue,
          width: double.infinity,
          height: 50,
          onPressed: ()  {
            viewModel.loadState.value = LoadState.State_Loading;
          },
          child: const Text(
            "State_Loading",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: Colors.blue,
          width: double.infinity,
          height: 50,
          onPressed: ()  {
            viewModel.loadState.value = LoadState.State_Success;
          },
          child: const Text(
            "State_Success",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: Colors.blue,
          width: double.infinity,
          height: 50,
          onPressed: ()  {
            viewModel.loadState.value = LoadState.State_Error;
          },
          child: const Text(
            "State_Error",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        CommonButton(
          elevation: 2,
          circular: 10,
          backgroundColor: Colors.blue,
          width: double.infinity,
          height: 50,
          onPressed: ()  {
            viewModel.loadState.value = LoadState.State_Empty;
          },
          child: const Text(
            "State_Empty",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ).intoPadding(const EdgeInsets.only(bottom: 15, left: 15, right: 15)),

        Obx(() => LoadStateLayout(
          state: viewModel.loadState.value,
          errorMessage: "controller.errorMessage",
          errorRetry: () {
            viewModel.loadState.value = LoadState.State_Loading;
          },
          successWidget: Container(
              width: double.infinity,
              height: 300,
              color: Colors.blue
          ),
        ))
      ],
    );
  }

  @override
  LoadingStateViewModel createViewModel() =>LoadingStateViewModel();

  @override
  void initData() {
  }

}