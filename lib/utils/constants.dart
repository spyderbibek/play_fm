import 'package:flutter/material.dart';
import 'package:play_fm/model/news_model.dart';

const kTabLabelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0);
const kUnSelectedTabLabelStyle =
    TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0);

const List<News> newsSource = const <News>[
  const News(
      name: "E-Kantipur",
      url: "https://ekantipur.com/",
      logoUrl:
          "https://jcss-cdn.kantipurdaily.com/kantipurdaily/images/logo.png"),
  const News(
      name: "Onlinekhabar",
      url: "https://www.onlinekhabar.com/",
      logoUrl:
          "https://www.onlinekhabar.com/wp-content/themes/onlinekhabar-2018/img/logoMain.png"),
  const News(
      name: "RatoPati",
      url: "https://ratopati.com/",
      logoUrl:
          "https://ratopati.prixa.net/media/albums/ratopati_logo-white_dMOXtPrhp9.png"),
  const News(
      name: "Annapurnapost",
      url: "http://annapurnapost.com/",
      logoUrl:
          "http://mlcsconsult.com.np/wp-content/uploads/2018/11/annapurna-post-online-news-of-nepal-300x111.jpg"),
  const News(
      name: "Setopati",
      url: "https://www.setopati.com/",
      logoUrl:
          "https://pbs.twimg.com/profile_images/588936040888438784/RxOOcrCe_400x400.jpg"),
  const News(
      name: "News24Nepal",
      url: "https://www.news24nepal.tv/",
      logoUrl:
          "https://www.news24nepal.tv/wp-content/themes/news24nepal/img/logo.png?x81153"),
  const News(
      name: "Nagariknews",
      url: "https://nagariknews.nagariknetwork.com/",
      logoUrl:
          "https://nagariknews.nagariknetwork.com/bundles/nagarikfrontend/images/logo-nagarik11-new.png"),
];
