import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:give_away/screens/product_screens/product_screen.dart';
import 'package:give_away/utils/colors.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/product_model.dart';

class RecentlyAddedCard extends StatelessWidget {
  final ProductModel product;
  const RecentlyAddedCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen(product: product,tag: "${product.id}-recently" ,),)),
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Hero(
              tag:  "${product.id}-recently",
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),),
                    errorWidget: (context, url, error) => Container(
                        height: 100,
                        width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),),
                        child: Icon(Icons.error,color: Colors.grey,)),
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  )
        ),
            ),
            Expanded(
                child: Text(
                  product.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ProductGridItem extends StatelessWidget {
  final ProductModel product;
  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen(product: product,tag: "${product.id}-allProduct",),)),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Hero(
              tag: "${product.id}-allProduct",
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 150,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),),
                    errorWidget: (context, url, error) => Container(
                        height: 150,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),),
                        child: Icon(Icons.error,color: Colors.grey,)),
                    fit: BoxFit.cover,
                    height: 150,
                    width: 200,
                  ),
            ),),
            // Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(product.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                    overflow: TextOverflow.ellipsis,),
                ),
                Text(product.condition,
                  style: TextStyle(
                      fontSize: 14,
                    color: primaryColor
                  ),
                  overflow: TextOverflow.ellipsis,),
              ],
            ),
            // Spacer(),
            Text(product.productDescription,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 12,
                color: Colors.grey.shade500
              ),
              overflow: TextOverflow.ellipsis,),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}

class NearByCard extends StatelessWidget {
  final ProductModel product;
  const NearByCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen(product: product,tag: "${product.id}-nearBy"),)),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Hero(
        tag:  "${product.id}-nearBy",
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),),
                errorWidget: (context, url, error) => Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),),
                    child: Icon(Icons.error,color: Colors.grey,)),
                fit: BoxFit.cover,
                height: 150,
                width: 200,
              )
          ),),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(product.title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      ),
                      overflow: TextOverflow.ellipsis,),
                  ),
                  Text(product.condition,
                    style: TextStyle(
                        fontSize: 14,
                        color: primaryColor
                    ),
                    overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: primaryColor,
                  ),
                  Expanded(
                    child: Text(
                      "${product.location.addressLine}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListCard extends StatelessWidget {
  final ProductModel product;
  const ProductListCard({super.key, required this.product});
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: GestureDetector(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen(product: product,tag: "${product.id}-productList",),)),
        child: Row(
          children: [
            Hero(
              tag: "${product.id}-productList",
              child: ClipRRect(
                borderRadius:BorderRadius.circular(8),
                child: Image.network(product.imageUrl,
                  height: 120,width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10,top: 10,bottom: 5),
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:5),
                      child: Text(product.title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),),
                    ),
                    Text(product.productDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LineIcon(Icons.location_on,color: primaryColor,size: 18,),
                        Expanded(
                          child: Text(" ${product.location.addressLine}"+" ${product.location.city}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
