import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tot_app/provider/dog_provider.dart';
import 'package:tot_app/dog_model.dart';
import 'dog_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DogProvider>(context, listen: false).fetchDogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TOT APP - Dog List'),
      ),
      body: Consumer<DogProvider>(
        builder: (context, dogProvider, child) {
          if (dogProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (dogProvider.dogs.isEmpty) {
            return Center(child: Text('No dogs found'));
          }

          return ListView.builder(
            itemCount: dogProvider.dogs.length,
            itemBuilder: (context, index) {
              Dog dog = dogProvider.dogs[index];
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
    );
  }
}