
import 'package:flutter/material.dart';
import 'package:lottlo/main.dart';
import 'package:lottlo/pages/home.dart';
import 'package:lottlo/pages/each_order_details.dart';

class WatchOrder extends StatefulWidget {
  @override
  _WatchOrder createState() => _WatchOrder();
}

class _WatchOrder extends State<WatchOrder> {
   Map<String, List<List>> orders = info!.orderActiveStatus;
  
  void cancelOrder(String itemPositionInCloude,int itemPositionInLocally) async {
    setState(() {
      info!.removeOrderFromFirestore(itemPositionInCloude,itemPositionInLocally);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/homeIcon.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 4),
            const Text(
              "Machhalo",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      
         
      body: ValueListenableBuilder<bool>(
      valueListenable: info!.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return orders[info!.uuid]!.isEmpty
                ? const Center(
                    child: Text(
                      "No active orders Found",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: orders[userId]!.length,
                    itemBuilder: (context, index) {
                      var order = orders[userId]![index];
                      String isActive = order[7];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to ProductDetailsScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  user: order[4],
                                  itemPositionInCloude: order[8],
                                  itemPositionInLocally: index,
                                  removeOrder: (itemPositionInCloude,itemPositionInLocally) => cancelOrder(itemPositionInCloude,itemPositionInLocally),
                                  item: order[0],
                                  number: order[5],
                                  price: order[2].replaceAll(" ", ""),
                                  totalPrice: order[14].replaceAll(" ",""),
                                  plan: '${order[6]}',
                                  bookingDate: order[9],
                                  estimatedDeliveryDate: order[10] != '0' ? order[10] : '',
                                  status: order[7],
                                  imageUrl: order[1], // Replace with actual image URL
                                  orderConfirmedDate: order[9],
                                  outForDeliveryDate: order[11],
                                  deliveredDate: order[12],
                                  quantity: order[13],
                                  time: order[17],
                                  address: order[15],
                                ),
                              ),
                            );


                          },
                          child: Card(
                            elevation: 6,
                            color: Colors.white,                            
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: isActive=="Order Confirmed"
                                      ? Colors.grey
                                      : isActive == "Out For Delivery"? Colors.orange : Colors.green),
                            ),
                            child: ListTile(
                              leading:  ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  order[1], // Item image URL
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.error,
                                    size: 50,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${order[0]}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                'Plan: ${order[6]} \nPrice: ${order[2].replaceAll(" ","")} \nTotalPrice: ${order[14].replaceAll(" ","")}',
                                    
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                              trailing: Text(
                                "Qty: ${order[13]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isActive=="Order Confirmed"
                                      ? Colors.grey
                                      : isActive == "Out For Delivery"? Colors.orange : Colors.green
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
        
        }
      },
      ),
    );
  }
}
