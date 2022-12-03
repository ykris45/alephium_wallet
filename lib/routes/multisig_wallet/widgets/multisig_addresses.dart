import 'package:alephium_wallet/bloc/create_wallet/create_wallet_bloc.dart';
import 'package:alephium_wallet/routes/multisig_wallet/widgets/add_multisig_address.dart';
import 'package:alephium_wallet/routes/wallet_details/widgets/alephium_icon.dart';
import 'package:alephium_wallet/routes/widgets/appbar_icon_button.dart';
import 'package:alephium_wallet/routes/widgets/wallet_appbar.dart';
import 'package:alephium_wallet/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultisigAddressesPage extends StatefulWidget {
  final CreateWalletBloc bloc;
  final int walletsNum;
  final int requiredNum;
  final String? title;
  const MultisigAddressesPage({
    super.key,
    required this.bloc,
    required this.walletsNum,
    required this.requiredNum,
    required this.title,
  });

  @override
  State<MultisigAddressesPage> createState() => _MultisigAddressesPageState();
}

class _MultisigAddressesPageState extends State<MultisigAddressesPage> {
  late final List<String> keys;
  @override
  void initState() {
    keys = <String>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: Column(children: [
            WalletAppBar(
              label: Text(
                'multisigAddresses'.tr(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              action: AppBarIconButton(
                tooltip: "add address".tr(),
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () async {
                  if (keys.length == widget.walletsNum) return;
                  final address = await showModalBottomSheet<String>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (_) => AddMultisigAddressDialog());
                  bool isValid = address != null &&
                      address.isNotEmpty &&
                      !keys.contains(address);
                  if (isValid) {
                    setState(() {
                      keys.add(address);
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate(
                      [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Please add addresses public keys to be used as signers from your multisig wallet:"
                              .tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverReorderableList(
                      itemBuilder: (context, index) {
                        final signature = keys[index];
                        return ReorderableDragStartListener(
                          key: Key("${index}"),
                          index: index,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                tileColor: WalletTheme.instance.primary,
                                leading: Text(
                                  "#${index}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                title: Text(
                                  signature,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                horizontalTitleGap: 0,
                                trailing: IconButton(
                                  color: WalletTheme.instance.textColor,
                                  onPressed: () {
                                    keys.remove(signature);
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: keys.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          String row = keys.removeAt(oldIndex);
                          if (newIndex > oldIndex)
                            keys.insert(newIndex - 1, row);
                          else
                            keys.insert(newIndex, row);
                        });
                      },
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Please keep all public keys and private keys for those addresses safe, also please note that order of those addresses matter when restoring your address."
                                .tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Hero(
                            tag: "Button",
                            child: OutlinedButton(
                              child: Text("next".tr()),
                              onPressed: keys.length == widget.walletsNum
                                  ? () {
                                      widget.bloc.add(
                                        CreateWalletMultisigWallet(
                                          signatures: keys.cast<String>(),
                                          mrequired: widget.requiredNum,
                                          title: widget.title,
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
        Positioned.fill(
          child: BlocBuilder<CreateWalletBloc, CreateWalletState>(
              bloc: widget.bloc,
              builder: (context, state) {
                return Visibility(
                  visible: state is GenerateWalletLoading,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: AlephiumIcon(
                        spinning: true,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    ));
  }
}
