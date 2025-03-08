import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zylentrix_assi/utils/custom_colors.dart';
import 'package:zylentrix_assi/utils/custom_widgets.dart';
import 'package:zylentrix_assi/utils/widgets_custom_appbar.dart';
import 'package:zylentrix_assi/widgets/state_controller/controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    // Call api when appliction is open
    final stateController = Provider.of<ProviderStateController>(
      context,
      listen: false,
    );
    stateController.fetchData();
  }

  @override
  Scaffold build(BuildContext context) {
    log("call");
    final stateController = Provider.of<ProviderStateController>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: appBar(() {
        // when tap replay button then fetch api data
        stateController.fetchData();
        stateController.rebuiled();
      }),
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
        child:
        // useing provider state management to rebuild widget
        Consumer<ProviderStateController>(
          builder: (context, ref, child) {
            return stateController.isLoading
                ? Center(child: const CircularProgressIndicator())
                : stateController.dataList.isEmpty
                ? Center(child: const Text("Data Not Available"))
                : Expanded(child: listViewBulider());
          },
        ),
      ),
    );
  }

  ListView listViewBulider() {
    final stateController = Provider.of<ProviderStateController>(
      context,
      listen: false,
    );
    return ListView.builder(
      itemCount: stateController.dataList.length,
      itemBuilder: (context, index) {
        Color randomColor = colorsList[_random.nextInt(colorsList.length)];
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: const Color.fromARGB(255, 236, 236, 236),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.05,
                    backgroundColor: randomColor,
                    child: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      "Title : ${stateController.dataList[index].title.toString()}",
                      maxLines: 3,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      stateController.dataList[index].body.toString(),
                      color: const Color.fromARGB(255, 4, 62, 255),
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 255, 150),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        customText(
                          "UserId : ${stateController.dataList[index].userId.toString()}",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blueGrey,
                child: customText(
                  stateController.dataList[index].id.toString(),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  PreferredSize appBar(VoidCallback onPressed) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppbar(
        title: "Zylentrix",
        iconWidget: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.replay),
        ),
      ),
    );
  }
}
