import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:give_away/screens/chat_screens/chat_screen.dart';
import 'package:give_away/screens/product_screens/full_screen_map.dart';
import 'package:give_away/utils/token_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:line_icons/line_icons.dart';

import '../../models/product_model.dart';
import '../../utils/colors.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;
  final String tag;
  const ProductScreen({super.key, required this.product, required this.tag});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int currIndex=0;
  String? idToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.product.uid);
    getToken();
  }
  getToken()async{
    idToken = await TokenManager.getToken();
  }


  @override
  Widget build(BuildContext context) {
    final topPadding=MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Product Detail"),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 20,top:topPadding),
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 300,
            child:Hero(tag: widget.tag,
                child: Image.network(widget.product.imageUrl,fit: BoxFit.cover,)),
            // CarouselSlider.builder(
            //   itemCount: 3,
            //   itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            //       Container(
            //         color:currIndex==0?primaryColor:currIndex==1?Colors.blue:secondaryColor,
            //         child: Image.asset("assets/temp/image-near-2.png",fit: BoxFit.cover,),
            //       ),
            //   options: CarouselOptions(
            //       aspectRatio: 1,
            //       viewportFraction: 1,
            //       onPageChanged: (index, _) {
            //         setState(() {
            //           currIndex = index;
            //         });
            //       }),
            // ),
          ),
          SizedBox(height: 10,),
          // Center(
          //   child: AnimatedSmoothIndicator(
          //     activeIndex: currIndex,
          //     count: 3,
          //     effect: WormEffect(
          //       dotHeight: 7,
          //       dotWidth: 14,
          //       radius: 7,
          //       spacing: 5,
          //       activeDotColor: primaryColor,
          //       dotColor:secondaryColor.withOpacity(.5),
          //     ),
          //   ),
          // ),

          //title
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20,bottom: 2),
          child:Text(widget.product.title,
            style:TextStyle(fontSize:22,fontWeight: FontWeight.bold),) ,
          ),

          //address
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20,bottom: 15),
            child: Text("${widget.product.location.addressLine},${widget.product.location.city}, ${widget.product.location.state}" ,
              style:TextStyle(fontSize:16,color: Colors.grey),),
          ),

          //desc
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20,bottom: 5),
            child:Text("Description",
              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold),) ,
          ),

          Padding(
            padding: EdgeInsets.only(left: 20,right: 20,bottom:15),
            child:Text(widget.product.productDescription,
              style:TextStyle(fontSize:18),) ,
          ),

          //owner
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20,bottom: 5),
            child:Text("Owner",
              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold),) ,
          ),

          Padding(
            padding: EdgeInsets.only(left: 20,right: 20,bottom: 15),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.grey.withOpacity(.5),
                  child: Image.asset("assets/avatar3.png"),),
                SizedBox(width: 15,),

                    Text("Anvaya",
                      style:TextStyle(fontSize:18),),

                Spacer(),
                GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder:
                      (context)=>ChatScreen(
                          senderId: '664d1245fcfa762a53422197',
                          receiverId: '6654ed804f29a7b98df59167',
                          senderName: 'sender',
                          receiverName: 'reciever'))),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("Chat",
                      style:TextStyle(fontSize:16,color:primaryColor,fontWeight: FontWeight.w600),),
                  ),
                ),
              ],
            ),
          ),

          //location
          const Padding(
            padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
            child:Text("Location",
              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold),) ,
          ),

          Container(
            height: 180,
            padding: EdgeInsets.only(left: 20,right: 20),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [

                  SizedBox(
                  height: 180,
                  child: FlutterMap(
                    mapController: MapController(),
                    options: MapOptions(
                      initialCenter: LatLng(widget.product.location.lat,widget.product.location.long),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(widget.product.location.lat, widget.product.location.long),
                            child: Icon(CupertinoIcons.location_solid, color: secondaryColor, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreenMap(
                            lat: widget.product.location.lat, long: widget.product.location.long,

                          )));
                        },
                        child: Container(
                          color: Colors.grey.withOpacity(.7),
                          child: const Icon(LineIcons.expand,
                            color: secondaryColor,),
                        ),
                      )),

                ],

              ),
            )
          ),

        ],
      ),
    );
  }
}
