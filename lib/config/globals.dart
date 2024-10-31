import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

PersistentTabController globalTabController = PersistentTabController(initialIndex: 0);
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
