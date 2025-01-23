import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:tot_app/dog_model.dart';
import 'package:tot_app/provider/dog_provider.dart';

class DogDetailScreen extends StatelessWidget {
  final Dog dog;
  final bool isSaved;

  const DogDetailScreen({
    Key? key, 
    required this.dog, 
    this.isSaved = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Dog Image URL: ${dog.imageUrl}");
    return Scaffold(
      appBar: AppBar(
        title: Text(dog.name),
        actions: !isSaved ? [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Provider.of<DogProvider>(context, listen: false).saveDog(dog);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dog saved successfully!')),
              );
            },
          )
        ] : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            dog.imageUrl != null && dog.imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: dog.imageUrl!,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                : Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: Icon(Icons.pets, size: 100),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dog.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Breed: ${dog.breed}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (dog.breedGroup != null && dog.breedGroup!.isNotEmpty)
                    Text(
                      'Breed Group: ${dog.breedGroup}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 16),
                  if (dog.description != null && dog.description!.isNotEmpty)
                    Text(
                      'Description:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  if (dog.description != null && dog.description!.isNotEmpty)
                    Text(
                      dog.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}