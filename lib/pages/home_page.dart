import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../bloc/home_bloc/home_event.dart';
import '../bloc/home_bloc/home_state.dart';
import '../models/post_model.dart';
import '../views/item_of_home.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    homeBloc = BlocProvider.of(context);
    homeBloc.add(LoadPostListEvent());
    homeBloc.stream.listen((state) {
      if (state is HomeDeletePostState) {
        homeBloc.add(LoadPostListEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text("Bloc"),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeErrorState) {
            return viewOfError(state.errorMessage);
          }

          if (state is HomePostListState) {
            var posts = state.postList;
            return viewOfPostList(posts);
          }

          return viewOfLoading();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          homeBloc.callCreatePage(context);
        },
      ),
    );
  }

  Widget viewOfError(String err) {
    return Center(
      child: Text("Error occurred $err"),
    );
  }

  Widget viewOfLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget viewOfPostList(List<Post> posts) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: homeBloc.posts.length,
          itemBuilder: (ctx, index) {
            return itemOfPost(homeBloc.posts[index]);
          },
        ),
      ],
    );
  }

}