import 'package:flutter/material.dart';
import 'package:rentalzapp/screens/categories_screen.dart';
import 'package:rentalzapp/screens/bedrooms_screen.dart';
import 'package:rentalzapp/screens/furnitures_screen.dart';
import 'package:rentalzapp/screens/home_screen.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage('https://picsum.photos/250?image=9'),
              ),
              accountName: Text('Sbeve'),
              accountEmail: Text('sbeve@gmail.com'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Property type'),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            ListTile(
              leading: Icon(Icons.bed),
              title: Text('Bedroom type'),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => BedroomsScreen())),
            ),
            ListTile(
              leading: Icon(Icons.chair),
              title: Text('Furniture style'),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FurnituresScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
