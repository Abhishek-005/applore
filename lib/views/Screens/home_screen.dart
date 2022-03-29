import 'package:applore/views/Screens/login_screen.dart';
import '../widgets/confirm_dialog.dart';
import '/models/product.dart';
import '/providers/authentication_provider.dart';
import '/providers/user_data_provider.dart';
import '/views/Screens/Products/add_products.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _listProduct = [];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  showSignOutConfirmationDialog(Size size) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ConfirmDialog(
        callback: () {
          context.read<AuthenticationProvider>().signOutUser().whenComplete(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listProduct = context.watch<ProductListProvider>().productList;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                showSignOutConfirmationDialog(size);
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddProductScreen()));
        },
      ),
      body: SafeArea(
        child: SmartRefresher(
          enablePullUp: true,
          controller: refreshController,
          onRefresh: () async {
            var result =
                await context.read<UserDataProvider>().getInitialProducts();
            // print(result);
            context.read<ProductListProvider>().addInProducts(result);
            if (result != null) {
              setState(() {});
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            var result = await context
                .read<UserDataProvider>()
                .getMoreProducts(_listProduct.last);
            context.read<ProductListProvider>().updateInProducts(result);
            if (result != null) {
              setState(() {});
              refreshController.loadComplete();
            } else {
              refreshController.loadFailed();
            }
          },
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _listProduct.length,
              itemBuilder: (context, index) {
                print(index);
                return ListTile(
                  leading: Image.network(_listProduct[index].image),
                  title: Text(
                    _listProduct[index].name,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  subtitle: Text(
                    _listProduct[index].description,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  trailing: Text(
                    "₹" + _listProduct[index].price.toString(),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
