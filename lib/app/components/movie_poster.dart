import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  String posterPath;
  double width;
  double height;

  MoviePoster(
    this.posterPath, {
    Key? key,
    this.width = 135,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          posterPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
