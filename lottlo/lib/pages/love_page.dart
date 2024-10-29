import 'package:flutter/material.dart';
import 'order.dart';
import 'package:lottlo/main.dart';

class LovePage extends StatelessWidget {
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
              "Lottlo",
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
            return info!.loveItem[info!.uuid]!.isEmpty
                ? const Center(child: Text("No favorite items found"))
                : Padding(
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
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      item[0], // Item image
                                      height: 300,
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
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item[1], // Item name
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.currency_rupee_rounded, color: Colors.green),
                                              Text(
                                                item[2].split("₹")[1], // Item price
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green[200],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            item[4], // Item short title
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            item[5], // Full description
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.checkroom, color: Colors.blueAccent),
                                              const SizedBox(width: 4),
                                              Text(
                                                "Available sizes: ${(item[6]['isize'] as List).join(', ')}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          }
        },
      ),
    );
  }
}
