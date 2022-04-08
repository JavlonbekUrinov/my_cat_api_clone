import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_cat_api_clone/models/breed_model.dart';
import 'package:my_cat_api_clone/utils/post_breed.dart';
import 'package:my_cat_api_clone/utils/utils.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';
import '../utils/glow_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const String id = "search_page";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  int selectedCategory = 0;
  bool isLoadMore = false;
  String search = "";
  List<Breeds> breedList = [];
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCatBreeds();
  }

  void getCatBreeds() {
    setState(() {
      isLoadMore = true;
    });
    Network.GET(Network.API_LIST_Breeds, Network.paramEmpty()).then((value) {
      if (value != null) {
        breedList.addAll(List<Breeds>.from(Network.parseBreedsList(value)).where(
            (element) =>
                ((element.image != null) && (element.image?.url != null))));
        Log.i("Length : " + breedList.length.toString());
      } else {
        Log.i("Null Response");
      }
      setState(() {
        isLoadMore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchWidget(context),
      body: (breedList.isNotEmpty)
          ? Glow(
            child: MasonryGridView.count(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: (search.isEmpty)
                    ? breedList.length
                    : breedList
                        .where((element) => element.name!
                            .toLowerCase()
                            .contains(search.toLowerCase()))
                        .toList()
                        .length,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemBuilder: (context, index) {
                  List temp = List.from(breedList
                      .where((element) => element.name!
                          .toLowerCase()
                          .contains(search.toLowerCase()))
                      .toList());
                  return PostBreed(breeds: temp[index]);
                },
              ),
          )
          : WidgetsCatalog.loadMoreAnim(context)
    );
  }


  /// Search Widget
  PreferredSize searchWidget(BuildContext context) {
    return PreferredSize(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20)),

              /// TextField Search
              child: TextField(
                style: TextStyle(
                    color: Colors.black, decoration: TextDecoration.none),
                cursorColor: Colors.black,
                controller: textEditingController,
                onChanged: (text) {
                  setState(() {
                    search = text;
                  });
                },
                decoration: InputDecoration(
                    hintText: "Search for ideas",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        decoration: TextDecoration.none),
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                    suffixIcon: Icon(
                      CupertinoIcons.camera_fill,
                      size: 30,
                      color: Colors.black,
                    ),
                    contentPadding: EdgeInsets.all(15),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
        preferredSize:
            Size(double.infinity, MediaQuery.of(context).size.height * 0.08));
  }

  @override
  bool get wantKeepAlive => true;

}
