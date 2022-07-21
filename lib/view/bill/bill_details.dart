import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/bill_details_view_model.dart';
import 'package:medicine_app/view/widgets/custom_bill_details_stream.dart';
import 'package:medicine_app/view/widgets/custom_floating_admin_button.dart';
import 'package:medicine_app/view/widgets/custom_search.dart';
import 'package:medicine_app/view/widgets/custom_tabs.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BillDetails extends StatefulWidget {
  String billNumber;
  String storeId;
  String userId;

  BillDetails({this.billNumber, this.storeId, this.userId});

  @override
  _BillDetailsState createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails>
    with SingleTickerProviderStateMixin {
  BillDetailsViewModel controller = Get.find();

  @override
  void initState() {
    controller.tabController = TabController(length: 3, vsync: this);
    controller.tabController.addListener(() {
      controller.changeButtonText(controller.tabController.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<BillDetailsViewModel>(
        builder: (controller) => ModalProgressHUD(
          inAsyncCall: controller.isLoading,
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'تفاصيل الطلب رقم  ${widget.billNumber}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: fourthColor,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: fourthColor,
                ),
                onPressed: () => Get.back(),
              ),
              centerTitle: true,
            ),
            body: Container(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 15.0),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                        padding: EdgeInsets.only(right: 15.0, left: 20.0),
                        child: CustomSearch(
                          searchController: controller.searchController,
                          onIconPressed: () {
                            setState(() {
                              controller.searchController.clear();
                            });
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        )),
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 50.0,
                    // margin: EdgeInsets.only(bottom: size.height * 0.1),
                    child: CustomTabs(
                      onTab: (index) {
                        print(index);
                      },
                      isBill: true,
                      tabController: controller.tabController,
                      children: [
                        CustomBillDetailsStream(
                          storeId: widget.storeId,
                          billNumber: widget.billNumber,
                          textController: controller.searchController,
                          state: 'waiting',
                          isAccepted: false,
                          isRejected: false,
                          userId: widget.userId,
                          isStoreAdmin:
                              UserStorage().getUserInfo().id == widget.storeId,
                        ),
                        CustomBillDetailsStream(
                          storeId: widget.storeId,
                          billNumber: widget.billNumber,
                          textController: controller.searchController,
                          state: 'accepted',
                          isAccepted: true,
                          isRejected: false,
                          userId: widget.userId,
                          isStoreAdmin:
                              UserStorage().getUserInfo().id == widget.storeId,
                        ),
                        CustomBillDetailsStream(
                          storeId: widget.storeId,
                          billNumber: widget.billNumber,
                          textController: controller.searchController,
                          state: 'rejected',
                          isAccepted: false,
                          isRejected: true,
                          userId: widget.userId,
                          isStoreAdmin:
                              UserStorage().getUserInfo().id == widget.storeId,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton:
                (UserStorage().getUserInfo().id == widget.storeId)
                    ? GetBuilder<BillDetailsViewModel>(
                        builder: (controller) => CustomFloatingAdminButton(
                          text: controller.selectedTextButton,
                          onTap: () => controller.floatingButtonProcess(
                              userId: widget.userId, billId: widget.billNumber),
                        ),
                      )
                    : Container(),
          ),
        ),
      ),
    );
  }
}
