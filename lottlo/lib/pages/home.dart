import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottlo/main.dart';
import 'order.dart';
import 'watch_order.dart';
import 'about_page.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Track the selected index for the navigation bar
  final List<Widget> _pages = [
    BaseHome(),
    WatchOrder(),
    UserProfilePage() 
  ];
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: _pages[_selectedIndex], // Display content based on selected index
        bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
      
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.amber,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket_sharp),
            label: 'Book',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_box_outlined),
            label: 'About',
          ),
          
        ],
        
      ), 
       
    );
  }
}
class BaseHome extends StatefulWidget {
  @override
  HomePageBar createState() => HomePageBar();
}

class HomePageBar extends State<BaseHome> with TickerProviderStateMixin{
  @override void initState() {
    super.initState();
  }


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
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Lottlo",
            style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: AspectRatio(
              aspectRatio: 1.8, // Slightly adjusted for a better proportion
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24), // Elegant, smooth corners
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/mainIcon.png', 
                    fit: BoxFit.contain, // Avoids cutting and maintains aspect ratio
                  ),
                ),
              ),
            ),
          ),
            // Grid Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 16.0, // Space between columns
                mainAxisSpacing: 16.0, // Space between rows
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
                children: [
                  if (info!.itemInfo.isNotEmpty)
                      for(var item in info!.itemInfo[userId]!)
                        FoodCard(image: info!.imageUrls[item[0]]!, name: item[1], price: item[2], pindex: item[3],isize:item[4]['size'],ititle: item[5],idesc: item[6])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
    );
  }
}

class FoodCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String pindex;
  final List isize;
  final String ititle;
  final String idesc;
  const FoodCard({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.pindex,
    required this.isize,
    required this.ititle,
    required this.idesc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255,241, 222, 198),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                image,
                fit: BoxFit.fill,
                height: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 1),
                Center(child: Text(
                  price,
                  style:  TextStyle(color: Colors.grey[600]),
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:2,horizontal: 10),
         child:ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Circular corners (adjusted for smaller size)
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Smaller padding for compact look
              elevation: 4, // Slightly reduced elevation
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddItemScreen(
                    name: name,
                    price: price,
                    image: image,
                    pindex: pindex,
                    isize: isize,
                    ititle: ititle,
                    idesc: idesc,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min, // Button adjusts based on content size
              children: [
                Icon(Icons.shopping_cart, color: Colors.white, size: 18), // Smaller icon size
                SizedBox(width: 6), // Reduced spacing between icon and text
                Text(
                  'Buy Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14, // Smaller font size for compactness
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          )


        ],
      ),
    );
  }
}
