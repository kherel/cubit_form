import 'dart:async';
import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';

typedef CubitFormFieldsWidgetBuilder = Widget Function(
  BuildContext context,
  List<FieldCubitState> stateList,
);

class CubitFormFieldsBuilder extends StatefulWidget {
  const CubitFormFieldsBuilder({
    Key? key,
    required this.fields,
    required this.builder,
  }) : super(key: key);

  final List<FieldCubit> fields;
  final CubitFormFieldsWidgetBuilder builder;

  @override
  _CubitFormFieldsBuilderState createState() => _CubitFormFieldsBuilderState();
}

class _CubitFormFieldsBuilderState extends State<CubitFormFieldsBuilder> {
  late StreamController<_EventWithIndex> controller;
  List<FieldCubitState> fieldStates = [];
  @override
  void initState() {
    super.initState();
    var streams = <Stream<FieldCubitState<dynamic>>>[];

    for (var f in widget.fields) {
      streams.add(f.stream);
      fieldStates.add(f.state);
    }
    controller = streamRiver(streams)
      ..stream.forEach((element) {
        var newFieldState = [...fieldStates];
        newFieldState[element.index] = element.state;
        setState(() => fieldStates = newFieldState);
      });
    setState(() {});
  }

  @override
  void dispose() {
    controller.onCancel!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, fieldStates);
  }
}

StreamController<_EventWithIndex> streamRiver(
    List<Stream<FieldCubitState>> streams) {
  late StreamController<_EventWithIndex> controller;
  var subscriptions = <StreamSubscription<FieldCubitState>>[];

  void startListining() {
    for (var i = 0; i < streams.length; i++) {
      var stream = streams[i];
      subscriptions.add(stream.listen((event) {
        controller.add(_EventWithIndex(index: i, state: event));
      }));
    }
  }

  void onCancel() {
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
  }

  controller = StreamController(
    onListen: startListining,
    onPause: onCancel,
    onResume: startListining,
    onCancel: onCancel,
  );

  return controller;
}

class _EventWithIndex {
  final int index;
  final FieldCubitState state;

  const _EventWithIndex({required this.index, required this.state});
}
