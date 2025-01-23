import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:tot_app/dog_model.dart';
import 'package:tot_app/provider/dog_provider.dart';

class DogDetailScreen extends StatelessWidget {
  final Dog dog;
  final bool isSaved;

  const DogDetailScreen({
    super.key, 
    required this.dog, 
    this.isSaved = false
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                dog.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    )
                  ],
                ),
              ),
              background: _buildHeroImage(context),
            ),
            actions: !isSaved 
              ? [
                  IconButton(
                    icon: Icon(Icons.save, color: Colors.white),
                    onPressed: () {
                      Provider.of<DogProvider>(context, listen: false).saveDog(dog);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Dog saved successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  )
                ]
              : null,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(context),
                  SizedBox(height: 16),
                  if (dog.description != null && dog.description!.isNotEmpty)
                    _buildDescriptionSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullscreenImageScreen(imageUrl: dog.imageUrl!),
          ),
        );
      },
      child: Hero(
        tag: 'dog_image_${dog.name}',
        child: _buildDogImage(context),
      ),
    );
  }

  Widget _buildDogImage(BuildContext context) {
    if (dog.imageUrl != null && dog.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: dog.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: Icon(Icons.pets, size: 100, color: Colors.grey[600]),
        ),
      );
    } else {
      return Container(
        color: Colors.grey[300],
        child: Icon(Icons.pets, size: 100, color: Colors.grey[600]),
      );
    }
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context, 
              icon: Icons.pets, 
              label: 'Breed', 
              value: dog.breed
            ),
            SizedBox(height: 8),
            if (dog.breedGroup != null && dog.breedGroup!.isNotEmpty)
              _buildInfoRow(
                context, 
                icon: Icons.category, 
                label: 'Breed Group', 
                value: dog.breedGroup!
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required IconData icon, 
    required String label, 
    required String value
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              dog.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class FullscreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullscreenImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: 48.0,
            left: 16.0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}