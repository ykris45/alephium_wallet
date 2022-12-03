import 'dart:io';

import 'package:alephium_wallet/bloc/create_wallet/create_wallet_bloc.dart';
import 'package:alephium_wallet/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:alephium_wallet/routes/widgets/wallet_appbar.dart';
import 'package:alephium_wallet/storage/models/wallet_store.dart';
import 'package:alephium_wallet/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'constants.dart';

class WalletMnemonicPage extends StatefulWidget {
  final WalletStore wallet;
  final CreateWalletBloc bloc;
  const WalletMnemonicPage({
    Key? key,
    required this.wallet,
    required this.bloc,
  }) : super(key: key);

  @override
  State<WalletMnemonicPage> createState() => _WalletMnemonicPageState();
}

class _WalletMnemonicPageState extends State<WalletMnemonicPage>
    with RouteAware {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    super.initState();
  }

  @override
  void didPush() {
    if (Platform.isAndroid)
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    super.didPush();
  }

  @override
  void didPushNext() {
    if (Platform.isAndroid)
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.didPushNext();
  }

  @override
  void didPop() {
    if (Platform.isAndroid)
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.didPop();
  }

  @override
  void didPopNext() {
    if (Platform.isAndroid)
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top + 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceAround,
                      children: [
                        ...widget.wallet.mnemonic!
                            .split(' ')
                            .asMap()
                            .map((index, word) {
                              return MapEntry(
                                  index,
                                  Material(
                                      elevation: 1,
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: WalletTheme
                                                  .instance.secondary,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4),
                                        child: Text(
                                          "${index + 1} - ${word}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      )));
                            })
                            .values
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  "mnemonicSafe".tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Hero(
                  tag: "Button",
                  child: OutlinedButton(
                    child: Text("next".tr()),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.walletVerifyMnemonic,
                        arguments: {
                          "wallet": widget.wallet,
                          "bloc": widget.bloc,
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        WalletAppBar(
          label: Text(
            'walletMnemonic'.tr(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    ));
  }
}
