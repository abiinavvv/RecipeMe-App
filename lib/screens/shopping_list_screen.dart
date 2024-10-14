
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/shopping_list_provider.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _addItemController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final shoppingList = Provider.of<ShoppingListProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Shopping List',
            style: TextStyle(
                color: appState.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: appState.isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            color: appState.isDarkMode ? Colors.white : Colors.black,
            onPressed: () => _showClearListDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _addItemController,
                  decoration: InputDecoration(
                    hintText: 'Add new item...',
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: const Icon(Icons.add_shopping_cart, color: Colors.black54),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black54),
                      onPressed: () => _addItem(context),
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onSubmitted: (_) => _addItem(context),
                ),
              ),
              Expanded(
                child: shoppingList.items.isEmpty
                    ? Center(
                        child: Text(
                          'Your shopping list is empty!',
                          style: TextStyle(
                              color: appState.isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: shoppingList.items.length,
                        itemBuilder: (context, index) {
                          final item = shoppingList.items[index];
                          return FadeTransition(
                            opacity: _animation,
                            child: Dismissible(
                              key: Key(item.name),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                shoppingList.removeIngredient(item.name);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} removed from the list'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title: Text(item.name),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (item.quantity > 1) {
                                            shoppingList.updateQuantity(item.name, item.quantity - 1);
                                          } else {
                                            shoppingList.removeIngredient(item.name);
                                          }
                                        },
                                      ),
                                      Text(item.quantity.toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          shoppingList.updateQuantity(item.name, item.quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addItem(BuildContext context) {
    final shoppingList = Provider.of<ShoppingListProvider>(context, listen: false);
    if (_addItemController.text.isNotEmpty) {
      shoppingList.addIngredient(_addItemController.text);
      _addItemController.clear();
    }
  }

  void _showClearListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Shopping List'),
          content: const Text('Are you sure you want to clear the entire shopping list?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                Provider.of<ShoppingListProvider>(context, listen: false).clearList();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _addItemController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}