import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_cat_api_clone/models/cat_model.dart';

import '../pages/detail_page.dart';

class PostCat extends StatefulWidget {
  PostCat({required this.cat, Key? key}) : super(key: key);
  Cat cat;

  @override
  _PostCatState createState() => _PostCatState();
}

class _PostCatState extends State<PostCat> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            fullscreenDialog: true,
            transitionDuration: Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return DetailPage(
                cat: widget.cat,
              );
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticInOut,
                ),
                child: child,
              );
            }));
      },
      child: Hero(
        tag: widget.cat.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: widget.cat.url,
            placeholder: (context, index) => AspectRatio(
              aspectRatio: widget.cat.width / widget.cat.height,
              child: Image(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/im_placeholder.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
