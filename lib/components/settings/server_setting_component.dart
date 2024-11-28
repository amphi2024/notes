import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_settings.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ServerSettingComponent extends StatefulWidget {
  final TextEditingController serverAddressController;

  const ServerSettingComponent(
      {super.key, required this.serverAddressController});

  @override
  State<ServerSettingComponent> createState() => _ServerSettingComponentState();
}

class _ServerSettingComponentState extends State<ServerSettingComponent> {
  int? totalSpace = null;
  int? usableSpace = null;
  int? usedSpace = null;
  bool pending = true;

  void testConnection() {
    if(appWebChannel.serverAddress.isNotEmpty) {
      appWebChannel.getStorageInfo(onSuccess: (map) {
        setState(() {
          totalSpace = map["total"];
          usableSpace = map["usable"];
          usedSpace = map["used"];
          pending = false;
        });
      }, onFailed: () {
        setState(() {
          totalSpace = null;
          usableSpace = null;
          usedSpace = null;
          pending = false;
        });
      });
    }
    else {
      pending = false;
    }

  }

  @override
  void initState() {
    testConnection();
    super.initState();
  }

  bool connectionSuccess() {
    return totalSpace != null && usableSpace != null && usedSpace != null;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: appSettings.useOwnServer,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          child: Row(
            children: [
              Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: connectionSuccess()
                            ? usableSpace! / totalSpace!
                            : 0.3,
                        center: pending
                            ? CircularProgressIndicator() : Text(
                          connectionSuccess()
                              ? "${formatBytes(usableSpace!)} /\n${formatBytes(totalSpace!)}"
                              : "",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          softWrap: true,
                          maxLines: 3,
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: connectionSuccess()
                            ? Theme.of(context).highlightColor
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                        controller: widget.serverAddressController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .get("@hint_server_address"),
                        )),
                    TextButton(
                        onPressed: () {
                          appSettings.serverAddress = widget.serverAddressController.text;
                          setState(() {
                            pending = true;
                          });
                          testConnection();
                        },
                        child: Text(AppLocalizations.of(context)
                                .get("@test_connection"))),
                    Visibility(
                      visible: !connectionSuccess(),
                      child: Text(AppLocalizations.of(context).get("@connection_failed"),
                          style: TextStyle(
                              fontSize: 12,
                              color: connectionSuccess()
                                  ? Theme.of(context).highlightColor
                                  : Theme.of(context).colorScheme.error)),
                    ),

                  ],
                ),
              )
            ],
          ),
        ));
  }
}

String formatBytes(int bytes) {
  if (bytes >= 1099511627776) {
    return "${(bytes / 1099511627776).toStringAsFixed(2)} TB";
  } else if (bytes >= 1073741824) {
    return "${(bytes / 1073741824).toStringAsFixed(2)} GB";
  } else if (bytes >= 1048576) {
    return "${(bytes / 1048576).toStringAsFixed(2)} MB";
  } else if (bytes >= 1024) {
    return "${(bytes / 1024).toStringAsFixed(2)} KB";
  } else {
    return "$bytes bytes";
  }
}
