import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tagline_demo/constants.dart';
import 'package:tagline_demo/model/dummy_user_model.dart';
import 'package:tagline_demo/services/retrofits.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  int pageNo = 0;
  List<Data> _dummyData = [];
  int totalRecord = 0;
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUser1(pageNo.toString()).then((value) {
        totalRecord = value.totalPassengers;
        _dummyData = value.data;

        setState(() {
          loading = false;
        });
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent - 10 ==
          _scrollController.offset - 10) {
        if (totalRecord < _dummyData.length) {
          showErrorSnackBar(context, "Data Over");
          return;
        }


        Future.delayed(Duration(milliseconds: 200), () async {
          pageNo++;

          await getUser1(pageNo.toString()).then((value) {
            _dummyData = _dummyData + value.data;
            setState(() {});
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dummy API Response"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _dummyData.length == 0
              ? Center(
                  child: Text("Data Not Found"),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index == _dummyData.length) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: Center(child: CircularProgressIndicator())),
                      );
                    }
                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                          leading: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: FadeInImage(
                              placeholder: AssetImage("assets/palceholder.jpg"),
                              image:
                                  NetworkImage(_dummyData[index].iV.toString()),
                            ),
                          ),
                          title: Text(_dummyData[index].name ?? "No Data"),
                          subtitle: Text(
                              _dummyData[index].trips.toString() ?? "No Data")),
                    );
                  },
                  itemCount: _dummyData.length + 1,
                ),
    );
  }
}
