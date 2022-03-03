import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:spark_list/generated/l10n.dart';
import 'package:spark_list/view_model/config_view_model.dart';
import 'package:spark_list/view_model/link_notion_view_model.dart';
import 'package:spark_list/widget/app_bar.dart';
import 'package:spark_list/widget/category_list_item.dart';
import 'package:spark_list/widget/settings_list_item.dart';
import 'package:spark_list/workflow/notion_workflow.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/11
/// Description:
///
enum _ExpandableSetting { linkNotionAccount, time }

class LinkNotionPage extends StatefulWidget {
  const LinkNotionPage({Key? key}) : super(key: key);

  @override
  _LinkNotionPageState createState() => _LinkNotionPageState();
}

class _LinkNotionPageState extends State<LinkNotionPage>
    with TickerProviderStateMixin {
  late Animation<double> _staggerSettingsItemsAnimation;
  late AnimationController _settingsPanelController;
  _ExpandableSetting? _expandedSettingId;
  final TextEditingController _inputController = TextEditingController();

  void onTapSetting(_ExpandableSetting settingId) {
    setState(() {
      if (_expandedSettingId == settingId) {
        _expandedSettingId = null;
      } else {
        _expandedSettingId = settingId;
      }
    });
  }

  void _closeSettingId(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {
        _expandedSettingId = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _settingsPanelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _settingsPanelController.addStatusListener(_closeSettingId);
    _staggerSettingsItemsAnimation = CurvedAnimation(
      parent: _settingsPanelController,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.easeIn,
      ),
    );
    context.read<NotionWorkFlow>().getUser();
  }

  List<Widget> _buildListItem(BuildContext context) {
    return [
      SettingsListItem<double>(
        title: S.of(context).notion,
        optionsMap: LinkedHashMap.of({
          1.0: DisplayOption(
              '${context.select((LinkNotionViewModel vm) => vm.user?.name ?? '')}')
        }),
        selectedOption: 1.0,
        onOptionChanged: (value) {
          print(value);
        },
        onTapSetting: () => onTapSetting(_ExpandableSetting.linkNotionAccount),
        isExpanded: _expandedSettingId == _ExpandableSetting.linkNotionAccount,
        child: _NotionAccountCard(
          controller: _inputController,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<NotionWorkFlow, LinkNotionViewModel>(
      create: (context) => LinkNotionViewModel(),
      update: (context, workflow, viewModel) {
        viewModel!.setUser = workflow.user;
        context.read<ConfigViewModel>().updateLinkedStatus(workflow.user != null);
        return viewModel;
      },
      child: Scaffold(
        appBar: SparkAppBar(
          context: context,
          title: S.of(context).bindNotion,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 64,
            ),
            child: ListView(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    S.of(context).linkNotionInfo,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                ...[
                  Consumer<LinkNotionViewModel>(
                    builder: (context, vm, child) {
                      return AnimateSettingsListItems(
                        animation: _staggerSettingsItemsAnimation,
                        children: _buildListItem(context),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  //Divider(thickness: 2, height: 0, color: colorScheme.background),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotionAccountCard extends StatefulWidget {
  final TextEditingController controller;

  const _NotionAccountCard({Key? key, required this.controller})
      : super(key: key);

  @override
  State<_NotionAccountCard> createState() => _NotionAccountCardState();
}

class _NotionAccountCardState extends State<_NotionAccountCard> {
  var offStageCard = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = context.watch<LinkNotionViewModel>().user;
    offStageCard = user == null;
    return Container(
      height: 90,
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Offstage(
            offstage: !offStageCard,
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                  labelText: S.of(context).notionToken,
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  suffix: Container(
                    width: 25,
                    height: 25,
                    child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () async {
                          if (widget.controller.text.isNotEmpty) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            EasyLoading.show();
                            final user = await context
                                .read<NotionWorkFlow>()
                                .linkAccount(widget.controller.text);
                            if (user != null) {
                              offStageCard = false;
                              setState(() {});
                            }
                            EasyLoading.dismiss();
                          }
                        },
                        icon: Icon(
                          Icons.check,
                          color: colorScheme.onSecondary,
                        )),
                  ),
                  contentPadding: EdgeInsets.only(top: 10)),
            ),
          ),
          Offstage(
            offstage: offStageCard,
            child: ListTile(
              contentPadding: EdgeInsets.only(
                left: 0,
                right: 0,
              ),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: user?.avatarUrl == ''
                    ? null
                    : NetworkImage(
                        '${user?.avatarUrl}',
                      ),
              ),
              title: Text('${user?.name}'),
              subtitle: Text('${user?.person?.email}'),
              trailing: SizedBox(
                height: 20,
                width: 20,
                child: IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    context.read<NotionWorkFlow>().deleteUser();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
