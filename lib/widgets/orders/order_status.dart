// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/services/order_services.dart';
import 'package:seller/widgets/orders/rider_list.dart';

Widget statusContainer(DocumentSnapshot document, BuildContext context) {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  GeoPoint? _shopLocation;
  if ((document.data() as Map<String, dynamic>)['deliveryMan']['name'].length >
      1) {
    return (document.data() as Map<String, dynamic>)['deliveryMan']['image'] ==
            null
        ? Container()
        : ListTile(
            onTap: () {},
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.network(
                (document.data() as Map<String, dynamic>)['deliveryMan']
                    ['image'],
              ),
            ),
            title: Text((document.data() as Map<String, dynamic>)['deliveryMan']
                ['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    GeoPoint location = (document.data()
                        as Map<String, dynamic>)['deliveryMan']['location'];
                    _orderServices.launchMap(
                        location,
                        (document.data() as Map<String, dynamic>)['deliveryMan']
                            ['name']);
                  },
                  icon: Icon(
                    Icons.map,
                    color: Colors.purple.shade900,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _orderServices.launchCall((document.data()
                        as Map<String, dynamic>)['deliveryMan']['phone']);
                  },
                  icon: Icon(
                    Icons.phone,
                    color: Colors.purple.shade900,
                  ),
                ),
              ],
            ),
          );
  }
  if ((document.data() as Map<String, dynamic>)['orderStatus'] == 'Accepted') {
    return SizedBox(
      width: GlobalStyles.screenWidth(context) - 40,
      child: TextButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.blue,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0)))),
        onPressed: () {
          print('Pressed');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeliveryRiderList(document);
              });
        },
        label: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Assign Rider',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
  if ((document.data() as Map<String, dynamic>)['orderStatus'] == 'Rejected') {
    return SizedBox(
      width: GlobalStyles.screenWidth(context) - 40,
      child: const Text(
        'Order Rejected',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  GlobalStyles.green,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0)))),
            onPressed: () {
              _orderServices.showMyDialog(
                  'Accept Order', 'Accepted', document.id, context);
            },
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Accept',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          AbsorbPointer(
            absorbing:
                (document.data() as Map<String, dynamic>)['orderStatus'] ==
                        'Rejected'
                    ? true
                    : false,
            child: TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: (document.data()
                              as Map<String, dynamic>)['orderStatus'] ==
                          'Rejected'
                      ? MaterialStateProperty.all<Color>(
                          Colors.grey,
                        )
                      : MaterialStateProperty.all<Color>(
                          Colors.red,
                        ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0)))),
              onPressed: () {
                _orderServices.showMyDialog(
                    'Reject Order', 'Rejected', document.id, context);
              },
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Reject',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
