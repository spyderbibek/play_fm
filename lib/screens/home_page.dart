import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_fm/model/radio_model.dart';
import 'package:play_fm/utils/constants.dart';
import 'package:play_fm/utils/webservice.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Webservice webservice = Webservice();
  String searchText = "";
  TextEditingController searchController = TextEditingController();
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
                            "32 stations, ",
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
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return Flexible(
                      child: ListView(
                        children: snapshot.data
                            .map((radio) => ListTile(
                                  title: Text(radio.name),
                                  subtitle: Text(radio.link),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Image.network(radio.image),
                                  ),
                                ))
                            .toList(),
                      ),
                    );
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
}
