// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

void main() {
  runApp(const EasyLoadingApp());
}

class EasyLoadingApp extends StatefulWidget {
  const EasyLoadingApp({Key? key}) : super(key: key);

  @override
  _EasyLoadingAppState createState() => _EasyLoadingAppState();
}

class _EasyLoadingAppState extends State<EasyLoadingApp> {
  List<String> items = [];
  bool loading = false, allLoaded = false;
  final ScrollController _scrollController = ScrollController();

  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => "List Item ${index + items.length}");
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        print('NEW DATA CALL');
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Lazy Loading App'),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (items.isNotEmpty) {
                return Stack(children: [
                  ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if(index<items.length)
                        {
                          return ListTile(
                            title: Text(items[index]),
                          );
                        }else{
                        return Container(
                          width: constraints.maxWidth,
                          height:50,
                          child: const Center(
                            child:Text('Nothing more to load',)
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                      );
                    },
                    itemCount: items.length + (allLoaded?1:0),
                  ),
                  if(loading)...[
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          width: constraints.maxWidth,
                          height: 80,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ))
                  ],
                ]);
              } else {
                return Container(
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
            },
          )),
    );
  }
}
