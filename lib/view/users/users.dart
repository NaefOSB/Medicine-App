import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class Users extends StatelessWidget {
  final String userType;
  String searchText;

  Users({this.userType,this.searchText});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('accountType', isEqualTo: userType)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.docs.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final user = snapshot.data.docs[index];
              if(user['storeName'].toString().contains(searchText) || user['userName'].toString().contains(searchText)){
                return ListTile(
                  title: Text('${user['storeName']}'),
                  subtitle: Text('${user['userName']}'),
                  leading: Icon(Icons.person),
                  trailing: Container(
                    width: size.width * 0.3,
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     IconButton(
                    //         icon: Icon(
                    //           Icons.delete,
                    //           size: 18.0,
                    //         ),
                    //         onPressed: () {}),
                    //     IconButton(
                    //         icon: Icon(
                    //           Icons.pause,
                    //           size: 18.0,
                    //         ),
                    //         onPressed: () {}),
                    //   ],
                    // ),
                  ),
                );
              }else{
                return Container();

              }
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return CustomText(
            alignment: Alignment.center,
            title: 'حدث خطأ، الرجاء المحاولة لاحقاً',
            color: fourthColor,
          );
        } else {
          return CustomText(
            alignment: Alignment.center,
            title: 'لاتوجد اي بيانات حالياً ..',
            color: fourthColor,
          );
        }
      },
    );
  }
}
