import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            }, 
            icon: Icon(Icons.logout, color: Colors.white)
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: productsService.loadProducts,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: productsService.products.length,
          itemBuilder: ( BuildContext context, int index ) => GestureDetector(
            child: ProductCard(product: productsService.products[index]),
            onTap: () {
              productsService.selectedProduct = productsService.products[index].copy();
              Navigator.pushNamed(context, 'product');
            }
          ) 
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct = new Product(available: false, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        }
      ),
    );
  }
}