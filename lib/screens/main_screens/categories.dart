import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:give_away/providers/category_provider.dart';
import 'package:give_away/screens/product_screens/product_list.dart';
import 'package:give_away/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(context);
    });
  }

  _loadData(context)async {
    Provider.of<CategoryProvider>(context, listen: false).getCategories();
  }
  _refresh(context) async {
    _loadData(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title:const Text("Categories",
          style:TextStyle(fontSize:28,fontWeight: FontWeight.bold,color: blackColor),
        ),),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: ()=>_refresh(context),
          child: Consumer<CategoryProvider>(
            builder: (BuildContext context, CategoryProvider provider, Widget? child) {
              return ListView.builder(
                itemCount: provider.isLoading?5:provider.categoryList.length,
                  itemBuilder:(context,index){
                  return provider.isLoading?Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin:const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                )
                    : GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (buildContext)=>ProductList(categoryName: provider.categoryList[index].name,)));
                    },
                      child: Container(
                          margin:const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          height: 120,
                        child: ClipRRect(
                            borderRadius:BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:provider.categoryList[index].image,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),),
                                errorWidget: (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade300),),
                                    child: Icon(Icons.error,color: Colors.grey,)),
                                fit: BoxFit.cover,
                              ),

                              // Image.network(provider.categoryList[index].image,fit: BoxFit.cover,)

                          ),
                        ),
                    );
              });
            },

          ),
        )

      ),
    );
  }
}
