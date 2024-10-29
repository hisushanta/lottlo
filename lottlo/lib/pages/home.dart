import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottlo/main.dart';
import 'order.dart';
import 'watch_order.dart';
import 'about_page.dart';
import 'love_page.dart';

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
    LovePage(),
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
            selectedIcon: Icon(Icons.shopping_basket_sharp),
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Book',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite_rounded),
            icon: Icon(Icons.favorite_outline),
            label: 'Love',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_box),
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

class HomePageBar extends State<BaseHome> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<List> _filteredItems = [];
  List<List> _allItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Initialize data if already available
    if (info?.itemInfo[userId]?.isNotEmpty ?? false) {
      _allItems = info!.itemInfo[userId] ?? [];
      _filteredItems = _allItems;
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        final name = item[1].toString().toLowerCase();
        return name.contains(query);
      }).toList();
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
      body: ValueListenableBuilder(
        valueListenable: info!.isLoading,
        builder: (context, bool isLoading, child) {
          // Check if still loading and no data
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Update _allItems if not already set
          if (_allItems.isEmpty && (info?.itemInfo[userId]?.isNotEmpty ?? false)) {
            _allItems = info!.itemInfo[userId] ?? [];
            _filteredItems = _allItems;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search items...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _filteredItems.isNotEmpty
                      ? GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (var item in _filteredItems)
                              FoodCard(
                                image: info!.imageUrls[item[0]]!,
                                name: item[1],
                                price: item[2],
                                pindex: item[3],
                                isize: item[4]['size'],
                                ititle: item[5],
                                idesc: item[6],
                              ),
                          ],
                        )
                      : const Center(child: Text("No items found")),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
    required this.idesc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 241, 222, 198),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Image covers the entire card
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Overlay container for text and button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

