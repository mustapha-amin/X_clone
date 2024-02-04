import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/explore/controllers/search_controller.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/models/recent_search_model.dart';
import 'package:x_clone/utils/utils.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocus.addListener(() {
      if (searchFocus.hasFocus || !searchFocus.hasFocus) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentSearches = ref.watch(fetchSearchesProvider);
    return Scaffold(
        appBar: AppBar(
          leadingWidth: context.screenWidth * .2,
          leading: XAvatar(),
          titleSpacing: 0,
          title: SearchBar(
            focusNode: searchFocus,
            elevation: const MaterialStatePropertyAll(0),
            controller: searchController,
            constraints: BoxConstraints(
              minHeight: context.screenHeight * .065,
              minWidth: context.screenWidth * .8,
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.grey[900]!,
                ),
              ),
            ),
            hintText: "Search X",
            hintStyle: MaterialStatePropertyAll(
              kTextStyle(13, ref, color: Colors.grey[500]),
            ),
            onTap: () {
              setState(() {});
            },
            onChanged: (value) {
              ref.read(searchUsersProvider(searchController.text.trim()));
              setState(() {});
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                FeatherIcons.settings,
                size: 20,
              ),
            )
          ],
        ),
        body: switch (searchController.text.isEmpty) {
          true => switch (searchFocus.hasFocus) {
              true => SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent",
                            style: kTextStyle(20, ref,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        const Text("Clear all recent searches"),
                                    content: const Text(
                                        "This cannot be undone and you'll remove all your recent searches"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () {
                                            ref.read(clearSearchesProvider);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Clear")),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Colors.grey[800],
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ).padX(10),
                      VerticalSpacing(size: 20),
                      recentSearches.when(
                        data: (searches) => Column(
                          children: [
                            ...searches.map(
                              (search) => ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                onTap: () {
                                  setState(() {
                                    searchController.text = search.query!;
                                  });
                                },
                                leading: const Icon(
                                  Icons.history,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                title: Text(
                                  search.query!,
                                  style:
                                      kTextStyle(18, ref, color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                        error: (err, _) => Text("An error occured"),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  ),
                ),
              _ => const SizedBox(),
            },
          _ =>
            ref.watch(searchUsersProvider(searchController.text.trim())).when(
                  data: (users) => ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          ref.read(
                            saveSearchProvider(
                              RecentSearch(query: searchController.text.trim()),
                            ),
                          );
                          navigateTo(
                            context,
                            UserProfileScreen(
                              user: users[index],
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              users[index].profilePicUrl!,
                            ),
                          ),
                          title: Text(
                            users[index].name!,
                            style: kTextStyle(18, ref),
                          ),
                          subtitle: Text(
                            '@${users[index].username!}',
                            style: kTextStyle(13, ref, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                  error: (_, __) => const Text("An error occured"),
                  loading: () => const XLoader(),
                ),
        });
  }
}
