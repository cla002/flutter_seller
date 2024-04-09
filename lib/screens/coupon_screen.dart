// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/screens/add_edit_coupon_screen.dart';
import 'package:seller/services/firebase_services.dart';

// class CouponScreen extends StatefulWidget {
//   const CouponScreen({Key? key}) : super(key: key);

//   static const String id = 'coupon-screen';

//   @override
//   _CouponScreenState createState() => _CouponScreenState();
// }

// class _CouponScreenState extends State<CouponScreen> {
//   var pressCount = 0;

//   @override
//   Widget build(BuildContext context) {
//     FirebaseServices _services = FirebaseServices();
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: GlobalStyles.green,
//         centerTitle: true,
//         title: const Text(
//           'Coupons',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         leading: IconButton(
//           color: Colors.white,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//           ),
//         ),
//       ),
//       body: WillPopScope(
//         onWillPop: () async {
//           Navigator.pop(context);
//           return false;
//         },
//         child: Scaffold(
//           body: Container(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _services.coupons
//                   .where('sellerId', isEqualTo: _services.user!.uid)
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return const Text('Something went wrong');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                     child: Text('No Coupon Added'),
//                   );
//                 }

//                 return Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => AddEditCouponScreen(
//                                       document: ModalRoute.of(context)!
//                                           .settings
//                                           .arguments as DocumentSnapshot),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               'Add New Coupon',
//                               style: TextStyle(
//                                   color: GlobalStyles.green,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18),
//                             )),
//                       ],
//                     ),
//                     SingleChildScrollView(
//                       child: FittedBox(
//                         child: DataTable(
//                           columns: const <DataColumn>[
//                             DataColumn(
//                               label: Text('Title'),
//                             ),
//                             DataColumn(
//                               label: Text('Rate'),
//                             ),
//                             DataColumn(
//                               label: Text('Status'),
//                             ),
//                             DataColumn(
//                               label: Text('Info'),
//                             ),
//                             DataColumn(
//                               label: Text('Info'),
//                             ),
//                           ],
//                           rows: snapshot.data!.docs
//                               .map((DocumentSnapshot document) {
//                             var data = document.data() as Map<String, dynamic>;
//                             var date = data['expiry'].toDate();
//                             var expiry =
//                                 DateFormat.yMMMd().add_jm().format(date);
//                             return DataRow(
//                               cells: [
//                                 DataCell(Text(data['title'].toString())),
//                                 DataCell(Text(data['discountRate'].toString())),
//                                 DataCell(Text(
//                                     data['active'] ? 'Active' : 'Inactive')),
//                                 DataCell(Text(data['details'].toString())),
//                                 DataCell(
//                                   IconButton(
//                                     icon:
//                                         const Icon(Icons.info_outline_rounded),
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               AddEditCouponScreen(
//                                                   document: document),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  static const String id = 'coupon-screen';

  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  var pressCount = 0;

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalStyles.appBarColor,
        centerTitle: true,
        title: const Text(
          'Coupons',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          body: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: services.coupons
                  .where('sellerId', isEqualTo: services.user!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No Coupon Added'),
                  );
                }

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddEditCouponScreen(
                                  document: null,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Add New Coupon',
                            style: TextStyle(
                              color: GlobalStyles.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: FittedBox(
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Title'),
                            ),
                            DataColumn(
                              label: Text('Rate'),
                            ),
                            DataColumn(
                              label: Text('Status'),
                            ),
                            DataColumn(
                              label: Text('Info'),
                            ),
                            DataColumn(
                              label: Text('Info'),
                            ),
                          ],
                          rows: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            var data = document.data() as Map<String, dynamic>;
                            var date = data['expiry'].toDate();
                            var expiry =
                                DateFormat.yMMMd().add_jm().format(date);
                            return DataRow(
                              cells: [
                                DataCell(Text(data['title'].toString())),
                                DataCell(Text(data['discountRate'].toString())),
                                DataCell(Text(
                                    data['active'] ? 'Active' : 'Inactive')),
                                DataCell(Text(data['details'].toString())),
                                DataCell(
                                  IconButton(
                                    icon:
                                        const Icon(Icons.info_outline_rounded),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddEditCouponScreen(
                                            document: document,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
