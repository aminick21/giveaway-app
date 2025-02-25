import 'package:flutter/material.dart';
import 'package:give_away/providers/product_provider.dart';
import 'package:give_away/screens/home_screen/widgets/product_cards.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductList extends StatefulWidget {
  final String categoryName;
  const ProductList({super.key, required this.categoryName});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(context);
    });
  }

  _loadData(context) async {
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductList(widget.categoryName, null, null, null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.categoryName),
      ),
      body: Consumer<ProductProvider>(
        builder:
            (BuildContext context, ProductProvider provider, Widget? child) {
          return ListView.builder(
            itemCount: provider.isProductListLoading?5:provider.productList.length,
              itemBuilder: (context, index) {
            return provider.isProductListLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                  )
                : ProductListCard(product: provider.productList[index],);
          });
        },
      ),
    );
  }
}
