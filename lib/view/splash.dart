import 'package:flutter/material.dart';
import 'package:food_source/localization.dart';
import 'package:food_source/view/home.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const splashInDuration = Duration(seconds: 1);

/// Check for must have permissions
/// Check for internet connectivity
class SplashView extends StatefulHookConsumerWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SplashViewState();
}

class SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();

    Future.delayed(splashInDuration, () {
      Navigator.pushAndRemoveUntil(
        context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeOutQuint;

              final tween = Tween(begin: begin, end: end);
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );

              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            },
          ),
        ModalRoute.withName('/home'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Lz.of(context)!.title),
          Text(Lz.of(context)!.tagline),
        ],
      )),
    );
  }
}
