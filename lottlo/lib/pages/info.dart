import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class ItemInfo{
  String? uuid;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String,List<List>> itemInfo = {};
  Map<String,List> categories = {};
  Map<String,String> imageUrls = {};
  Map<String,List<List>> orderActiveStatus = {};
  Map<String,List<List>> loveItem = {};
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true); // To track loading state
  Map<String, Map<String, dynamic>> userProfile = {}; // New map for user profile

  ItemInfo(this.uuid) {
    itemInfo[uuid!] = [];
    orderActiveStatus[uuid!] = [];
    loveItem[uuid!] = [];
    imageUrls = {};
    userProfile[uuid!] = {}; // Initialize user profile
    _initializeData();
    // Initialize the data if have
  }

  Future<void> _initializeData() async {
      await _loadDataFromFirestore();
      _setupListeners();
      isLoading.value = false; // Mark loading as complete
    }

  Future<void> _loadDataFromFirestore() async {
    if (uuid != null) {
      var data = await _firestore.collection('Item').doc('lottlo').get();
      var baseItem = data.data()!['item'];
      List<List> itemStore = [];
      for (var key in baseItem.keys){
        itemStore.add(baseItem[key]);
      }
      itemInfo[uuid!] = itemStore;

      // Categories Store
      var cdata = await _firestore.collection("Item").doc("lottlo").get();
      var baseCategory = cdata.data()!['categories'];
      for (var key in baseCategory.keys){
        categories[key]= baseCategory[key];
      }
      // Extract the singleOption list
      List<dynamic> singleOptionList = categories['singleOption']!;

      // Remove singleOption from the map
      categories.remove('singleOption');

      // Add singleOption to the end of the map
      categories['singleOption'] = singleOptionList;
    }
     // Love order store 
     var loveData = await _firestore.collection('users').doc(uuid).collection('love').get();
     var baseLoveData = loveData.docs.map((doc){
      var ddata = doc.data();
      return ddata;
     }).toList();
     if (baseLoveData.isNotEmpty){
      List<List> ddlove = [];
      for (var i in (List.generate( baseLoveData.length, (i) => i))){
        for (var key in baseLoveData[i].keys){
          ddlove.add(baseLoveData[i][key]);
        }
      }
      loveItem[uuid!] = ddlove;
     }

    // Active order get
    var orderActive = await _firestore.collection('users').doc(uuid).collection('order').get();
    var subOrder = orderActive.docs.map((doc) {
      var data = doc.data();
      return data;
    }).toList();
    if(subOrder.isNotEmpty){
          List<List> damOrder = [];
          for (var i in (List.generate(subOrder.length, (i) => i))){
            for (var key in subOrder[i].keys){
            damOrder.add(subOrder[i][key]);
            }
            
          }
          orderActiveStatus[uuid!] = damOrder;
        }
    
    // Load user profile
    var userProfileData = await _firestore.collection('users').doc(uuid).get();
    if (userProfileData.exists) {
      try{
        userProfile[uuid!] = {
          'username': userProfileData['username'],
          'profileImage': userProfileData['profileImage'],
          'address': userProfileData['address'],
          'email': userProfileData['email'],
          'number': userProfileData['number']
        };
      } catch(e){
        updateUserProfile("Unknown", "assets/mainIcon.png", '','','');
      }
    }else{
      updateUserProfile("Unknown", "assets/mainIcon.png", '','','');
    }
  
  // Get all images
  imageUrls = await getAllImageUrls();
  }
  List<List> getItem(){
    return List.from(itemInfo[uuid]!);
  }
  Future<Map<String,String>> getAllImageUrls() async {
    Map<String,String> localImageUrls = {};
    
    try {
      // Reference to the folder in Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('assets'); // Replace 'your_folder' with your folder path
      final ListResult result = await ref.listAll();
      
      for (final Reference fileRef in result.items) {
        String downloadUrl = await fileRef.getDownloadURL();
        localImageUrls[fileRef.fullPath] = downloadUrl;
      }
    } catch (e) {
      print('Error retrieving image URLs: $e');
    }
    
    return localImageUrls;
  }


  String getDetails(String checkToGet){
    if (checkToGet == 'username'){
      return userProfile[uuid]!['username'];
    } else if( checkToGet == 'number'){
      return userProfile[uuid]!['number'];
    } 
    else if (checkToGet == "email"){
      return userProfile[uuid]!['email'];
    } else{
      return userProfile[uuid]!['address'];
    }
  }
  
  
 bool checkHaveNumberOrAddress(){
  
  if (userProfile[uuid]!['address'].isNotEmpty && userProfile[uuid]!["number"].isNotEmpty){
    return true;
  } 
  return false;
 }
  void _setupListeners() {
    if (uuid != null) {
      // Listen to alert changes
      _firestore.collection('users').doc(uuid).collection('order').snapshots().listen((snapshot) {
        var item = snapshot.docs.map((doc) {
          var data = doc.data();
          return data;
        }).toList();
        if(item.isNotEmpty){
          List<List> damOrder = [];
          for (var i in (List.generate(item.length, (i) => i))){
            for (var key in item[i].keys){
            damOrder.add(item[i][key]);
            }
          }
          orderActiveStatus[uuid!] = damOrder;
        }
      });

      // love to load
      _firestore.collection('users').doc(uuid).collection('love').snapshots().listen((snapshot){
          var baseLoveData = snapshot.docs.map((doc){
          var ddata = doc.data();
          return ddata;
        }).toList();
        if (baseLoveData.isNotEmpty){
          List<List> ddlove = [];
          for (var i in (List.generate( baseLoveData.length, (i) => i))){
            for (var key in baseLoveData[i].keys){
              ddlove.add(baseLoveData[i][key]);
            }
          }
          loveItem[uuid!] = ddlove;
        } else{
          loveItem[uuid!] = [];
        }
      });
     
      
    }
  }
  bool itemCheck(List<String>listOfItem,String itemName){
    if (listOfItem.contains(itemName)) {
        return true;
      } else {
        return false;
      }
  }
  Future<void> updateUserProfile(String username, String profileImage, String address,String email, String number) async {
    if (uuid != null) {
      var userRef = _firestore.collection('users').doc(uuid);
      await userRef.set({
        'username': username,
        'profileImage': profileImage,
        'address': address,
        'email': email,
        'number': number,
      }, SetOptions(merge: true));
      print("UserProfile: $username,$profileImage,$address,$email,$number");

      // Update local data
      userProfile[uuid!] = {
        'username': username,
        'profileImage': profileImage,
        'address': address,
        'email': email,
        'number':number,
      };
    }
  }

  // Method to remove an order from Firestore
