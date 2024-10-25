import 'package:flutter/material.dart';
import 'order.dart';
import 'package:lottlo/main.dart';

class LovePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child:Text(
          'Favorites',
          style: TextStyle(
            fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.black
          ),
        ),),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: ListView.builder(
          itemCount: info!.loveItem[info!.uuid]!.length,
          itemBuilder: (context, index) {
            final item = info!.loveItem[info!.uuid]![index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemScreen(
                      name: item[1],
                      price: item[2],
                      image: item[0],
                      pindex: item[3],
                      isize: item[6]['isize'],
                      ititle: item[4],
                      idesc: item[5],
                    ),
                  ),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: Colors.deepPurpleAccent.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          item[0], // Item image
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.pinkAccent),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.error,
                            size: 100,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item[1], // Item name
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.currency_rupee_rounded, color: Colors.green),
                                Text(
                                  item[2].split("₹")[1], // Item price
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              item[4], // Item short title
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item[5], // Full description
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,

                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.checkroom, color: Colors.blueAccent),
                                SizedBox(width: 4),
                                Text(
                                  "Available sizes: ${(item[6]['isize'] as List).join(', ')}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
