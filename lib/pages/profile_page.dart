import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:my_cat_api_clone/services/http_service.dart';
import 'package:my_cat_api_clone/utils/glow_widget.dart';
import 'package:my_cat_api_clone/utils/post_cat.dart';
import 'package:my_cat_api_clone/utils/utils.dart';
import '../models/cat_model.dart';
import '../services/log_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String id = "profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{
  bool isLoading = true;
  bool isLoadMore = false;
  final picker = ImagePicker();
  List<Cat> catList = [];
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCatImages();
  }

  Future <void> getCatImages() async{
    Network.GET(Network.API_GET_UPLOADS, Network.paramsGet(0)).then((value) {
      if (value != null) {
        catList.clear();
        catList.addAll(List.from(Network.parseCatList(value)));
        Log.i("Length : " + catList.length.toString());
      } else {
        Log.i("Null Response");
      }
      setState(() {
        isLoading = false;
        isLoadMore = false;
      });
    });
  }

  /// Add Post
  void addPost(BuildContext context) {
    _getImage().then((path) {
      _apiUploadImage(path, context).then((value){
        if(value == 'Bad Request'){
        WidgetsCatalog.showSnackBar(context, 'No cat found !!!');
        isLoadMore = false;
        setState(() {});
        }
        else{
          getCatImages().then((value){
            WidgetsCatalog.showSnackBar(context, 'Successfully added post');
          });
        }
      });
    });
  }

  /// Delete Post
  void deletePost(String id,int index){

    Network.DEL(Network.API_GET_UPLOADS+id,Network.paramEmpty()).then((value){
      setState(() {
        catList.removeAt(index);
      });
      Navigator.pop(context);
    });
  }

  /// Upload image
  Future _apiUploadImage(var image,BuildContext context) async {
   String? data =  await Network.POST(Network.API_UPLOAD, image.path, Network.paramEmpty());
   return data;
  }


  /// Get Image from local device
  Future<File?> _getImage() async {
    File? file;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        isLoadMore = true;
        file = File(pickedFile.path);
        Log.i('File Selected!!! ');
      });
    } else {
      Log.e('No file selected');
    }
    if (file != null) return file;
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: (isLoading)
          ? Center(child: Lottie.asset('assets/anims/loading.json', width: 100))
          : Stack(
              children: [
                Glow(
                  child: NestedScrollView(
                    floatHeaderSlivers: true,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverList(
                              delegate: SliverChildListDelegate(
                                  [profileDetails(context)]))
                        ];
                      },
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            textFieldWidget(context),
                            SizedBox(
                              height: 10,
                            ),
                            MasonryGridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              itemCount: catList.length,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              itemBuilder: (context, index) {
                                return postItems(catList[index],index);
                              },
                            ),
                          ],
                        ),
                      )),
                ),

                /// Lottie_Loading appear when User reach last post and start Load More
                isLoadMore
                    ? WidgetsCatalog.loadMoreAnim(context)
                    : SizedBox.shrink(),
              ],
            ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      shadowColor: Colors.grey.shade300,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.share),
          color: Colors.black,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
          color: Colors.black,
        ),
      ],
    );
  }

  Widget textFieldWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20)),

            /// TextField Search
            child: TextField(
              style: const TextStyle(
                  color: Colors.black, decoration: TextDecoration.none),
              cursorColor: Colors.black,
              controller: textEditingController,
              onSubmitted: (text) {
                setState(() {});
              },
              decoration: const InputDecoration(
                  hintText: "Search your Pins",
                  hintStyle: TextStyle(
                      color: Colors.black, decoration: TextDecoration.none),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    size: 25,
                    color: Colors.black,
                  ),
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none),
            ),
          ),
        ),
        Expanded(
            child: Column(
          children: [
            IconButton(
                iconSize: 30,
                onPressed: () {
                  addPost(context);
                },
                icon: const Icon(CupertinoIcons.add)),
            const Text(
              "Add Post",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            )
          ],
        )),
      ],
    );
  }

  Widget profileDetails(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width / 7,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: AssetImage('assets/images/im_profile.jpg'),
          foregroundColor: Colors.grey,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Christopher Robin",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "@christoph123",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '0 followers ',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              "• 0 following",
              style: TextStyle(
                fontSize: 14,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  /// Picture Posts
  Widget postItems(Cat cat,int index) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        PostCat(cat: cat),
        speedDial(cat, index),
      ],
    );
  }

  SpeedDial speedDial(Cat cat, int index) {
    return SpeedDial(
        icon: Icons.more_horiz,
        iconTheme: const IconThemeData(
          size: 35,

        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),topLeft: Radius.circular(100))
        ),
        direction: SpeedDialDirection.up,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        buttonSize: Size(40,35),
        elevation: 0,
        childrenButtonSize: Size(40,40),
        spaceBetweenChildren: 5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        children: [
          SpeedDialChild(
            child: Icon(Icons.delete,size: 20,),
            label: "Delete",
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            labelStyle: TextStyle(fontSize: 12),
            onTap: () {
              WidgetsCatalog.androidDialog(title: 'Delete Post', content: 'Are you sure delete this post?', onTapNo: (){
                Navigator.pop(context);
              }, onTapYes: (){
                deletePost(cat.id, index);
              }, context: context);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.brush,size: 20,),
            label: "Clear",
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            labelStyle: TextStyle(fontSize: 12),
            onTap: () {},
          ),
        ],
      );
  }

  @override
  bool get wantKeepAlive => true;
}
