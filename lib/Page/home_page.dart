import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/grocery_item_tile.dart';
import 'cart_item_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> groceryItems = [];
  Map<String, int> cart = {};
  bool isLoading = true;



  @override
  void initState() {
    super.initState();
    fetchGroceryItems();
  }



  Future<void> fetchGroceryItems() async {
    try {
      final response = await supabase
          .from('grocery_items')
          .select('*');


      if (response != null) {
        setState(() {
          groceryItems = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  Color getColorName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void addToCart(String itemName) {
    setState(() {
      cart[itemName] = (cart[itemName] ?? 0) + 1;
    });
  }

  void removeFromCart(String itemName) {
    setState(() {
      if (cart[itemName] != null && cart[itemName]! > 1) {
        cart[itemName] = cart[itemName]! - 1;
      } else {
        cart.remove(itemName);
      }
    });
  }

  num calculateTotal() {
    num total = 0;
    for (var item in groceryItems) {
      final itemName = item['name'];
      final itemPrice = item['price'];
      if (cart.containsKey(itemName)) {
        total += itemPrice * cart[itemName]!;
      }
    }
    return total;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CartItemPage(cart: cart, total: calculateTotal());
            },
          ),
        ),
        child: Icon(Icons.shopping_cart),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text("Good morning,"),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Let's order fresh items for you",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Fresh Items",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                    childAspectRatio: 1 / 1.2
                ),
                itemCount: groceryItems.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final item = groceryItems[index];
                  return GroceryItemTile(
                    itemName: item['name'],
                    itemPrice: item['price'],
                    imagePath: item['image_path'],
                    color: getColorName(item['color']),
                    onAdd: () => addToCart(item['name']),
                    onRemove: () => removeFromCart(item['name']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
