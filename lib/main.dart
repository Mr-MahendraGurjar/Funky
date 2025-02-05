import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:funky_new/services/notification_service.dart';
import 'package:funky_new/sharePreference.dart';
import 'package:funky_new/shared/dio_helper.dart';
import 'package:funky_new/splash_screen.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'agora/presentaion/cubit/Auth/auth_cubit.dart';
import 'agora/presentaion/cubit/home/home_cubit.dart';
import 'data/api/auth_api.dart';
import 'getx_pagination/Bindings_class.dart';
import 'getx_pagination/binding_utils.dart';
import 'getx_pagination/page_route.dart';
import 'services/fcm/firebase_messaging_service.dart';
import 'services/stripe_service.dart';
import 'shared/network/cache_helper.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  await PreferenceManager().init();
  DioHelper.init();
  await CacheHelper.init();
  await FirebaseMessagingService.initialize();
  await FirebaseMessagingService.onBackgroundMessage();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Stripe.publishableKey = StripePaymentHandle.PUBLISHABLE_KEY;
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
  Timer.periodic(const Duration(minutes: 1), (Timer timer) {
    if (CacheHelper.getString(key: 'uId').isNotEmpty) {
      AuthApi().updateUserStatus(timestamp: DateTime.now().toString());
    }
  });
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// Top level function to handle incoming messages when the app is in the background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(" --- background message received ---");
  print(message.notification!.title);
  print(message.notification!.body);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthCubit()..getUserData(uId: CacheHelper.getString(key: 'uId')),
        ),
        BlocProvider(
          create: (_) => HomeCubit()
            ..listenToInComingCalls()
            ..getUsersRealTime()
            ..getCallHistoryRealTime()
            //..initFcm(context)
            ..updateFcmToken(uId: CacheHelper.getString(key: 'uId')),
        ),
      ],
      child: GetMaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Funky',
        initialRoute: BindingUtils.initialRoute,
        initialBinding: Splash_Bindnig(),
        getPages: AppPages.getPageList,
        navigatorObservers: [routeObserver],
        home: const SplashScreen(),
        theme: ThemeData(
          primaryColor: Colors.yellow,
          dividerColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          //colorScheme: const ColorScheme(background: Colors.black),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _imageList = [];
  final List<int> _selectedIndexList = [];
  final List<String> _selectedList = [];
  bool _selectionMode = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    if (_selectionMode) {
      buttons.add(IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _selectedIndexList.sort();
            print(
                'Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
          }));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("widget.title"),
        actions: buttons,
      ),
      body: _createBody(),
    );
  }

  @override
  void initState() {
    super.initState();

    _imageList.add('https://picsum.photos/800/600/?image=280');
    _imageList.add('https://picsum.photos/800/600/?image=281');
    _imageList.add('https://picsum.photos/800/600/?image=282');
    _imageList.add('https://picsum.photos/800/600/?image=283');
    _imageList.add('https://picsum.photos/800/600/?image=284');
  }

  void _changeSelection({bool? enable, int? index}) {
    _selectionMode = enable!;
    _selectedIndexList.add(index!);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      primary: false,
      itemCount: _imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      staggeredTileBuilder: (int index) => const StaggeredTile.count(1, 1),
      padding: const EdgeInsets.all(4.0),
    );
  }

  GridTile getGridTile(int index) {
    if (_selectionMode) {
      return GridTile(
          header: GridTileBar(
            leading: Icon(
              _selectedIndexList.contains(index)
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index)
                  ? Colors.green
                  : Colors.black,
            ),
          ),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 30.0)),
              child: Image.network(
                _imageList[index],
                fit: BoxFit.cover,
              ),
            ),
            onLongPress: () {
              setState(() {
                _changeSelection(enable: false, index: -1);
              });
            },
            onTap: () {
              setState(() {
                if (_selectedIndexList.contains(index)) {
                  _selectedIndexList.remove(index);
                  _selectedList.remove(_imageList[index]);
                } else {
                  _selectedIndexList.add(index);
                  _selectedList.add(_imageList[index]);
                }
              });
              print(_selectedList[0]);
            },
          ));
    } else {
      return GridTile(
        child: InkResponse(
          child: Image.network(
            _imageList[index],
            fit: BoxFit.cover,
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
          },
        ),
      );
    }
  }
}
