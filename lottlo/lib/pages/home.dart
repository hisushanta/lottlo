import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottlo/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'order.dart';
import 'watch_order.dart';
import 'about_page.dart';
import 'love_page.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;
String _selectedSortOrder = 'Default'; // Default sort order

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
    const BaseHome(),
    WatchOrder(),
    LovePage(),
    const UserProfilePage() 
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
  const BaseHome({super.key});
  static Function(String)? filterByCategory; // Expose a callback

  @override
  HomePageBar createState() => HomePageBar();
}

class HomePageBar extends State<BaseHome> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<List> _filteredItems = [];
  List<List> _allItems = [];


  @override
  void initState() {
    super.initState();
    // Assign the filter callback
    BaseHome.filterByCategory = (String category) {
      setState(() {
        _filteredItems = _allItems.where((item) {
          return item[7].toLowerCase().contains(category.toLowerCase()); // Update with your condition
        }).toList();
        FocusScope.of(context).unfocus();
      });
    };
    _searchController.addListener(_onSearchChanged);
    // Initialize data if already available
    if (info?.itemInfo[userId]?.isNotEmpty ?? false) {
      _allItems = info!.getItem();
      _filteredItems = List.from(_allItems);
      applySortOrderForInit();
    }
  }
  void applySortOrderForInit() {
    
      if (_selectedSortOrder == 'Low to High') {
        _filteredItems.sort((a, b) {
          final priceA = double.tryParse(a[2].split("₹")[1]) ?? 0.0; // Assuming price is at index 2
          final priceB = double.tryParse(b[2].split("₹")[1]) ?? 0.0;
          return priceA.compareTo(priceB);
        });
      } else if (_selectedSortOrder == 'High to Low') {
        _filteredItems.sort((a, b) {
          final priceA = double.tryParse(a[2].split("₹")[1]) ?? 0.0;
          final priceB = double.tryParse(b[2].split("₹")[1]) ?? 0.0;
          return priceB.compareTo(priceA);
        });
      }
  }
  // Utility method to normalize text by removing special characters and spaces
  String _normalizeText(String text) {
    return text.toLowerCase() // Convert to lowercase
        .replaceAll(RegExp(r"[^\w\s]"), '') // Remove special characters
        .replaceAll(RegExp(r'\s+'), ''); // Remove spaces
  }

  // Updated search function
  void _onSearchChanged() {
    final query = _normalizeText(_searchController.text); // Normalize search query
    setState(() {
      _filteredItems = _allItems.where((item) {
        final name = _normalizeText(item[1].toString()); // Normalize item name
        return name.contains(query); // Check if the item name contains the normalized query
      }).toList();
      _applySortOrder();
    });
  }


  void _showFilterDialog() {
      ValueNotifier<String> _tempSelectedSortOrder = ValueNotifier<String>(_selectedSortOrder);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.grey[100],
            title: const Center(
              child: Text(
                "Filter Options",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Sort by Price Label with Icon
                const Row(
                  children: [
                    Icon(Icons.sort, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      "Sort by Price",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Sort Order Dropdown
                ValueListenableBuilder<String>(
                  valueListenable: _tempSelectedSortOrder,
                  builder: (context, value, child) {
                    return DropdownButtonFormField<String>(
                      value: value,
                      items: <String>['Low to High', 'High to Low',"Default"]
                          .map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Row(
                            children: [
                              Icon(
                                option == 'Low to High'
                                    ? Icons.arrow_upward
                                    : option == "High to Low"
                                    ? Icons.arrow_downward
                                    :Icons.shuffle,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 8),
                              Text(option),
                            ],
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onChanged: (newValue) {
                        _tempSelectedSortOrder.value = newValue!;
                      },
                    );
                  },
                ),
              ],
            ),
            actions: <Widget>[
              // Buttons Row with Apply and Cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _selectedSortOrder = _tempSelectedSortOrder.value;
                      _applySortOrder();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }



  void _applySortOrder() {
    setState(() {
      if (_selectedSortOrder == 'Low to High') {
        _filteredItems.sort((a, b) {
          final priceA = double.tryParse(a[2].split("₹")[1]) ?? 0.0; // Assuming price is at index 2
          final priceB = double.tryParse(b[2].split("₹")[1]) ?? 0.0;
          return priceA.compareTo(priceB);
        });
      } else if (_selectedSortOrder == 'High to Low') {
        _filteredItems.sort((a, b) {
          final priceA = double.tryParse(a[2].split("₹")[1]) ?? 0.0;
          final priceB = double.tryParse(b[2].split("₹")[1]) ?? 0.0;
          return priceB.compareTo(priceA);
        });
      } else{
        final query = _searchController.text.toLowerCase();
        _filteredItems = List.from(_allItems.where((item) {
        final name = item[1].toString().toLowerCase();
        return name.contains(query);
      }).toList());
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocuses the TextField when tapping outside of it
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector( 
          child:Row(
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
        onTap: (){
          setState(() {
            _selectedSortOrder = "Default";     
            _allItems = info!.getItem();
            _filteredItems = List.from(_allItems);
            _searchController.text = "";
            applySortOrderForInit();   
            FocusScope.of(context).unfocus();

          });
         },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      
      drawer:const CustomDrawer(),
        
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
            _allItems = info!.getItem();
            _filteredItems = List.from(_allItems);
            applySortOrderForInit();
          }

         return Column(
            children: [
              // Fixed Search Bar and Filter Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: "Search items...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        _showFilterDialog();
                      },
                    ),
                  ],
                ),
              ),

              // Scrollable Content Below
              Expanded(
                child: _filteredItems.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return FoodCard(
                            image: info!.imageUrls[item[0]]!,
                            name: item[1],
                            price: item[2],
                            pindex: item[3],
                            isize: item[4]['size'],
                            ititle: item[5],
                            idesc: item[6],
                          );
                        },
                      )
                    : const Center(
                        child: Text("No items found"),
                      ),
              ),
            ],
          );
        },
      ),
      ),
    );
    
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header Section
          Container(
            height: 200, 
            width: double.maxFinite, // Set the height to cover the entire space
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 224, 223, 221)],
              ),
            ),
            child: const DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,  // Adjust the radius as per your needs
                    backgroundImage: AssetImage('assets/homeIcon.png'), // Replace with your logo
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lottlo',
                    style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  ),
                  
                ],
              ),
              
              ),
            ),

          // Menu Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (var key in info!.categories.keys)
                  if (key != "singleOption")
                    _buildMenuTile(
                      context,
                      title: key,
                      children: [
                        for (var item in info!.categories[key]!)
                          _buildSubMenuTile(context, item,key),
                      ],
                    ) else
                        for(var item in info!.categories[key]!)
                          _buildSubMenuTile(context,item,"Nothig")
                  
              ],
            ),
          ),

          // Footer Section
          GestureDetector(
            child:Container(
            color: Colors.amber.shade50,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.help_outline, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  "Need Help?",
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          onTap: (){
            _launchEmail('lottloapp@gmail.com');
          },
          ),
        ],
      ),
    );
  }
  
  Future<void> _launchEmail(String email) async {
      final Uri emailUri = Uri.parse('mailto:$email');
      if (!await launchUrl(emailUri)) {
        throw 'Could not launch $email';
      }
    }
  // Main Menu Item with Expansion Tile
  Widget _buildMenuTile(BuildContext context, {required String title, required List<Widget> children}) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      children: children,    
    );
  }

  // Submenu Tile for individual options
  Widget _buildSubMenuTile(BuildContext context, String title,String category) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {
        itemSearch(title,category,context);
        // Implement navigation logic or state change
      },
    );
  }

  void itemSearch(String query,String category, BuildContext context) {
    // Pass the filter query to BaseHome using a global method or state management
    if (category == "men" || category == "women"){
      query = "$category/$query";
    } 
    BaseHome.filterByCategory!(query);
    Navigator.pop(context); // Close the drawer after selection
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
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.pindex,
    required this.isize,
    required this.ititle,
    required this.idesc,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 241, 222, 198),
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
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
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

