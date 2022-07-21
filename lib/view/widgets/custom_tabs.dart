import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';

class CustomTabs extends StatelessWidget {
  final TabController tabController;
  final List<Widget> children;
  final Function onTab;
  final bool isBill;

  CustomTabs(
      {this.tabController, this.children, this.onTab, this.isBill = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.0),
          child: TabBar(
            onTap: onTab,
            controller: tabController,
            indicatorColor: kPrimaryColor,
            labelColor: fourthColor,
            unselectedLabelColor: secondColor.withOpacity(0.8),
            unselectedLabelStyle:
                TextStyle(fontSize: 13.0, fontFamily: 'Cairo'),
            tabs: [
              Tab(text: isBill ? 'المنتظرة' : 'المنتجات'),
              Tab(text: isBill ? 'المقبولة' : 'العروض'),
              Tab(text: isBill ? 'المرفوضة' : 'تعرفة الشركة'),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          child: TabBarView(controller: tabController, children: children),
        ),
      ],
    );
  }
}
