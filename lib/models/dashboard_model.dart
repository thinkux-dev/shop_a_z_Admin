import 'package:flutter/material.dart';
import 'package:shop_a_z/pages/add_telescope_page.dart';
import 'package:shop_a_z/pages/brand_page.dart';
import 'package:shop_a_z/pages/order_page.dart';
import 'package:shop_a_z/pages/report_page.dart';
import 'package:shop_a_z/pages/user_list_page.dart';
import 'package:shop_a_z/pages/view_telescope_page.dart';

class DashboardModel {
  final String title;
  final IconData iconData;
  final String routeName;

  // Using a const so whatever value we create in this object would be a const
  // object and the property name cannot be changed afterwards
  const DashboardModel({
    required this.title,
    required this.iconData,
    required this.routeName,
  });
}

//create a list of type dashboardModel
const List<DashboardModel> dashboardModelList = [
  DashboardModel(title: 'Add Telescope', iconData: Icons.add, routeName: AddTelescopePage.routeName),
  DashboardModel(title: 'View Telescope', iconData: Icons.inventory, routeName: ViewTelescopePage.routeName),
  DashboardModel(title: 'Brands', iconData: Icons.category, routeName: BrandPage.routeName),
  DashboardModel(title: 'Orders', iconData: Icons.monetization_on, routeName: OrderPage.routeName),
  DashboardModel(title: 'Users', iconData: Icons.supervised_user_circle_sharp, routeName: UserListPage.routeName),
  DashboardModel(title: 'Report', iconData: Icons.bar_chart, routeName: ReportPage.routeName),
];