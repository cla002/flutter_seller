import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({
      'orderStatus': status,
    });
    return result;
  }

  void launchCall(String? number) async {
    if (number != null && number.isNotEmpty) {
      String url = 'tel:$number';
      await launch(url);
    } else {
      throw 'Phone number is invalid';
    }
  }

  void launchMap(GeoPoint location, name) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude), title: name);
  }

  showMyDialog(title, status, documentId, context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text('Are you Sure you want to $title?'),
          actions: [
            TextButton(
                onPressed: () {
                  EasyLoading.show(status: 'Updating Status');
                  status == 'Accepted'
                      ? updateOrderStatus(documentId, status).then((value) {
                          EasyLoading.showSuccess('Updated Successfully');
                        })
                      : updateOrderStatus(documentId, status).then((value) {
                          EasyLoading.showSuccess('Updated Successfully');
                        });
                  Navigator.pop(context);
                },
                child: const Text('OK')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          ],
        );
      },
    );
  }
}
