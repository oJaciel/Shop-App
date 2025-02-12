import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/order.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  const OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('R\$ ${order.total.toStringAsFixed(2)}'),
        subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.date)),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.expand_more)),
      ),

    );
  }
}
