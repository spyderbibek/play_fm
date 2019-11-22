import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_fm/model/radio_model.dart';
import 'package:play_fm/screens/player_screen.dart';
import 'package:play_fm/utils/constants.dart';
import 'package:play_fm/utils/webservice.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Webservice webservice = Webservice();
  String searchText = "";
  String filter;
  int totalStations;
  TextEditingController searchController = TextEditingController();
  List<RadioModel> _searchResult = [];
  List<RadioModel> _radioDetails = [];

  @override
  void initState() {
    // TODO: implement initState
    searchController.addListener(() {
      setState(() {
        onSearchTextChanged(searchController.text);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,

          //backgroundColor: Colors.transparent,
          bottom: TabBar(
            isScrollable: true,
            labelStyle: kTabLabelStyle,
            unselectedLabelStyle: kUnSelectedTabLabelStyle,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
            ),
            tabs: <Widget>[
              Tab(
                text: "Search",
              ),
              Tab(
                text: "Top Station",
              ),
              Tab(
                text: "Favorite",
              ),
              Tab(
                text: "Setting",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0))),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 16.0,
                        ),
                        Icon(
                          FontAwesomeIcons.search,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (text) {
                              setState(() {
                                searchText = text;
                                searchController.text = "";
                              });
                            },
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                                hintText: 'Search Radio Station.......',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Search Text
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        searchText ?? " ",
                        style: TextStyle(
                            fontSize: 35.0, fontWeight: FontWeight.w800),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "$totalStations stations, ",
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                          Text(
                            "5 favorites",
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                FutureBuilder<List<RadioModel>>(
                  future: webservice.fetchStations(),
                  builder: (context, snapshot) {
                    _radioDetails = snapshot.data ?? [];
                    totalStations = _radioDetails.length;
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return Flexible(
                        child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(top: 40.0),
                      decoration: BoxDecoration(
                          //color: Colors.white.withOpacity(0.5),
                          color: Color(0xFF5D16A2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0))),
                      child: _searchResult.length != 0 ||
                              searchController.text.isNotEmpty
                          ? ListView.builder(
                              itemCount: _searchResult.length,
                              itemBuilder: (context, index) {
                                RadioModel radio = _searchResult[index];
                                totalStations = _searchResult.length;
                                return RadioList(
                                  radio: radio,
                                  radioList: _searchResult,
                                  index: index,
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: _radioDetails.length,
                              itemBuilder: (context, index) {
                                RadioModel radio = snapshot.data[index];
                                return RadioList(
                                  radio: radio,
                                  radioList: _radioDetails,
                                  index: index,
                                );
                              }),
                    ));
                  },
                )
              ],
            ),
            Container(
              child: Text("tab2"),
            ),
            Container(
              child: Text("tab3"),
            ),
            Container(
              child: Text("tab4"),
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _radioDetails.forEach((radioDetails) {
      if (radioDetails.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(radioDetails);
    });

    setState(() {});
  }
}

class RadioList extends StatelessWidget {
  RadioList(
      {@required this.radio, @required this.radioList, @required this.index});

  final RadioModel radio;
  final List<RadioModel> radioList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerScreen(
                      radioStations: radioList,
                      index: index,
                    )));
      },
      child: Container(
        //color: Colors.deepOrange,
        padding: const EdgeInsets.only(left: 25.0, bottom: 15.0, right: 25.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 30.0,
              backgroundColor: Colors.red,
              backgroundImage: NetworkImage(
                radio.image,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Text(
                radio.name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
