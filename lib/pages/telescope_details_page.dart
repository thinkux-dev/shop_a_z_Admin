import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_z/customwidgets/image_holder_view.dart';
import 'package:shop_a_z/models/image_model.dart';
import 'package:shop_a_z/models/telescope_model.dart';
import 'package:shop_a_z/pages/description_page.dart';
import 'package:shop_a_z/providers/telescope_provider.dart';
import 'package:shop_a_z/utils/constants.dart';
import 'package:shop_a_z/utils/helper_functions.dart';
import 'package:shop_a_z/utils/widget_functions.dart';
import 'package:image_picker/image_picker.dart';

class TelescopeDetailsPage extends StatefulWidget {
  static const String routeName = 'telescopedetails';
  final String id;
  const TelescopeDetailsPage({super.key, required this.id});

  @override
  State<TelescopeDetailsPage> createState() => _TelescopeDetailsPageState();
}

class _TelescopeDetailsPageState extends State<TelescopeDetailsPage> {
  late TelescopeModel telescopeModel;
  late TelescopeProvider provider;

  @override
  void didChangeDependencies() {
    provider = Provider.of<TelescopeProvider>(
      context,
    );
    telescopeModel = provider.findTelescopeById(widget.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(telescopeModel.model, style: TextStyle(overflow: TextOverflow.ellipsis),),
        ),
        body: ListView(
          children: [
            CachedNetworkImage(
              width: double.infinity,
              height: 200,
              imageUrl: telescopeModel.thumbnail.downloadUrl,
              placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(),),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Card(
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    FloatingActionButton.small(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      tooltip: 'Add additional image',
                      child: const Icon(Icons.add),
                    ),
                    if(telescopeModel.additionalImage.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Center(
                          child: Text(
                            'Add other images',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ...telescopeModel.additionalImage.map((image) => ImageHolderView(
                        imageModel: image,
                        onImagepressed: () {
                          _showImageOnDialog(image);
                        },
                    )),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                telescopeModel.description == null ?
                    context.goNamed(DescriptionPage.routeName, extra: telescopeModel.id)
                    : _showDescriptionDialog();
              },
              child: Text(telescopeModel.description == null
                ? 'Add Description'
                : 'Show Description'
              ),
            ),
            ListTile(
              title: Text(telescopeModel.brand.name),
              subtitle: Text(telescopeModel.model),
            ),
            ListTile(
              title: Text(
                  'Sales Price(with discount):  $currencySymbol${priceAfterDiscount(telescopeModel.price, telescopeModel.discount).toStringAsFixed(0)}'),
              subtitle: Text('Original Price: $currencySymbol${telescopeModel.price}'),
              trailing: IconButton(
                onPressed: () {
                  showSingleTextInputDialog(
                    context: context,
                    title: 'Edit Price',
                    onSubmit: (value) {
                      EasyLoading.show(status: 'Please Wait');
                      provider
                        .updateTelescopeField(telescopeModel.id!, 'price', num.parse(value))
                        .then((value) {
                          EasyLoading.dismiss();
                          showMsg(context, 'Price Updated');
                        })
                        .catchError((error) {
                          EasyLoading.dismiss();
                        });
                    },
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            ListTile(
              title: Text('Discount:  ${telescopeModel.discount}%'),
              trailing: IconButton(
                onPressed: () {
                  showSingleTextInputDialog(
                    context: context,
                    title: 'Edit Discount',
                    onSubmit: (value) {
                      EasyLoading.show(status: 'Please Wait');
                      provider
                          .updateTelescopeField(telescopeModel.id!, 'discount', num.parse(value))
                          .then((value) {
                        EasyLoading.dismiss();
                        showMsg(context, 'Discount Updated');
                      })
                          .catchError((error) {
                        EasyLoading.dismiss();
                      });
                    },
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            ListTile(
              title: Text('Stock:  ${telescopeModel.stock}'),
              trailing: IconButton(
                onPressed: () {
                  showSingleTextInputDialog(
                    context: context,
                    title: 'Edit Stock',
                    onSubmit: (value) {
                      EasyLoading.show(status: 'Please Wait');
                      provider
                          .updateTelescopeField(telescopeModel.id!, 'stock', num.parse(value))
                          .then((value) {
                        EasyLoading.dismiss();
                        showMsg(context, 'Stock Updated');
                      })
                          .catchError((error) {
                        EasyLoading.dismiss();
                      });
                    },
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            )
          ],
        ),
    );
  }

  void getImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source, imageQuality: 50);
    if(file != null) {
      EasyLoading.show(status: 'Please wait');
      final newImage = await provider.uploadImage(file.path);
      telescopeModel.additionalImage.add(newImage);
      provider.updateTelescopeField(
          telescopeModel.id!,
          'additionalImage',
          toImageMapList(telescopeModel.additionalImage))
      .then((value) {
        EasyLoading.dismiss();
        showMsg(context, 'Added');
        setState(() {

        });
      })
      .catchError((error) {
        EasyLoading.dismiss();
        showMsg(context, 'Failed to add');
      });
    }
  }

  void _showImageOnDialog(ImageModel image) {
    showDialog(context: context, builder: (context) => AlertDialog(
      content: CachedNetworkImage(
        fit: BoxFit.contain,
        height: MediaQuery.of(context).size.height / 2,
        imageUrl: image.downloadUrl,
        placeholder: (context, url) => 
        const Center(child: CircularProgressIndicator(),),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        IconButton(
          onPressed: () async {
            Navigator.pop(context);
            EasyLoading.show(status: 'Please wait');
            try{
              await provider.deleteImage(telescopeModel.id!, image);
              telescopeModel.additionalImage.remove(image);
              await provider.updateTelescopeField(
                  telescopeModel.id!,
                  'additionalImage',
                  toImageMapList(telescopeModel.additionalImage));
              EasyLoading.dismiss();
              setState(() {

              });
            }catch(err){
              EasyLoading.dismiss();
            }
          },
          icon: const Icon(Icons.delete)
        ),
      ],
    ));
  }

  _showDescriptionDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(telescopeModel.model),
      content: SingleChildScrollView(
        child: Text(telescopeModel.description!),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.goNamed(DescriptionPage.routeName, extra: telescopeModel.id);
          }, 
          child: const Text('Edit'),
        ),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Close'),
        )
      ],
    ));
  }
}
