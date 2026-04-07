import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_core/base/mvvm/base_vm_stateful_widget.dart';
import 'package:common_core/widget/common_listview.dart';
import 'package:common_core/widget/refresh_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commonlib/ui/vm/refresh_list_view_model.dart';
import 'package:get/get.dart';

import '../entity/home_list_entity.dart';

class RefreshListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RefreshListPage();
}

class _RefreshListPage
    extends BaseVMStatefulWidget<RefreshListPage, RefreshListViewModel> {
  @override
  void initData() {}

  @override
  createViewModel() => RefreshListViewModel();

  @override
  Widget buildPageContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(
      () => SmartRefresherListView(
        viewModel: viewModel,
        listView: CommonListView.buildListView<HomeListDataDatas>(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          items: viewModel.datas,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (item, index) =>
              _listItem(context, cs, viewModel.datas[index]),
        ),
      ),
    );
  }

  Widget _listItem(
    BuildContext context,
    ColorScheme cs,
    HomeListDataDatas item,
  ) {
    final tt = Theme.of(context).textTheme;
    final thumb = item.envelopePic.trim();
    final meta = [item.author, item.niceDate]
        .where((s) => s.trim().isNotEmpty)
        .join(' · ');

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 76,
                height: 76,
                child: thumb.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: thumb,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ColoredBox(
                          color: cs.surfaceContainerHigh,
                        ),
                        errorWidget: (context, url, error) =>
                            _thumbFallback(cs),
                      )
                    : _thumbFallback(cs),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      meta,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (item.desc.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.92),
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbFallback(ColorScheme cs) {
    return ColoredBox(
      color: cs.surfaceContainerHigh,
      child: Icon(
        Icons.article_outlined,
        color: cs.outline,
        size: 32,
      ),
    );
  }
}
