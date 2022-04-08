import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:my_cat_api_clone/services/http_service.dart';
import 'package:my_cat_api_clone/models/cat_model.dart';
import 'package:my_cat_api_clone/utils/glow_widget.dart';
import 'package:my_cat_api_clone/utils/post_cat.dart';
import 'package:my_cat_api_clone/utils/utils.dart';
import '../services/log_service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  int selectedCategory = 1;
  int selected = 0;
  bool isLoadMore = false;
  List<Cat> catList = [];
  List<String> categories = [
    "Hats",
    "Space",
    "Funny",
    "Sunglasses",
    "Boxes",
    "Saturday",
    "Ties",
    "Kittens",
  ];

  @override
  void initState() {
    super.initState();
    getCatImages(1);
  }

  void getCatImages(int categoryId) {
    setState(() {
      isLoadMore = true;
    });
    Network.GET(
            Network.API_LIST, Network.paramsCategoryGet(((catList.length ~/ 10) + 1),categoryId))
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
        body: (isLoading)
            ? Center(
                child: Lottie.asset('assets/anims/loading.json', width: 100))
            :
            /// NotificationListener work when User reach last post
            Stack(
              children: [
                Glow(
                  child: NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.19,
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                itemCount: categories.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  return storyItems(index);
                                }),
                          ),
                        ]))
                      ];
                    },
                    body: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!isLoadMore &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          getCatImages(selectedCategory);
                          // start loading data
                          setState(() {});
                        }
                        return true;
                      },
                      child: MasonryGridView.count(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        itemCount: catList.length,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        itemBuilder: (context, index) {
                          return PostCat(cat:catList[index]);
                        },
                      ),
                    ),
                  ),
                ),
                /// Lottie_Loading appear when User reach last post and start Load More
                isLoadMore
                    ? WidgetsCatalog.loadMoreAnim(context)
                    : SizedBox.shrink(),
              ],
            ),
      ),
    );
  }


  Widget storyItems(int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          catList.clear();
          selected = index;
          (index != 7) ? (selectedCategory = index+1) : (selectedCategory = 9);
          getCatImages(selectedCategory);
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// Story Image
            Container(
              height: 70,
              width: 70,
              padding: EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                border: (selected != index)?Border.all(color: Colors.purple, width: 3):null,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/im_$index.jpg'),
                  )),
            ),
            const SizedBox(
              height: 5,
            ),

            /// User name
            Text(
              categories[index],
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
