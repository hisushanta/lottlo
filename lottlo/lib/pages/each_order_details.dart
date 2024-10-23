import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String user;
  final String itemPositionInCloude;
  final int itemPositionInLocally;
  final Function(String,int) removeOrder;
  final String item;
  final String number;
  final String price;
  final String totalPrice;
  final String size;
  final String bookingDate;
  final String bookingTime;
  final String estimatedDeliveryDate;
  final String status;
  final String imageUrl;
  final String orderConfirmedDate;
  final String outForDeliveryDate;
  final String deliveredDate;
  final String quantity;

  const ProductDetailsScreen({
    Key? key,
    required this.user,
    required this.itemPositionInCloude,
    required this.itemPositionInLocally,
    required this.removeOrder,
    required this.item,
    required this.number,
    required this.price,
    required this.totalPrice,
    required this.size,
    required this.bookingDate,
    required this.bookingTime,
    required this.estimatedDeliveryDate,
    required this.status,
    required this.imageUrl,
    required this.orderConfirmedDate,
    required this.outForDeliveryDate,
    required this.deliveredDate,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$item Details', style: const TextStyle(fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 16),
              Center(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailCard('User', user),
              _buildDetailCard('Number', number),
              _buildDetailCard('Item Price', price, isPrice: true),
              _buildDetailCard('Total Price', totalPrice, isPrice: true),
              _buildDetailCard('Size', size),
              _buildDetailCard('Quantity', quantity),
              _buildDetailCard('Date of Purchase', bookingDate),
              _buildDetailCard('Est. Delivery Date', estimatedDeliveryDate),
              _buildStatusCard('Status', status),
              const SizedBox(height: 20),
              _buildDeliveryTimeline(),
              const SizedBox(height: 20),
              _buildCancelOrderButton(context), // Add cancel order button
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
    Color statusColor = value == 'Order Confirmed'
        ? Colors.grey
        : value == 'Delivered'
            ? Colors.green
            : Colors.orange;
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
    List<String> steps = ['Order Confirmed', 'Out for Delivery', 'Delivered'];
    List<String> deliveryDates = [orderConfirmedDate, outForDeliveryDate, deliveredDate];
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
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : const Icon(Icons.circle, color: Colors.grey, size: 18),
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
                  deliveryDates[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.grey,
                    fontSize: 14,
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

  Widget _buildCancelOrderButton(BuildContext context) {
    bool canCancel = status != 'Delivered'; // Allow cancellation only if not delivered

    return Center(
      child: ElevatedButton.icon(
        onPressed: canCancel
            ? () {
                removeOrder(itemPositionInCloude,itemPositionInLocally);
                Navigator.of(context).pop();
                // Logic to cancel the order
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order cancelled successfully')),
                );

                // _showCancelConfirmationDialog(context);
              }
            : null,
        icon: const Icon(Icons.cancel),
        label: const Text(
          'Cancel Order',
          style: TextStyle(fontSize: 18,color: Colors.red),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          iconColor: canCancel ? Colors.redAccent : Colors.grey,
          backgroundColor: Colors.indigo[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

}
