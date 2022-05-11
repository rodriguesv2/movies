import 'package:flutter/material.dart';
import 'package:movie2you/app/components/movie_list_category.dart';
import 'package:movie2you/app/components/movie_poster.dart';
import 'package:movie2you/app/controllers/details_controller.dart';
import 'package:movie2you/app/models/details.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final controller = DetailsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<DetailsState>(
        valueListenable: controller.state,
        builder: (ctx, state, _) {
          return _switchWidget(state);
        },
      ),
    );
  }

  void _fetch() {
    final id = ModalRoute.of(context)?.settings.arguments as int;
    controller.fetch(id);
  }

  Widget _switchWidget(DetailsState state) {
    switch (state) {
      case DetailsState.start:
        _fetch();
        return Container();
      case DetailsState.loading:
        return _loading();
      case DetailsState.success:
        return _detailsScreen();
      case DetailsState.error:
        return _tryAgainError();
    }
  }

  SizedBox _tryAgainError() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Houve um erro ao buscar o filme",
            style: TextStyle(color: Colors.white),
          ),
          ElevatedButton(
            onPressed: _fetch,
            child: const Text("Tentar Novamente"),
          ),
        ],
      ),
    );
  }

  Center _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _detailsScreen() {
    final details = controller.details;

    return details == null
        ? _tryAgainError()
        : SingleChildScrollView(
            child: Column(
              children: [
                _posterAndData(details),
                _synopsis(details),
                _reviews(details.reviews),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MovieListCategory(
                    MediaQuery.of(context).size,
                    "Mais Como Esse",
                    details.similar,
                    (_) {},
                  ),
                ),
              ],
            ),
          );
  }

  Column _reviews(List<Map> reviews) {
    return Column(
      children: [
        _title("Comentários"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            color: const Color.fromRGBO(36, 33, 53, 1.0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Column(
                  children: [
                    Container(
                      child: Text(
                        review["author"],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        left: 14,
                        bottom: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        bottom: 14,
                      ),
                      child: Text(
                        review["content"],
                        style: const TextStyle(color: Colors.white54),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 14,
                        right: 14,
                        bottom: 8,
                      ),
                      child: Divider(
                        thickness: 2,
                        color: Colors.white10,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _synopsis(Details details) {
    return Column(
      children: [
        _title("Sinopse"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            details.overview,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(color: Colors.white60),
          ),
        ),
      ],
    );
  }

  Container _title(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  SizedBox _posterAndData(Details details) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Stack(
          children: [
            Image.network(
              details.backdropPath,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              color: Colors.black54,
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Row(
                    children: [
                      Expanded(
                        child: _dataColumn(details),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 18,
                            bottom: 18,
                            left: 18,
                          ),
                          child: MoviePoster(
                            details.posterPath,
                            width: 162,
                            height: 240,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataColumn(Details details) {
    return SizedBox(
      height: 259,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details.title,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            _dataItem(details.runtime),
            const SizedBox(height: 6),
            _dataItem(details.genres),
            const SizedBox(height: 6),
            Row(
              children: [
                Image.asset("lib/assets/images/star.png"),
                Text(
                  "${details.voteAverage} / 10 Média de Votos",
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text _dataItem(String data) {
    return Text(
      data,
      style: const TextStyle(color: Colors.white70),
    );
  }
}
