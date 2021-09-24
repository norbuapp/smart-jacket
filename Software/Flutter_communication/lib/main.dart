import 'package:norbusensor/src/features/devices/blocs/bloc_device/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:norbusensor/src/features/devices/bluetooth_off_screen.dart';
import 'package:norbusensor/src/features/devices/scan_devices_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks_bloc/flutter_hooks_bloc.dart' as fromHooks;

import 'package:norbusensor/src/core/core_providers.dart';
import 'package:norbusensor/src/core/routes.dart';
import 'package:norbusensor/src/features/datasensor/data_sensor_screen.dart';
import 'package:norbusensor/src/features/datasensor/blocs/bloc_data_sensor/data_sensor_bloc.dart';

void main() {
  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BuildContextX(context).read(sensorBlocProvider).add(InitSensor());
    return MaterialApp(
      color: Colors.lightBlue,
      navigatorKey: BuildContextX(context).read(navigatorKeyProvider),
      home: fromHooks.BlocBuilder<DeviceBloc, DeviceState>(
          cubit: BuildContextX(context).read(deviceBlocProvider),
          buildWhen: (previous, current) => (previous.stateBle != current.stateBle),
          builder: (context, state) {
            if (state.stateBle == BluetoothState.on) {
              return ScanDevicesScreen();
            }
            return BluetoothOffScreen(state: state.stateBle);
          }),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}