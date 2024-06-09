import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:re_open_chat/components/hello/tabbed_view.dart';
import 'package:re_open_chat/gen/assets.gen.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:re_open_chat/view/splash.dart';

class Hello extends StatefulWidget {
  const Hello({super.key});

  @override
  State<Hello> createState() => _HelloState();
}

class _HelloState extends State<Hello> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final double topPadding = screenSize.width * 0.7234;
  double screenHeight = double.infinity;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<double>(
      begin: screenSize.height,
      end: topPadding,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCirc));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    readGlobalBloc(context)
        .add(const SwitchAppPage(currentPage: AppPage.hello));
    return Scaffold(
      backgroundColor: const Color.fromRGBO(124, 110, 156, 1.0),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: SizedBox(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: Assets.imgs.background.image(fit: BoxFit.fitWidth))),
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: _buildCardBody(
                    screenSize.height,
                    screenSize.width,
                    context,
                  ),
                );
              }),
        ],
      ),
    );
  }

  Container _buildCardBody(double height, double width, BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: readThemeData(context).colorScheme.primary.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: const TabbedView(),
    );
  }
}
