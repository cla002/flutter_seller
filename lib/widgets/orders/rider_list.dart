// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/services/order_services.dart';

class DeliveryRiderList extends StatefulWidget {
  final DocumentSnapshot document;

  const DeliveryRiderList(this.document, {super.key});

  @override
  State<DeliveryRiderList> createState() => _DeliveryRiderListState();
}

class _DeliveryRiderListState extends State<DeliveryRiderList> {
  final FirebaseServices _services = FirebaseServices();
  final OrderServices _orderServices = OrderServices();
  GeoPoint? _shopLocation;

  @override
  void initState() {
    _services.getShopDetails().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _shopLocation = (value.data() as Map<String, dynamic>)['location'];
          });
        }
      } else {
        print('No Data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.0),
      ),
      child: SizedBox(
        height: GlobalStyles.screenWidth(context),
        width: GlobalStyles.screenWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.purple.shade900,
                centerTitle: true,
                title: const Text(
                  'Select Delivery Rider',
                  style: TextStyle(color: Colors.white),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: services.riders
                      .where('accountVerified', isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        GeoPoint location = (document.data()
                            as Map<String, dynamic>)['location'];
                        double distanceInKilometers = _shopLocation == null
                            ? double.infinity
                            : Geolocator.distanceBetween(
                                    _shopLocation!.latitude,
                                    _shopLocation!.longitude,
                                    location.latitude,
                                    location.longitude) /
                                1000;

                        if (distanceInKilometers > 10) {
                          return Container();
                        }

                        String distanceText =
                            '${distanceInKilometers.toStringAsFixed(2)} km';

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                EasyLoading.show(status: 'Assigning Rider');
                                services
                                    .selectedRider(
                                  orderId: widget.document.id,
                                  phone: (document.data()
                                      as Map<String, dynamic>)['mobile'],
                                  name: (document.data()
                                      as Map<String, dynamic>)['name'],
                                  location: (document.data()
                                      as Map<String, dynamic>)['location'],
                                  image: (document.data()
                                      as Map<String, dynamic>)['imageUrl'],
                                  email: (document.data()
                                      as Map<String, dynamic>)['email'],
                                )
                                    .then((value) {
                                  EasyLoading.showSuccess(
                                      'Assigned Delivery Rider');
                                  Navigator.pop(context);
                                });
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.network(
                                  data['imageUrl'],
                                ),
                              ),
                              title: Text(data['name']),
                              subtitle: Text(distanceText),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      GeoPoint location = (document.data()
                                          as Map<String, dynamic>)['location'];
                                      _orderServices.launchMap(
                                          location,
                                          (document.data()
                                              as Map<String, dynamic>)['name']);
                                    },
                                    icon: Icon(
                                      Icons.map,
                                      color: Colors.purple.shade900,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _orderServices.launchCall(data['mobile']);
                                    },
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.purple.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 2,
                              color: Colors.grey,
                            )
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
