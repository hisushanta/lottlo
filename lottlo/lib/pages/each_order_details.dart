import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String user;
  final String item;
  final String number;
  final String price;
  final String size;
  final String bookingDate;
  final String bookingTime;
  final String estimatedDeliveryDate;
  final String status;
  final String imageUrl;
  final String orderConfirmedDate; // New parameter for order confirmed date
  final String outForDeliveryDate; // New parameter for out for delivery date
  final String deliveredDate; // New parameter for delivered date
  final String quantity;

  const ProductDetailsScreen({
    Key? key,
    required this.user,
    required this.item,
    required this.number,
    required this.price,
    required this.size,
    required this.bookingDate,
    required this.bookingTime,
    required this.estimatedDeliveryDate,
    required this.status,
    required this.imageUrl,
    required this.orderConfirmedDate, // Pass the order confirmed date here
    required this.outForDeliveryDate, // Pass the out for delivery date here
    required this.deliveredDate, // Pass the delivered date here
    required this.quantity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$item Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailCard('User', user),
              _buildDetailCard('Item', item),
              _buildDetailCard('Number', number),
              _buildDetailCard('Price', price, isPrice: true),
              _buildDetailCard('Size', size),
              _buildDetailCard('Quantity', quantity),
              _buildDetailCard('Date of Purchase', bookingDate),
              _buildDetailCard('Est. Delivery Date', estimatedDeliveryDate),
              _buildStatusCard('Status', status),
              const SizedBox(height: 20),
              _buildDeliveryTimeline(), // Pass delivery dates here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, {bool isPrice = false}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
                color: isPrice ? Colors.deepOrange : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value) {
    Color statusColor = value == 'Order Confirmed' ? Colors.grey : value == "Delivered" ? Colors.green : Colors.orange;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTimeline() {
    // Delivery steps
    List<String> steps = ['Order Confirmed', 'Out for Delivery', 'Delivered'];
    // Corresponding delivery dates
    List<String> deliveryDates = [orderConfirmedDate, outForDeliveryDate, deliveredDate];
    // Get the index of the current status
    int currentIndex = steps.indexOf(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Timeline',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            bool isActive = index <= currentIndex;

            return Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.green : Colors.grey,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: isActive
                        ? Icon(Icons.check, color: Colors.white, size: 18)
                        : Icon(Icons.circle, color: Colors.grey, size: 18),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  deliveryDates[index], // Display delivery date under each step
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.grey,
                    fontSize: 14, // Slightly smaller font for date
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 10),
        Container(
          height: 4,
          color: Colors.grey,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length - 1, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  color: index < currentIndex ? Colors.green : Colors.grey,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
