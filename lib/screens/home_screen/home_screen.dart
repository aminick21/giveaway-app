import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:give_away/models/product_model.dart';
import 'package:give_away/providers/auth_provider.dart';
import 'package:give_away/providers/location_provider.dart';
import 'package:give_away/providers/product_provider.dart';
import 'package:give_away/providers/socket_provider.dart';
import 'package:give_away/screens/home_screen/widgets/product_cards.dart';
import 'package:give_away/screens/product_screens/product_screen.dart';
import 'package:give_away/services/category_service.dart';
import 'package:give_away/services/product_service.dart';
import 'package:give_away/utils/token_manager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currIndex = 0;
  late SocketProvider? _socket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('hii');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(context);
      _locationPermission(context);
    });
  }

  _locationPermission(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).updateLocation();
  }

  Future<void> _loadData(BuildContext context) async {
    Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
    Provider.of<ProductProvider>(context, listen: false).fetchRecentlyAdded();
    Provider.of<ProductProvider>(context, listen: false).fetchNearByProduct();
  }


  Future<void> refresh(context) async{
    _loadData(context);
    _locationPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () =>refresh(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomScrollView(slivers: [
                //title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Give Away",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Transforming Stuff into Smiles!",
                                style:
                                    TextStyle(color: secondaryColor, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // print(await TokenManager.getToken());
                            //  TokenManager.deleteToken();
                            _socket!.disconnectSocket();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(.5),
                            child: Image.asset("assets/Avatar.png"),
                          ),
                        )
                        ,
                        GestureDetector(
                          onTap: () async {
                            // print(await TokenManager.getToken());
                            //  TokenManager.deleteToken();
                            _socket = Provider.of<SocketProvider>(context,listen: false);
                            _socket!.connectSocket();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(.5),
                            child: Image.asset("assets/Avatar.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //search bar
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(.2),
                        prefixIcon: const Icon(
                          LineIcons.search,
                          color: secondaryColor,
                          size: 20,
                        ),
                        filled: true,
                        hintText: "Search",
                        hintStyle: const TextStyle(color: secondaryColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),

                //Recently added list
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recently Added",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        SizedBox(
                          height: 120,
                          child: Consumer<ProductProvider>(
                            builder: (context, provider, child) {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: provider.isRecentlyAddedLoading
                                      ? 4 : provider.recentlyAdded.length,
                                  itemBuilder: (context, index) {
                                    if (provider.isRecentlyAddedLoading) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[200]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          margin:const EdgeInsets.only(right: 10),
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }
                                    return RecentlyAddedCard(
                                        product: provider.recentlyAdded[index]);
                                  });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //  carousal
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            Container(
                          // margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Color(0xffFDE5EC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: currIndex == 0
                                    ? primaryColor
                                    : currIndex == 1
                                        ? Colors.blue
                                        : secondaryColor,
                              )),
                        ),
                        options: CarouselOptions(
                            viewportFraction: 1,
                            onPageChanged: (index, _) {
                              setState(() {
                                currIndex = index;
                              });
                            }),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: currIndex,
                          count: 3,
                          effect: WormEffect(
                            dotHeight: 7,
                            dotWidth: 14,
                            radius: 7,
                            spacing: 5,
                            activeDotColor: primaryColor,
                            dotColor: secondaryColor.withOpacity(.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //near you
                SliverToBoxAdapter(
                  child: Consumer2<LocationProvider, ProductProvider>(builder:
                      (context, locationProvider, productProvider, child) {
                    if (!locationProvider.hasPermission || productProvider.nearByProducts.length==0) {
                      return SizedBox();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        const Text(
                          "Near You",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productProvider.isNearByLoading
                                  ? 4
                                  : productProvider.nearByProducts.length,
                              itemBuilder: (context, index) {
                                if (productProvider.isNearByLoading) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 190,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }
                                else{
                                return NearByCard(
                                    product: productProvider.recentlyAdded[index]);}
                              }),
                        ),
                      ],
                    );
                  }),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: 10,)),
                //all
                const SliverToBoxAdapter(
                    child: Text(
                  "All Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 10,)),
                Consumer<ProductProvider>(builder: (context, provider, child) {
                  return SliverGrid.builder(
                    itemCount: provider.isAllProductLoading?6:provider.allProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10,crossAxisSpacing: 10,childAspectRatio:.8),
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.isAllProductLoading) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return ProductGridItem(
                          product: provider.allProducts[index]);
                    },
                  );
                }),
                const SliverToBoxAdapter(
                    child: SizedBox(height: 0,))
              ]),
            ),
          )),
    );
  }
}

