import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tot_app/provider/dog_provider.dart';
import 'package:tot_app/dog_model.dart';
import 'package:tot_app/screens/dog_detail_screen.dart';

class SavedDogsScreen extends StatefulWidget {
  @override
  _SavedDogsScreenState createState() => _SavedDogsScreenState();
}

class _SavedDogsScreenState extends State<SavedDogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DogProvider>(context, listen: false).loadSavedDogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Dogs'),
      ),
      body: Consumer<DogProvider>(
        builder: (context, dogProvider, child) {
          if (dogProvider.savedDogs.isEmpty) {
            return Center(child: Text('No saved dogs'));
          }

          return ListView.builder(
            itemCount: dogProvider.savedDogs.length,
            itemBuilder: (context, index) {
              Dog dog = dogProvider.savedDogs[index];
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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (dog.id != null) {
                      Provider.of<DogProvider>(context, listen: false)
                          .removeSavedDog(dog.id!);
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DogDetailScreen(dog: dog, isSaved: true),
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