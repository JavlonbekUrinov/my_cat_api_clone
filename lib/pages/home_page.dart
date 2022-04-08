import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:my_cat_api_clone/models/cat_model.dart';
import 'package:my_cat_api_clone/services/http_service.dart';
import 'package:my_cat_api_clone/utils/post_cat.dart';
import 'package:my_cat_api_clone/utils/utils.dart';

import '../services/log_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  int selectedCategory = 0;
  bool isLoadMore = false;
  List<Cat> catList = [];

  @override
  void initState() {
    super.initState();
    getCatImages();
  }

  void getCatImages() {
    setState(() {
      isLoadMore = true;
    });
    Network.GET(
        Network.API_LIST, Network.paramsGet(((catList.length ~/ 10) + 1)))
        .then((value) {
      if (value != null) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(onPressed: () {},
              icon: const Icon(CupertinoIcons.line_horizontal_3, size: 30,
                color: Colors.black,)),
          title: const Text('All Cats', style: TextStyle(
              fontFamily: 'SansitaSwashed',
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: (isLoading)
            ? Center(
            child: Lottie.asset('assets/anims/loading.json', width: 100))
            : Stack(
          children: [

            /// NotificationListener work when User reach last post
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoadMore &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  getCatImages();
                  // start loading data
                  setState(() {});
                }
                return true;
              },
              child: MasonryGridView.count(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: catList.length,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemBuilder: (context, index) {
                  return PostCat(cat: catList[index]);
                },
              ),
            ),

            /// Lottie_Loading appear when User reach last post and start Load More
            isLoadMore
                ? WidgetsCatalog.loadMoreAnim(context)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
