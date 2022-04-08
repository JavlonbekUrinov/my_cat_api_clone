import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_cat_api_clone/models/breed_model.dart';
import 'package:my_cat_api_clone/models/fade_anim.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cat_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class DetailPage extends StatefulWidget {
  Cat? cat;
  Breeds? breed;

  DetailPage({this.cat, this.breed, Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  bool isDisplayInfo = false;
  List<Breeds> breedsList = [];
  List<String> catList = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    (widget.breed != null) ? apiResponse(widget.breed!.id!) : null;
    Timer(Duration(seconds: 1), () {
      setState(() {
        isDisplayInfo = true;
      });
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  /// Send Response
  void apiResponse(String search) {
    Network.GET(Network.API_LIST,
            Network.paramSearch(search, (breedsList.length ~/ 10) + 1))
        .then((value) {
      getImages(value);
    });
  }

  /// Get Images
  void getImages(String? value) {
    try {
      if (value != null) {
        List response = jsonDecode(value);
        for (var item in response) {
          breedsList
              .addAll(Network.parseBreedsList(jsonEncode(item['breeds'])));
          catList.add(item['url']);
        }
        setState(() {});
        Log.i("Length : " + breedsList.length.toString());
      } else {
        Log.i("Null Response");
      }
    } catch (e) {
      Log.i(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: (widget.cat != null)
          ? Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: widget.cat!.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: widget.cat!.url,
                      placeholder: (context, index) => AspectRatio(
                          aspectRatio: widget.cat!.width / widget.cat!.height,
                          child: Container(
                            color: Colors.grey.shade200,
                          )),
                    ),
                  ),
                ),
              ),
            )
          : Hero(
              tag: widget.breed!.image!.id!,
              child: Container(
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Image
                      postImage(),

                      /// Info
                      (isDisplayInfo)
                          ? FadeAnimation(
                              0.5,
                              postInfo(context),
                            )
                          : SizedBox.shrink(),

                      /// More like this /// Posts
                      (catList.isNotEmpty)
                          ? FadeAnimation(
                              1,
                              morePost(),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget postImage() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      color: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: widget.breed!.image!.url!,
                  placeholder: (context, index) => AspectRatio(
                      aspectRatio: widget.breed!.image!.width! /
                          widget.breed!.image!.height!,
                      child: Container(
                        color: Colors.grey.shade200,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget morePost() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                "More like this",
                style: TextStyle(
                    fontFamily: 'SansitaSwashed',
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              MasonryGridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: catList.length,
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                        imageUrl: catList[index],
                        placeholder: (context, index) => Container(
                              color: Colors.grey.shade300,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postInfo(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: Colors.white,
        child: Column(
          children: [
            /// Breed
            Text(
              widget.breed!.name!,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),

            /// Country
            Text(
              "${widget.breed!.countryCode!} - ${widget.breed!.origin!}",
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),

            /// Description
            Text(
              widget.breed!.description!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Divider(
              thickness: 1,
              height: 30,
            ),

            /// Temperament
            Text(
              widget.breed!.temperament!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),

            /// Weight
            Text(
              "Weight : ${widget.breed!.weight!.metric} kgs",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),

            /// Life year
            Text("${widget.breed!.lifeSpan!} average life span"),
            const SizedBox(
              height: 10,
            ),

            /// Wikipedia
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  text: "More about this :   ",
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await launch(widget.breed!.wikipediaUrl!);
                          },
                        style: const TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                        text: "Wikipedia"),
                  ]),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
