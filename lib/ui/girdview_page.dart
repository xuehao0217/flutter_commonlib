import 'package:common_core/base/base_stateless_widget.dart';
import 'package:common_core/common_core.dart';
import 'package:common_core/widget/common_gridview.dart';
import 'package:flutter/material.dart';


class GridviewPage extends BaseStatelessWidget {
  @override
  Widget buildContent(BuildContext context) {
    return CommonGridView<String>(
      items: ['A', 'B', 'C', 'D', 'E', 'F'],
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1,
      header: Text(
        "🔥 Popular Items",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ).withCenter(),
      footer: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "— End of List —",
          style: TextStyle(color: Colors.grey),
        ).withCenter(),
      ),
      emptyView: Center(child: Text("😕 No Items Available")),
      itemViewBuilder: ( item, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(item),
        );
      },
    );
  }
}
