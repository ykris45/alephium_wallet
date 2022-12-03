import 'package:alephium_wallet/api/repositories/alephium/alephium_api_repository.dart';
import 'package:alephium_wallet/api/repositories/base_api_repository.dart';
import 'package:alephium_wallet/api/utils/network.dart';
import 'package:alephium_wallet/bloc/wallet_home/wallet_home_bloc.dart';
import 'package:alephium_wallet/main.dart';
import 'package:alephium_wallet/storage/app_storage.dart';
import 'package:alephium_wallet/utils/helpers.dart';
import 'package:alephium_wallet/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class NetworkDropDown extends StatefulWidget {
  const NetworkDropDown({super.key});

  @override
  State<NetworkDropDown> createState() => _NetworkDropDownState();
}

class _NetworkDropDownState extends State<NetworkDropDown> {
  Network _network = AppStorage.instance.network;
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<Network>(
        menuMaxHeight: context.height / 2,
        dropdownColor: WalletTheme.instance.dropDownBackground,
        alignment: AlignmentDirectional.bottomEnd,
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _network = value!;
          });
          AppStorage.instance.network = _network;
          (getIt.get<BaseApiRepository>() as AlephiumApiRepository)
              .changeNetwork = _network;
          context.read<WalletHomeBloc>().add(WalletHomeLoadData());
        },
        decoration: InputDecoration(
          label: Text(
            "network".tr(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        value: _network,
        items: [
          ...Network.values
              .map(
                (value) => DropdownMenuItem<Network>(
                  value: value,
                  child: SizedBox(
                    child: Text(
                      value.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
