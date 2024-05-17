import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_z/providers/order_provider.dart';
import 'package:shop_a_z/utils/constants.dart';

class OrderDetailsPage extends StatelessWidget {
  static const String routeName = 'order_details';
  final String orderId;

  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderProvider>(context, listen: false).getOrderById(orderId);
    return Scaffold(
      appBar: AppBar(
        title: Text(orderId),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            title: Text(order.appUser.email),
            subtitle: const Text('Customer info'),
          ),
          ListTile(
            title: Text(order.orderStatus),
            subtitle: const Text('Order Status'),
          ),
          ListTile(
            title: Text('$currencySymbol${order.totalAmount}'),
            subtitle: const Text('Order Amount'),
          ),
          ...order.itemDetails.map((itemDetail) => ListTile(
            leading: CircleAvatar(
              child: CachedNetworkImage(
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                imageUrl: itemDetail.imageUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            title: Text(itemDetail.telescopeModel),
            trailing: Text('${itemDetail.quantity}x$currencySymbol${itemDetail.price}'),
          )).toList(),
        ],
      ),
    );
  }
}
