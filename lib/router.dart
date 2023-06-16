import 'package:flutter/material.dart';
import 'package:troca/models/wallet.dart';
import 'package:troca/screens/authentication/login_screen.dart';
import 'package:troca/screens/bottom_nav_bar.dart';
import 'package:troca/screens/chat/chat_screen.dart';
import 'package:troca/screens/search/search_result.dart';
import 'package:troca/screens/search/search_user.dart';
import 'package:troca/screens/user/connect_mobile.dart';
import 'package:troca/screens/user/user_list_screen.dart';
import 'package:troca/screens/user/user_settings.dart';
import 'package:xmtp/xmtp.dart';
import 'models/test_connecter.dart';

Route<dynamic>? generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case WalletPage.routeName:
      TestConnector connector = routeSettings.arguments as TestConnector;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => WalletPage(
          connector: connector,
        ),
      );

    case UserListScreen.routeName:
      Client client = routeSettings.arguments as Client;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UserListScreen(
          client: client,
        ),
      );

    case ChatScreen.routeName:
      // Client client = routeSettings.arguments as Client;
      // Conversation conversation = routeSettings.arguments as Conversation;
      List<dynamic> client = routeSettings.arguments as List<dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatScreen(
          client: client[0],
          conversation: client[1],
        ),
      );

    case ConnectMobile.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ConnectMobile(),
      );

    case UserSettings.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UserSettings(),
      );

    case SearchResult.routeName:
      // Client client = routeSettings.arguments as Client;
      // String ethereum = routeSettings.arguments as String;

      List<dynamic> args = routeSettings.arguments as List<dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchResult(
          ethereum: args[0],
          client: args[1],
        ),
      );

    case SearchUser.routeName:
      Client client = routeSettings.arguments as Client;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchUser(
          client: client,
        ),
      );

    case BottomBar.routeName:
      Client client = routeSettings.arguments as Client;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => BottomBar(
          client: client,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
