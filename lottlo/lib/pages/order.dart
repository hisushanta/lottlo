// import 'package:flutter/material.dart';
import 'package:lottlo/main.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddItemScreen extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final String pindex;
  final List isize;
  final String ititle;
  final String idesc;
  String updatePrice = "";

  AddItemScreen({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    required this.pindex,
    required this.isize,
    required this.ititle,
    required this.idesc,
  }) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  int selectedSizeIndex = 0;
  int quantity = 1;
  Icon iconb = Icon(Icons.favorite_border,color: Colors.black,);
  bool likeOrNot = false;
  DateTime? selectedDate;

  @override
  void initState() {
    widget.updatePrice = widget.price.split("/")[0];
    if (info!.checkLoveHave(widget.pindex)){
      iconb = Icon(Icons.favorite_rounded,color: Colors.red,);
      likeOrNot = true;
    } else{
      likeOrNot = false;
    }
    super.initState();
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Users can't pick past dates
      lastDate: DateTime.now().add(const Duration(days: 365)), // Limit selection to a year from now
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Widget _buildDeliveryPromise() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPromiseItem(
            Icons.local_shipping_outlined,
            'FREE Delivery',
            'Your Grace delivery is assured within 24 hours from the date of booking.',
            Colors.green,
          ),
          // const Divider(height: 1),
          // _buildPromiseItem(
          //   Icons.replay_outlined,
          //   '10 Days Return Policy',
          //   'Easy returns within 10 days',
          //   Colors.blue,
          // ),
          const Divider(height: 1),
          _buildPromiseItem(
            Icons.payment_outlined,
            'Cash On Delivery Available',
            'Pay upon receiving grace.',
            Colors.orange,
          ),
          const Divider(height: 1),
          _buildPromiseItem(
            Icons.cancel_outlined,
            'Cancellation Anytime',
            'Free cancellation for anytime',
            Colors.red,
          ),
          const Divider(height: 1),
          _buildPromiseItem(
            Icons.replay_outlined,
            'Return Policy',
            'Check at delivery—return if not okay.',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildPromiseItem(IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: iconb,
            onPressed: () {
              setState(() {
                if (likeOrNot ){
                    iconb = Icon(Icons.favorite_border,color:Colors.black);
                    info!.removeLoveFromFirestore(widget.pindex);
                    likeOrNot = false;
                } else{
                  iconb = Icon(Icons.favorite_rounded,color:Colors.red);
                  info!.addLove(widget.image, widget.name, widget.price, widget.pindex, widget.isize, widget.ititle, widget.idesc);
                  likeOrNot = true;
                }
              });
              // Handle favorite action
            },
          ),
        ],
      ),
        
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Text Overlay
              Stack(
                children: [
                  Container(
                    height: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(widget.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.ititle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Product Title and Description
              Text(
                widget.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.idesc,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),

              // Size Selector Section
              const Text(
                "Available Plan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(widget.isize.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSizeIndex = index;
                          if (index == 0){
                            widget.updatePrice = "₹${double.parse(widget.price.split("₹")[1].split("/")[0]) * quantity}";
                          } else if (index == 1){
                            widget.updatePrice = "₹${double.parse(widget.price.split("/")[1])*quantity}";
                          } else{
                            widget.updatePrice = "₹${double.parse(widget.price.split("/")[2])*quantity}";
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          gradient: selectedSizeIndex == index
                              ? const LinearGradient(
                                  colors: [Colors.greenAccent, Colors.green])
                              : null,
                          color: selectedSizeIndex == index ? null : Colors.white,
                          border: Border.all(
                            color: selectedSizeIndex == index
                                ? Colors.green
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            if (selectedSizeIndex == index)
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.6),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                          ],
                        ),
                        child: Text(
                          widget.isize[index],
                          style: TextStyle(
                            color: selectedSizeIndex == index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 30),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                          if (selectedSizeIndex == 0){
                            widget.updatePrice = "₹${double.parse(widget.price.split("/")[0].split("₹")[1]) * quantity}";
                          } else if (selectedSizeIndex == 1){
                            widget.updatePrice = "₹${double.parse(widget.price.split("/")[1]) * quantity}";
                          } else{
                            widget.updatePrice = "₹${double.parse(widget.price.split("/")[2]) * quantity}";
                          }
                        } else {
                          if (selectedSizeIndex == 0){
                            widget.updatePrice = widget.price.split("/")[0];
                          } else if (selectedSizeIndex == 1){
                            widget.updatePrice = "₹${widget.price.split("/")[1]}";
                          } else{
                            widget.updatePrice = "₹${widget.price.split("/")[2]}";
                          }
                        }
                      });
                    },
                    color: Colors.redAccent,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.tealAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.teal, width: 1.5),
                    ),
                    child: Text(
                      '$quantity kg',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 30),
                    onPressed: () {
                      setState(() {
                        quantity++;
                        if (selectedSizeIndex == 0){
                            widget.updatePrice = "₹${double.parse(widget.price.split("/")[0].split("₹")[1]) * quantity}";
                          } else if (selectedSizeIndex == 1){
                            widget.updatePrice = "₹${double.parse(widget.price.split("/")[1]) * quantity}";
                          } else{
                            widget.updatePrice = "₹${double.parse(widget.price.split("/")[2]) * quantity}";
                          }
                      });
                    },
                    color: Colors.greenAccent,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Select Booking Date",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                            : "Select a Date",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.black54),
                    ],
                  ),
                ),
              ),

              _buildDeliveryPromise(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.updatePrice,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a booking date."),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          // Proceed with order confirmation, using `selectedDate`.
                          // Add it to the `addOrder` method or anywhere relevant:
                          DateTime bookingDate = selectedDate!;

                          DateTime today = DateTime.now();
                          DateTime estimatedDate;
                          String date = "${today.day}/${today.month}/${today.year}";

                          // Check if selected date is today
                          if (bookingDate.year == today.year &&
                              bookingDate.month == today.month &&
                              bookingDate.day == today.day) {
                            // Estimate for next day
                            estimatedDate = bookingDate.add(const Duration(days: 1));
                          } else {
                            // Future date is itself
                            estimatedDate = bookingDate;
                          }

                          String futureDate = "${estimatedDate.day}/${estimatedDate.month}/${estimatedDate.year}";

                          // DateTime bookingDate = selectedDate!;  
                          // String date =
                          //     "${bookingDate.day}/${bookingDate.month}/${bookingDate.year}";
                          // DateTime dateAfterThreeDays =
                          //     bookingDate.add(const Duration(days: 1));
                          // String futureDate =
                          //     "${dateAfterThreeDays.day}/${dateAfterThreeDays.month}/${dateAfterThreeDays.year}";

                          if (info!.checkHaveNumberOrAddress()) {
                            info!.addOrder(
                              widget.name,
                              widget.image,
                              "₹${double.parse(widget.updatePrice.split("₹")[1])/quantity}",
                              widget.pindex,
                              info!.getDetails('username'),
                              info!.getDetails('number'),
                              "Order Confirmed",
                              widget.isize[selectedSizeIndex],
                              date,
                              futureDate,
                              '',
                              '',
                              quantity.toString(),
                              widget.updatePrice,
                              info!.getDetails('address'),
                              info!.getDetails("email"),
                              ""
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please Add The Address And Number"),
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.shopping_bag_outlined,
                            color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          backgroundColor: Colors.green,
                          elevation: 6,
                          shadowColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        label: const Text(
                          'Buy Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
      ),
    );
  }
}