Future<void> removeOrderFromFirestore(String orderId,int index) async {
  if (uuid != null) {
    //first locally delete:
    orderActiveStatus[uuid]!.removeAt(index);
    // Access the Firestore collection for the user's orders
    var docRef = _firestore
        .collection('users')
        .doc(uuid)
        .collection('order')
        .doc(orderId);

    // Delete the order document
    await docRef.delete();
  }
}

Future<void> removeLoveFromFirestore(String loveId) async{
  if (uuid != null){
    var docRef = _firestore
        .collection('users')
        .doc(uuid)
        .collection('love')
        .doc(loveId);
    
    //Delete the love document
    await docRef.delete();
  }
}


  Future<void> _saveOrderToFirestore(Map<String,List> order,String index) async {
    if (uuid != null) {
      var docRef = _firestore
          .collection('users')
          .doc(uuid)
          .collection('order')
          .doc(index);

      await docRef.set(order);
    }
  }

  Future<void> _saveLoveToFirestore(Map<String,List> item , String index) async{
    if (uuid != null){
      var docRef = _firestore
          .collection('users')
          .doc(uuid)
          .collection('love')
          .doc(index);
      
      await docRef.set(item);
    }
  }
  
  bool checkLoveHave(String pindex){
    for (var item in loveItem[uuid!]!){
      if (item[3] == pindex){
        return true;
      }
    }
    return false;
  }

  void addLove(String image,String itemName, String price,String pindex,List iSize,String iTitle,String idesc){

    _saveLoveToFirestore({"$pindex":[image,itemName,price,pindex,iTitle,idesc,{"isize":iSize}]},pindex.toString());

  }

  void addOrder(String itemName,String image, String price,String pindex, String userName,  String number,
                String status, String size ,String date, String expactedDate,
                String outForOrderDate, String DeliveredDate, String quantity,String totalPrice,String deliveryAddress, String email,
                String time){
      int aindex = 0;
      if (orderActiveStatus[uuid]!.isNotEmpty){
        for (var item in orderActiveStatus[uuid]!){
          if (int.parse(item[8])>aindex){
            aindex  = int.parse(item[8]); 
          }
        } 
        aindex += 1;
      }

      _saveOrderToFirestore({"$aindex":[itemName,image,price,pindex,userName,number,size,status,aindex.toString(),date,expactedDate,
                            outForOrderDate,DeliveredDate,quantity,totalPrice,deliveryAddress,email,time]}, aindex.toString());
  }

}