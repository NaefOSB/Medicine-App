import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/users/users.dart';
import 'package:medicine_app/view/widgets/custom_search.dart';

class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              'إدارة الحسابات',
              style: TextStyle(color: fourthColor, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: fourthColor,
              ),
            ),
            brightness: Brightness.dark,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                // for search text field
                Container(
                    padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
                    child: CustomSearch(
                      searchController: _searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      onIconPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          setState(() {
                            _searchController.clear();
                          });
                        }
                      },
                    )),

                // FOR TAPS
                Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: kPrimaryColor,
                    labelColor: fourthColor,
                    unselectedLabelColor: secondColor.withOpacity(0.8),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 13.0, fontFamily: 'Cairo'),
                    tabs: [Tab(text: 'العملاء'), Tab(text: 'الموردين')],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(controller: _tabController, children: [
                    Users(
                      userType: 'CLIENT',
                      searchText: _searchController.text,
                    ),
                    Users(
                      userType: 'SUPPLIER',
                      searchText: _searchController.text,
                    ),
                  ]),
                ),
              ],
            ),
          )),
    );
  }
}
