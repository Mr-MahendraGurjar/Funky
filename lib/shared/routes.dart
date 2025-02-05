// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:funky_new/agora/presentaion/cubit/Auth/auth_cubit.dart';
// import 'package:funky_new/agora/presentaion/cubit/home/home_cubit.dart';
// import 'package:funky_new/shared/constats.dart';

// import '../agora/presentaion/cubit/call/call_cubit.dart';
// import '../agora/presentaion/screens/auth_screen.dart';
// import '../agora/presentaion/screens/call_screen.dart';
// import '../agora/presentaion/screens/home_screen.dart';
// import '../data/models/call_model.dart';

// class AppRouter {
//   Route? onGenerateRoute(RouteSettings routeSettings) {
//     switch (routeSettings.name) {
//       case loginScreen:
//         return MaterialPageRoute(
//           builder: (_) {
//             return BlocProvider(
//               create: (context) => AuthCubit(),
//               child: const AuthScreen(),
//             );
//           },
//         );
//       case homeScreen:
//         return MaterialPageRoute(
//           builder: (_) {
//             return BlocProvider(
//               create: (context) => HomeCubit(),
//               child: const HomeScreen(),
//             );
//           },
//         );

//       case callScreen:
//         List<dynamic> args = routeSettings.arguments as List<dynamic>;
//         final isReceiver = args[0] as bool;
//         final callModel = args[1] as CallModel;
//         return MaterialPageRoute(
//           builder: (_) {
//             return BlocProvider(
//                 create: (_) => CallCubit(),
//                 child:
//                     CallScreen(isReceiver: isReceiver, callModel: callModel));
//           },
//         );
//     }
//     return null;
//   }
// }
