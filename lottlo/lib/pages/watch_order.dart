
import 'package:flutter/material.dart';
import 'package:lottlo/main.dart';
import 'package:lottlo/pages/home.dart';

class WatchOrder extends StatefulWidget {
  @override
  _WatchOrder createState() => _WatchOrder();
}

class _WatchOrder extends State<WatchOrder> {
  final Map<String, List<List>> orders = info!.orderActiveStatus;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: info!.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Your's Order",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            body: orders[info!.uuid]!.isEmpty
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
                      bool isActive = order[7] != 'Submit';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Handle item tap with an animation effect
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 16,
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: order[7] == 'Active' ? Colors.green : Colors.orange,
                                                size: 28,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Details',
                                                style:  TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: order[7] == 'Active' ? Colors.green : Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'User: ${order[4]}',
                                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Item: ${order[0]}',
                                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Number: ${order[5]}',
                                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                                          ),
                                         
                                          const SizedBox(height: 10),
                                          Text(
                                            'Price: ${order[2].replaceAll(" ","")}',
                                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                                          ),
                                          const SizedBox(height: 10),
                                          info!.itemCheck(info!.scrabItem,order[0])?
                                            Text(
                                              'Size: ${order[6]}',
                                              style: const TextStyle(fontSize: 18, color: Colors.black54),
                                            ) :info!.itemCheck(info!.scrapItem2,order[0])?
                                             Text(
                                              'Quantity: ${order[6]}',
                                              style: const TextStyle(fontSize: 18, color: Colors.black54),
                                            ): Text(
                                              'Kg: ${order[6]}',
                                              style: const TextStyle(fontSize: 18, color: Colors.black54),
                                            ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Booking Date: ${order[9]}',
                                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Booking Time: ${order[10]}',
                                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                                          ),
                                          const SizedBox(height: 10),
                                          if(order[11] != '0')
                                            Text(
                                            'Recive Date: ${order[11]}',
                                            style: const TextStyle(fontSize: 18, color: Colors.black54),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Status: ${order[7]}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: order[7] == 'Active' ? Colors.green : Colors.orange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: order[7] == "Active" ? Colors.green[700]: Colors.orange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 12, horizontal: 20),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                          },
                          child: Card(
                            elevation: 6,
                            color: Colors.white,                            
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: isActive
                                      ? Colors.green
                                      : Colors.orange),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: isActive
                                    ? Colors.green[50]
                                    : Colors.orange[50],
                                child: Icon(
                                  Icons.watch,
                                  color: isActive
                                      ? Colors.green[800]
                                      : Colors.orange,
                                ),
                              ),
                              title: Text(
                                '${order[0]}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                info!.itemCheck(info!.scrabItem, order[0])
                                    ? 'Kg: ${order[6]} \nPrice: ${order[2].replaceAll(" ","")}'
                                    :info!.itemCheck(info!.scrapItem2,order[0])
                                    ?'Quantity: ${order[6]} \nPrice: ${order[2].replaceAll(" ","")}'
                                    :"Kg: ${order[6]} \nPrice: ${order[2]}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                              trailing: Text(
                                order[7],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isActive
                                      ? Colors.green[800]
                                      : Colors.orange[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        }
      },
    );
  }
}
