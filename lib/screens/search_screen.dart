import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tot_app/provider/dog_provider.dart';
import 'package:tot_app/dog_model.dart';
import 'dog_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Dogs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name or breed',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Provider.of<DogProvider>(context, listen: false)
                        .searchDogs(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                Provider.of<DogProvider>(context, listen: false)
                    .searchDogs(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<DogProvider>(
              builder: (context, dogProvider, child) {
                if (dogProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (dogProvider.searchResults.isEmpty) {
                  return Center(child: Text('No dogs found'));
                }

                return ListView.builder(
                  itemCount: dogProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    Dog dog = dogProvider.searchResults[index];
                    return ListTile(
                      leading: dog.imageUrl != null && dog.imageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: dog.imageUrl!,
                              width: 60,
                              height: 60,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            )
                          : Icon(Icons.pets),
                      title: Text(dog.name),
                      subtitle: Text(dog.breed),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DogDetailScreen(dog: dog),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}