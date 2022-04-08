import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_cat_api_clone/models/breed_model.dart';
import '../pages/detail_page.dart';

class PostBreed extends StatefulWidget {
   PostBreed({required this.breeds,Key? key}) : super(key: key);
  Breeds breeds;

  @override
  _PostBreedState createState() => _PostBreedState();
}

class _PostBreedState extends State<PostBreed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                fullscreenDialog: true,
                transitionDuration: Duration(milliseconds: 1000),
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return DetailPage(
                    breed: widget.breeds,
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
            tag: widget.breeds.image!.id!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.breeds.image!.url!,
                placeholder: (context, index) => AspectRatio(
                    aspectRatio: widget.breeds.image!.width! / widget.breeds.image!.height!,
                    child: Container(
                      color: Colors.grey.shade200,
                    )),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          widget.breeds.name!,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
        )
      ],
    );
  }
}
