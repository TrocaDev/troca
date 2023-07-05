// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:troca/models/test_connecter.dart';
import 'package:troca/screens/authentication/wallet.dart';
import 'package:troca/routes/app_route_constants.dart';
import 'package:troca/screens/authentication/login_screen.dart';
import 'package:troca/screens/user/test.dart';
import 'package:troca/screens/user/test_chat.dart';
import 'package:troca/screens/bottom_nav_bar.dart';
import 'package:troca/screens/error_page.dart';
import 'package:troca/screens/search/dm.dart';
import 'package:troca/screens/search/search_result.dart';
import 'package:troca/screens/search/search_user.dart';
import 'package:troca/screens/user/connect_mobile.dart';
import 'package:troca/screens/user/user_list_screen.dart';
import 'package:troca/screens/user/user_settings.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

class TrocaRoutes {
  GoRouter router = GoRouter(
    routes: [
      //Login Page
      GoRoute(
        name: TrocaRouteConstants.loginRoute,
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(child: AuthScreen());
        },
      ),
      //Wallet Page
      GoRoute(
        name: TrocaRouteConstants.walletPageRoute,
        path: '/wallet-page/:connector',
        pageBuilder: (context, state) {
          TestConnector connector = state.extra as TestConnector;
          return MaterialPage(
              child: WalletPage(
            connector: connector,
          ));
        },
      ),
      //User List Screen
      GoRoute(
        name: TrocaRouteConstants.userListScreenRoute,
        path: '/user-list-screen',
        pageBuilder: (context, state) {
          xmtp.Client client = state.extra as xmtp.Client;
          return MaterialPage(
              child: UserListScreen(
            client: client,
          ));
        },
      ),
      //Test Screen
      GoRoute(
        name: TrocaRouteConstants.testScreenRoute,
        path: '/testscreen',
        pageBuilder: (context, state) {
          xmtp.Client client = state.extra as xmtp.Client;
          return MaterialPage(
              child: TestScreen(
            client: client,
          ));
        },
      ),
      //Test Chat Screen
      GoRoute(
        name: TrocaRouteConstants.testChatScreenRoute,
        path: '/test-chat-screen',
        pageBuilder: (context, state) {
          xmtp.Conversation conversation = state.extra as xmtp.Conversation;
          return MaterialPage(
            child: TestChatScreen(
              conversation: conversation,
            ),
          );
        },
      ),
      //Connect Mobile Screen
      GoRoute(
        name: TrocaRouteConstants.connectMobileRoute,
        path: '/connect-mobile',
        pageBuilder: (context, state) {
          return MaterialPage(child: ConnectMobile());
        },
      ),
      //User Settings Screen
      GoRoute(
        name: TrocaRouteConstants.userSettingsRoute,
        path: '/user-settings-screen',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: UserSettings(),
          );
        },
      ),

      //Search Result Screen
      GoRoute(
        name: TrocaRouteConstants.searchResultRoute,
        path: '/search-result-screen/:ethereum',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: SearchResult(
              ethereum: state.pathParameters['ethereum']!,
            ),
          );
        },
      ),
      //Search Result Screen
      GoRoute(
        name: TrocaRouteConstants.dmRoute,
        path: '/dm/:ethereum',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: DM(
              ethereum: state.pathParameters['ethereum']!,
            ),
          );
        },
      ),
      //Search User Page
      GoRoute(
        name: TrocaRouteConstants.searchUserRoute,
        path: '/search-user',
        pageBuilder: (context, state) {
          return MaterialPage(child: SearchUser());
        },
      ),
      //Bottom Bar Screen
      GoRoute(
        name: TrocaRouteConstants.bottomBarRoute,
        path: '/home',
        pageBuilder: (context, state) {
          xmtp.Client client = state.extra as xmtp.Client;
          return MaterialPage(
            child: BottomBar(
              client: client,
            ),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: ErrorPage(),
      );
    },
  );
}
