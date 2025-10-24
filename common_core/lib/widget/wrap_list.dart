import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  WrapList<String>(
    items: ["苹果", "香蕉", "橘子", "哈密瓜", "火龙果", "樱桃"],
    spacing: 12,
    runSpacing: 12,
    padding: const EdgeInsets.all(16),
    itemBuilder: (context, item, index) {
      return Chip(label: Text(item));
    },
  );
}

class WrapList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  const WrapList({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.spacing = 8,
    this.runSpacing = 8,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Wrap(
        spacing: spacing, // 主轴间距
        runSpacing: runSpacing, // 交叉轴间距（换行后行距）
        alignment: WrapAlignment.start,
        children: List.generate(items.length, (index) {
          return itemBuilder(context, items[index], index);
        }),
      ),
    );
  }
}
