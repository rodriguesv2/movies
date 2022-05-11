import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie2you/app/components/movie_list_category.dart';
import 'package:movie2you/app/components/movie_poster.dart';
import 'package:movie2you/app/components/simple_single_sliver_list.dart';
import 'package:movie2you/app/controllers/home_controller.dart';
import 'package:movie2you/app/models/movie_types.dart';
import 'package:movie2you/app/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(
                      height: 23,
                    ),
                    SizedBox(
                      width: 82,
                      height: 71,
                      child: Image.asset("lib/assets/images/movie_logo.png"),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder<HomeState>(
                builder: (ctx, value, child) =>
                    _switchState(value, context, size),
                valueListenable: controller.state,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchState(
    HomeState state,
    BuildContext context,
    Size size,
  ) {
    switch (state) {
      case HomeState.start:
        controller.fetch();
        return const SimpleSingleSliverList(children: []);
      case HomeState.loading:
        return _loading();
      case HomeState.success:
        return _movieCategories(
          context,
          size,
          controller.movieTypes,
        );
      case HomeState.error:
        return _tryAgainError(
            controller.errorMessage ?? "Erro ao buscar filmes");
    }
  }

  SliverFillRemaining _tryAgainError(String errorMessage) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              controller.fetch();
            },
            child: const Text("Tentar Novamente"),
          ),
        ],
      ),
    );
  }

  SliverFillRemaining _loading() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _goToDetails(int id) {
    Navigator.pushNamed(
      context,
      Routes.DETAILS,
      arguments: id,
    );
  }

  SimpleSingleSliverList _movieCategories(
    BuildContext context,
    Size size,
    MovieTypes movieTypes,
  ) {
    return SimpleSingleSliverList(
      children: [
        MovieListCategory(
          size,
          "Em Exibição",
          movieTypes.nowPlaying,
          _goToDetails,
        ),
        MovieListCategory(
          size,
          "Em Breve",
          movieTypes.upcoming,
          _goToDetails,
        ),
        MovieListCategory(
          size,
          "Mais Populares",
          movieTypes.popular,
          _goToDetails,
        ),
        MovieListCategory(
          size,
          "Melhores Avaliados",
          movieTypes.topRated,
          _goToDetails,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
