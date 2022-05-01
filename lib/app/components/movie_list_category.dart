import 'package:flutter/material.dart';

import 'movie_poster.dart';

class MovieListCategory extends StatelessWidget {
  final Size size;
  final String title;
  final List<Map> content;
  final Function(int id) click;

  const MovieListCategory(
    this.size,
    this.title,
    this.content,
    this.click, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        SizedBox(
          width: size.width,
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: content.length,
            itemBuilder: (ctx, index) {
              return _movieItem(
                index,
                index == content.length - 1,
                content[index],
                click,
              );
            },
          ),
        ),
      ],
    );
  }

  Padding _movieItem(
    int index,
    bool isLastItem,
    Map content,
    Function(int id) click,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 18,
        right: isLastItem ? 18 : 0,
      ),
      child: GestureDetector(
        onTap: () {
          click(content["id"]);
        },
        child: MoviePoster(content["poster"]),
      ),
    );
  }
}
