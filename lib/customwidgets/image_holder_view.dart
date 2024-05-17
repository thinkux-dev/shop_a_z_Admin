import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_a_z/models/image_model.dart';

class ImageHolderView extends StatelessWidget {
  final ImageModel imageModel;
  final VoidCallback onImagepressed;
  const ImageHolderView({super.key, required this.imageModel, required this.onImagepressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      child: InkWell(
        onTap: onImagepressed,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imageModel.downloadUrl,
          placeholder: (context, url) => 
              const Center(child: CircularProgressIndicator(),),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
