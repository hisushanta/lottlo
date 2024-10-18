

import 'package:flutter/material.dart';
import 'package:lottlo/main.dart';

class AddItemScreen extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final String pindex;
  final List isize;
  final String ititle;
  final String idesc;
  const AddItemScreen({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    required this.pindex,
    required this.isize,
    required this.ititle,
    required this.idesc
  }) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  int selectedSizeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                      image: AssetImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 12),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
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
                    "Available Sizes",
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
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            decoration: BoxDecoration(
                              gradient: selectedSizeIndex == index
                                  ? const LinearGradient(colors: [
                                      Colors.greenAccent,
                                      Colors.green
                                    ])
                                  : null,
                              color: selectedSizeIndex == index
                                  ? null
                                  : Colors.white,
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
                  
                  // Phone Number Input
                  const Text(
                    "Contact Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone, color: Colors.green),
                      labelStyle: const TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  // Price and Buy Button Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.price}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle Buy action
                          DateTime now = DateTime.now();
                          String date = "${now.day}/${now.month}/${now.year}";
                          String period = now.hour >= 12 ? 'pm' : 'am';
                          String time = "${now.hour}:${now.minute}$period";
                          if (_phoneNumberController.text.isNotEmpty){
                            if(_phoneNumberController.text.length == 10){
                              info!.addOrder(widget.name,widget.image,widget.price,widget.pindex,info!.getUserName(),
                                    _phoneNumberController.text,"Submit",widget.isize[selectedSizeIndex],date,time,'0');
                              Navigator.pop(context);
                            } else{
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please check the phone number"),
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.red,
                              ),
                            ); 
                            }
                            
                          } else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter the phone number"),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      
  }
}

