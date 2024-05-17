import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_z/auth/auth_service.dart';
import 'package:shop_a_z/pages/add_telescope_page.dart';
import 'package:shop_a_z/pages/brand_page.dart';
import 'package:shop_a_z/pages/dashboard_page.dart';
import 'package:shop_a_z/pages/description_page.dart';
import 'package:shop_a_z/pages/login_page.dart';
import 'package:shop_a_z/pages/order_details_page.dart';
import 'package:shop_a_z/pages/order_page.dart';
import 'package:shop_a_z/pages/report_page.dart';
import 'package:shop_a_z/pages/telescope_details_page.dart';
import 'package:shop_a_z/pages/user_list_page.dart';
import 'package:shop_a_z/pages/view_telescope_page.dart';
import 'package:shop_a_z/providers/order_provider.dart';
import 'package:shop_a_z/providers/telescope_provider.dart';
import 'package:shop_a_z/providers/user_provider.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if(message.notification != null) {
    print('You have a notification: ${message.notification!.title}');
  }
  print('Data: ${message.data['value']}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic('order');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TelescopeProvider()),
      ChangeNotifierProvider(create: (context) => OrderProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }

  final _router = GoRouter(
    initialLocation: DashboardPage.routeName,
    redirect: (context, state) {
      if(AuthService.currentUser == null){
        return LoginPage.routeName;
      }
      return null;
    },
    routes: [
      GoRoute(
        name: DashboardPage.routeName,
        path: DashboardPage.routeName,
        builder: (context, state) => const DashboardPage(),
        routes: [
          GoRoute(
            name: AddTelescopePage.routeName,
            path: AddTelescopePage.routeName,
            builder: (context, state) => const AddTelescopePage(),
          ),
          GoRoute(
            name: ViewTelescopePage.routeName,
            path: ViewTelescopePage.routeName,
            builder: (context, state) => const ViewTelescopePage(),
            routes: [
              GoRoute(
                name: TelescopeDetailsPage.routeName,
                path: TelescopeDetailsPage.routeName,
                builder: (context, state) => TelescopeDetailsPage(id: state.extra! as String,),
                routes: [
                  GoRoute(
                    name: DescriptionPage.routeName,
                    path: DescriptionPage.routeName,
                    builder: (context, state) => DescriptionPage(id: state.extra! as String),
                  ),
                ]
              ),
            ]
          ),
          GoRoute(
            name: BrandPage.routeName,
            path: BrandPage.routeName,
            builder: (context, state) => const BrandPage(),
          ),
          GoRoute(
            name: ReportPage.routeName,
            path: ReportPage.routeName,
            builder: (context, state) => const ReportPage(),
          ),
          GoRoute(
            name: OrderPage.routeName,
            path: OrderPage.routeName,
            builder: (context, state) => const OrderPage(),
            routes: [
              GoRoute(
                name: OrderDetailsPage.routeName,
                path: OrderDetailsPage.routeName,
                builder: (context, state) => OrderDetailsPage(orderId: state.extra! as String,),
              ),
            ]
          ),
          GoRoute(
            name: UserListPage.routeName,
            path: UserListPage.routeName,
            builder: (context, state) => const UserListPage(),
          ),
        ]
      ),
      GoRoute(
        name: LoginPage.routeName,
        path: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
    ]
  );
}
