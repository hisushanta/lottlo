import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String user;
  final String itemPositionInCloude;
  final int itemPositionInLocally;
  final Function(String, int) removeOrder;
  final String item;
  final String number;
  final String price;
  final String totalPrice;
  final String plan;
  final String bookingDate;
  final String estimatedDeliveryDate;
  final String status;
  final String imageUrl;
  final String orderConfirmedDate;
  final String outForDeliveryDate;
  final String deliveredDate;
  final String quantity;
  final String time;
  final String address;

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
    required this.plan,
    required this.bookingDate,
    required this.estimatedDeliveryDate,
    required this.status,
    required this.imageUrl,
    required this.orderConfirmedDate,
    required this.outForDeliveryDate,
    required this.deliveredDate,
    required this.quantity,
    required this.time,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product Title
              Center(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Details Section
              _buildDetailCard('User', user),
              _buildDetailCard('Number', number),
              _buildDetailCard('Item Price', price, isPrice: true),
              _buildDetailCard('Total Price', totalPrice, isPrice: true),
              _buildDetailCard('Plan', plan),
              _buildDetailCard('Quantity', quantity),
              _buildDetailCard('Booking Date', bookingDate),
              _buildDetailCard('Time', time.isEmpty ? "Soon" : time),
              _buildDetailCard('Address', address),
              _buildDetailCard('Estimated Delivery Date', estimatedDeliveryDate),
              _buildStatusCard('Status', status),
              const SizedBox(height: 16),
              _buildDeliveryTimeline(),
              const SizedBox(height: 16),
              // Cancel Order Button
              _buildCancelOrderButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, {bool isPrice = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
                  color: isPrice ? Colors.deepOrange : Colors.black,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value) {
    return _buildDetailCard(
      title,
      value,
      isPrice: false,
    );
  }


  Widget _buildCancelOrderButton(BuildContext context) {
    bool canCancel = status != 'Delivered';
    return Center(
      child: ElevatedButton.icon(
        onPressed: canCancel
            ? () {
                removeOrder(itemPositionInCloude, itemPositionInLocally);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order canceled successfully')),
                );
              }
            : null,
        icon: const Icon(Icons.cancel,color: Colors.white),
        label: const Text('Cancel Order',style:TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          backgroundColor: canCancel ? Colors.redAccent : Colors.grey.shade50,
        ),
      ),
    );
  }



  Widget _buildDeliveryTimeline() {
    List<String> steps = ['Order Confirmed', 'Out For Delivery', 'Delivered'];
    List<String> deliveryDates = [orderConfirmedDate, outForDeliveryDate, deliveredDate];
    int currentIndex = steps.indexOf(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child:Text(
          'Delivery Timeline',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
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

}
