import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<File_Data_Model> onDroppedFile;
  final bool isMultiple;

  const DropZoneWidget(
      {Key? key, required this.onDroppedFile, required this.isMultiple})
      : super(key: key);

  @override
  _DropZoneWidgetState createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> with WidgetHelper {
  late DropzoneViewController controller;
  bool highlight = false;
  List<String> fileTypes = ['image/jpg', 'image/jpeg', 'image/png', '.pdf'];

  @override
  Widget build(BuildContext context) {
    return buildDecoration(
        child: Stack(
      children: [
        kIsWeb
            ? DropzoneView(
                onCreated: (controller) => this.controller = controller,
                cursor: CursorType.pointer,
                onDrop: (val) {
                  String name = val.name;
                  if (name.contains('.png') ||
                      name.contains('.jpg') ||
                      name.contains('.jpeg') ||
                      name.contains('.pdf')) {
                    UploadedFile(val);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('It only supports jpg, png or pdf file format'),
                      duration: Duration(seconds: 3),
                    ));
                  }
                },
                onDropMultiple: (ev) async {},
                onHover: () => setState(() => highlight = true),
                onLeave: () => setState(() => highlight = false),
              )
            : Text(''),
        GestureDetector(
          onTap: () async {
            if (kIsWeb) {
              final events = await controller.pickFiles(
                  multiple: widget.isMultiple, mime: fileTypes);
              if (events.isEmpty) return;
              events.forEach((element) {
                String name = element.name;
                if (name.contains('.png') ||
                    name.contains('.jpg') ||
                    name.contains('.jpeg') ||
                    name.contains('.pdf')) {
                  UploadedFile(element);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('It only supports jpg, png or pdf file format'),
                    duration: Duration(seconds: 3),
                  ));
                }
              });
            }
          },
          child: Center(
            child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: buildText(
                            text: S.of(context).dropFilesToUpload,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontColor: const Color(0xff3F70D4))),
                    SizedBox(height: getScreenHeight(context) * 0.005),
                    Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: buildText(
                            text: S.of(context).supportedFileFormat5MB,
                            fontWeight: FontWeight.w400,
                            fontColor: const Color(0xffA1A5AD)))
                  ],
                )),
          ),
        ),
      ],
    ));
  }

  Future UploadedFile(dynamic event) async {
    final name = event.name;

    final mime = await controller.getFileMIME(event);
    final byte = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    final path = await controller.getFileData(event);

    final kb = byte / 1024;

    var sizeLimit = 5120;

    if (kb > sizeLimit) {
      //SnackBar(content: Text('Upload file less than 5MB'));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Upload file less than 5MB"),
        duration: Duration(seconds: 3),

      ));
    } else {
      final droppedFile = File_Data_Model(
          name: name, mime: mime, bytes: byte, url: url, path: path);

      widget.onDroppedFile(droppedFile);
      setState(() {
        highlight = false;
      });
    }
  }

  Widget buildDecoration({required Widget child}) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: DashedRect(
          color: hanBlueTint400, strokeWidth: 1.0, gap: 5.0, child: child),
    );
  }
}

class File_Data_Model {
  final String name;
  final String mime;
  final int bytes;
  final String url;
  final path;

  File_Data_Model(
      {required this.path,
      required this.name,
      required this.mime,
      required this.bytes,
      required this.url});

  String get size {
    final kb = bytes / 1024;
    final mb = kb / 1024;

    return mb > 1
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
  }
}

Widget buildDropFilesBox(
    {context,
    isFileAdded,
    loading,
    progressValue,
    file,
    onDroppedFile,
    int? dropBox,
    void Function()? onIconClosePressUpload,
    void Function()? onIconClosePressFinish,
    isAllowMultiple = false,
    registerNotifier}) {
  return isFileAdded == false
      ? Container(
          width: getScreenWidth(context) < 450
              ? getScreenWidth(context) * 0.86
              : isTab(context) || isMobile(context)
                  ? getScreenWidth(context) * 0.70
                  : getScreenWidth(context) * 0.46,
          height: getScreenWidth(context) < 350 ? 130 : 100,
          color: Color(0x0f8CA9E5),
          child: DropZoneWidget(
            onDroppedFile: onDroppedFile,
            isMultiple: isAllowMultiple,
          ))
      : loading == true && isAllowMultiple == false
          ? uploadScreen(context, progressValue, file, onIconClosePressUpload,
              isAllowMultiple, registerNotifier, dropBox: dropBox)
          : finishUpload(context, file, onIconClosePressFinish, isAllowMultiple,
              registerNotifier,
              dropBox: dropBox,onDroppedFile: onDroppedFile);
}

Widget uploadScreen(context, progressValue, file,
    void Function()? onIconClosePressUpload, isAllowMultiple, registerNotifier,
    {dropBox}) {
  return Container(
      color: Color(0x0f8CA9E5),
      width: getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.86
          : isTab(context) || isMobile(context)
              ? getScreenWidth(context) * 0.70
              : getScreenWidth(context) * 0.46,
      height: isAllowMultiple ? 130 : null,
      child: DashedRect(
          color: hanBlueTint400,
          strokeWidth: 1.0,
          gap: 5.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) * 0.01,
                vertical: getScreenHeight(context) * 0.011),
            child: isAllowMultiple
                ? ListView.separated(
                    itemCount: file.length,
                    itemBuilder: (context, position) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextDrop(
                              text: 'Uploading...',
                              fontColor: Colors.blue,
                              fontSize: 16,
                              false),
                          Visibility(
                              child: SizedBoxHeight(context, 0.01),
                              visible: getScreenWidth(context) < 375),
                          getScreenWidth(context) < 375
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildTextDrop(
                                        text: file[position]!.name,
                                        context: context,
                                        fontColor: Colors.grey,
                                        false),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        buildTextDrop(
                                            text:
                                                '${file[position]!.size}/5 MB',
                                            fontColor: Colors.grey,
                                            false),
                                        SizedBox(
                                            width:
                                                getScreenWidth(context) * 0.01),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.close, size: 20),
                                          onPressed: () {
                                            if (dropBox == 1) {
                                              registerNotifier.fileNonDigital1
                                                  .removeAt(position);
                                              registerNotifier.progressValue =
                                                  0.0;
                                              if (registerNotifier
                                                      .fileNonDigital1.length ==
                                                  0) {
                                                registerNotifier.isFileAdded =
                                                    false;
                                                registerNotifier
                                                        .isFileAddedAdditional =
                                                    false;
                                                registerNotifier.isFileUploadedToServer = false;
                                              }
                                            } else if (dropBox == 2) {
                                              registerNotifier.fileNonDigital2
                                                  .removeAt(position);
                                              registerNotifier
                                                  .extraprogressValue = 0.0;
                                              if (registerNotifier
                                                      .fileNonDigital2.length ==
                                                  0) {
                                                registerNotifier.isFileAdded =
                                                    false;
                                                registerNotifier
                                                        .isFileAddedAdditional =
                                                    false;
                                                registerNotifier.isFileUploadedToServer2 = false;
                                              }
                                            } else {
                                              file.removeAt(position);
                                              registerNotifier.progressValue =
                                                  0.0;
                                              if (file.length == 0) {
                                                registerNotifier.isFileAdded =
                                                    false;
                                                registerNotifier
                                                        .isFileAddedAdditional =
                                                    false;
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    buildTextDrop(
                                        text: file[position]!.name,
                                        fontColor: Colors.grey,
                                        true),
                                    const Spacer(),
                                    buildTextDrop(
                                        text: '${file[position]!.size}/5 MB',
                                        fontColor: Colors.grey,
                                        false),
                                    SizedBox(
                                        width: getScreenWidth(context) * 0.01),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () {
                                        if (dropBox == 1) {
                                          registerNotifier.fileNonDigital1
                                              .removeAt(position);
                                          registerNotifier.progressValue = 0.0;
                                          if (registerNotifier
                                                  .fileNonDigital1.length ==
                                              0) {
                                            registerNotifier.isFileAdded =
                                                false;
                                            registerNotifier.isFileLoading =
                                                false;
                                            registerNotifier.isFileUploadedToServer = false;
                                          }
                                        } else if (dropBox == 2) {
                                          registerNotifier.fileNonDigital2
                                              .removeAt(position);
                                          registerNotifier.extraprogressValue =
                                              0.0;
                                          if (registerNotifier
                                                  .fileNonDigital2.length ==
                                              0) {
                                            registerNotifier
                                                .isFileAddedAdditional = false;
                                            registerNotifier
                                                .isFileLoadingAdditional = true;
                                            registerNotifier.isFileUploadedToServer2 = false;
                                          }
                                        } else {
                                          file.removeAt(position);
                                          registerNotifier.progressValue = 0.0;
                                          if (file.length == 0) {
                                            registerNotifier.isFileAdded =
                                                false;
                                            registerNotifier.isFileLoading =
                                                false;
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                          LinearProgressIndicator(
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade400),
                            value: progressValue,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 15);
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextDrop(
                          text: 'Uploading...',
                          fontColor: Colors.blue,
                          fontSize: 16,
                          false),
                      SizedBoxHeight(context, 0.01),
                      getScreenWidth(context) < 375
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTextDrop(
                                    text: file!.name,
                                    context: context,
                                    fontColor: Colors.grey,
                                    false),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    buildTextDrop(
                                        text: '${file!.size}/5 MB',
                                        fontColor: Colors.grey,
                                        false),
                                    SizedBox(
                                        width: getScreenWidth(context) * 0.01),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: onIconClosePressUpload,
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Row(
                              children: [
                                buildTextDrop(
                                    text: file!.name,
                                    context: context,
                                    fontColor: Colors.grey,
                                    true),
                                const Spacer(),
                                buildTextDrop(
                                    text: '${file!.size}/5 MB',
                                    fontColor: Colors.grey,
                                    false),
                                SizedBox(width: getScreenWidth(context) * 0.01),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: onIconClosePressUpload,
                                ),
                              ],
                            ),
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                        value: progressValue,
                      ),
                      SizedBoxHeight(context, 0.01),
                    ],
                  ),
          )));
}

Widget finishUpload(context, file, void Function()? onIconClosePressFinish,
    isAllowMultiple, registerNotifier,
    {dropBox, onDroppedFile}) {
  return isAllowMultiple ? Column(
    children: [
      Container(
          width: getScreenWidth(context) < 450
              ? getScreenWidth(context) * 0.86
              : isTab(context) || isMobile(context)
              ? getScreenWidth(context) * 0.70
              : getScreenWidth(context) * 0.46,
          height: getScreenWidth(context) < 350 ? 130 : 100,
          color: Color(0x0f8CA9E5),
          child: DropZoneWidget(
            onDroppedFile: onDroppedFile,
            isMultiple: isAllowMultiple,
          )),
      sizedBoxHeight10(context),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          width: getScreenWidth(context) < 450
              ? getScreenWidth(context) * 0.86
              : isTab(context) || isMobile(context)
              ? getScreenWidth(context) * 0.70
              : getScreenWidth(context) * 0.46,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: file.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getScreenWidth(context) < 400 ? 1 :getScreenWidth(context) < 1000 ? 2 :getScreenWidth(context) < 1200 ? 3 :getScreenWidth(context) < 1600 ? 4 : 5,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 1 / 0.3333,
            ),
            itemBuilder: (context, position) {
              return DashedRect(
                color: hanBlueTint400,
                strokeWidth: 0.5,
                gap: 3.0,
                child: Container(
                  height: 100,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            // height: getScreenHeight(context) * 0.07,
                            // width: getScreenWidth(context) * 0.03,
                            child: file[position]!.mime == "application/pdf"
                                ? Image.asset(
                              AppImages.pdfImage,
                              height: 20,
                              width: 20,
                            )
                                : Image.network(file[position]!.url,height: 50, width: 50,fit: BoxFit.fill),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildMultiTextDrop(
                                    text: file[position]!.name,
                                    fontColor: Colors.blue,
                                    fontSize: 12,
                                    false),
                                buildTextDrop(
                                    text: file[position]!.size,
                                    fontColor: Colors.grey,
                                    fontSize: 10,
                                    false),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: GestureDetector(
                          onTap: () {
                            if (dropBox == 1) {
                              registerNotifier.fileNonDigital1.removeAt(
                                  position);
                              registerNotifier.progressValue = 0.0;
                              if (file.length == 0) {
                                registerNotifier.fileNonDigital1.clear();
                                registerNotifier.isFileAdded = false;
                                registerNotifier.isFileLoading = true;
                                registerNotifier.isFileUploadedToServer = false;
                              }
                            } else if (dropBox == 2) {
                              registerNotifier.fileNonDigital2.removeAt(
                                  position);
                              registerNotifier.extraprogressValue = 0.0;
                              if (file.length == 0) {
                                file.clear();
                                registerNotifier.isFileAddedAdditional = false;
                                registerNotifier.isFileLoadingAdditional = true;
                                registerNotifier.isFileUploadedToServer2 =
                                false;
                              }
                            } else {
                              file.removeAt(position);
                              registerNotifier.progressValue = 0.0;
                              if (file.length == 0) {
                                file.clear();
                                registerNotifier.isFileAdded = false;
                                registerNotifier.isFileLoading = true;
                                registerNotifier.isFileUploadedToServer = false;
                              }
                            }
                          },
                          child: Icon(
                            Icons.close, size: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      )
    ],
  ) : Container(
    width: getScreenWidth(context) < 450
        ? getScreenWidth(context) * 0.86
        : isTab(context) || isMobile(context)
        ? getScreenWidth(context) * 0.70
        : getScreenWidth(context) * 0.46,
    height: getScreenWidth(context) < 350 ? 130 : 100,
    color: Color(0x0f8CA9E5),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: file!.name.contains('pdf')
              ? Image.asset(
            'assets/images/pdf.png',
            width: 50,
          )
              : Image.network(file!.url),
        ),
        title: buildTextDrop(
            text: file!.name,
            fontColor: Colors.blue,
            fontSize: isMobile(context) ? 14 : 16,
            false),
        subtitle: buildTextDrop(
            text: file!.size, fontColor: Colors.grey, false),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: onIconClosePressFinish,
        ),
      ),
    ),
  );
}

buildTextDrop(bool isUpload,
    {text,
    double? fontSize = 14,
    fontWeight = FontWeight.w500,
    context,
    fontColor}) {
  return Text(
      isUpload == true
          ? text!.length > 20
              ? text.substring(0, 20) + '...'
              : text
          : isUpload == true && getScreenWidth(context) < 600
              ? text.substring(0, 20) + '...'
              : text,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: fontColor ?? Colors.black));
}


buildMultiTextDrop(bool isUpload,
    {text,
    double? fontSize = 14,
    fontWeight = FontWeight.w500,
    context,
    fontColor}) {
  return Text(
       text,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: fontColor ?? Colors.black));
}

class FilePickerMobile extends StatefulWidget {
  FilePickerMobile({Key? key, this.onTap}) : super(key: key);
  final void Function()? onTap;

  @override
  _FilePickerMobileState createState() => _FilePickerMobileState();
}

class _FilePickerMobileState extends State<FilePickerMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: DashedRect(
            color: hanBlueTint400,
            strokeWidth: 1.0,
            gap: 5.0,
            child: Stack(children: [
              GestureDetector(
                onTap: widget.onTap,
                child: Center(
                  child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: buildText(
                                  text: S.of(context).dropFilesToUpload,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontColor: const Color(0xff3F70D4))),
                          commonSizedBoxHeight5(context),
                          Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: buildText(
                                  text: S.of(context).supportedFileFormat5MB,
                                  fontWeight: FontWeight.w400,
                                  fontColor: const Color(0xffA1A5AD)))
                        ],
                      )),
                ),
              )
            ])));
  }
}

Widget buildDropFilesBoxMobile(
    {context,
    isFileAdded,
    loading,
    progressValue,
    file,
    size,
    void Function()? onTap,
    onIconClosePressUpload,
    onIconClosePressFinish,
    fileImage,
    isAllowMultiple = false,
    registerNotifier, dropbox}) {

  var width = kIsWeb
      ? getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.86
          : isTab(context) || isMobile(context)
              ? getScreenWidth(context) * 0.70
              : getScreenWidth(context) * 0.46
      : screenSizeWidth < 450
          ? screenSizeWidth * 0.86
          : isTabSDK(context) || isMobileSDK(context)
              ? screenSizeWidth * 0.70
              : screenSizeWidth * 0.46;
  return isFileAdded == false
      ? Container(
          width: width,
          height: kIsWeb ? getScreenWidth(context) < 350 ? 130 : 100 : screenSizeWidth < 350 ? 130 : 100,
          color: Color(0x0f8CA9E5),
          child: FilePickerMobile(onTap: onTap))
      : loading == true  && isAllowMultiple== false
          ? uploadScreenMobile(context, progressValue, file,
              onIconClosePressUpload, size, isAllowMultiple, registerNotifier,dropbox : dropbox)
          : finishUploadMobile(context, file, onIconClosePressFinish, size,
              fileImage, isAllowMultiple, registerNotifier,dropbox: dropbox,onTap: onTap);
}

Widget uploadScreenMobile(context, progressValue, file, onIconClosePressUpload,
    size, isAllowMultiple, registerNotifier, {dropbox}) {
  var width = kIsWeb
      ? getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.86
          : isTab(context) || isMobile(context)
              ? getScreenWidth(context) * 0.70
              : getScreenWidth(context) * 0.46
      : screenSizeWidth < 450
          ? screenSizeWidth * 0.86
          : isTabSDK(context) || isMobileSDK(context)
              ? screenSizeWidth * 0.70
              : screenSizeWidth * 0.46;
  return Container(
      color: Color(0x0f8CA9E5),
      width: width,
      height: kIsWeb ? getScreenWidth(context) < 350 ? 130 : 105 : screenSizeWidth < 350 ? 130 : 105,
      child: DashedRect(
          color: hanBlueTint400,
          strokeWidth: 1.0,
          gap: 5.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kIsWeb ? getScreenWidth(context) * 0.02 : screenSizeWidth * 0.02,
                vertical: kIsWeb ? getScreenHeight(context) * 0.01 :  screenSizeHeight * 0.01),
            child: isAllowMultiple
                ? ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: file.length,
                    itemBuilder: (context, position) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextDrop(
                              text: 'Uploading...',
                              fontColor: Colors.blue,
                              fontSize: 16,
                              false),
                          Visibility(
                              child: commonSizedBoxHeight10(context),
                              visible: kIsWeb ? getScreenWidth(context) < 375 :  screenSizeWidth < 375),
                          getScreenWidth(context) < 375
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildTextDrop(
                                        text: file[position]?.name,
                                        context: context,
                                        fontColor: Colors.grey,
                                        false),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        buildTextDrop(
                                            text: '${size[position]}/5 MB',
                                            fontColor: Colors.grey,
                                            false),
                                        SizedBox(
                                            width:
                                                getScreenWidth(context) * 0.01),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.close, size: 20),
                                          onPressed: () {
                                            if(dropbox == 1){
                                              registerNotifier.platformFileAdditional1.removeAt(position);
                                              registerNotifier.filesAdditionalMob1.removeAt(position);

                                              if (registerNotifier.platformFileAdditional1.length == 0) {
                                                registerNotifier.isFileAdded = false;
                                                registerNotifier.isFileLoading = true;
                                                registerNotifier.progressValue = 0.0;
                                                registerNotifier.isFileUploadedToServer = false;
                                              }
                                            } else if(dropbox == 2){
                                              registerNotifier.platformFileAdditional2.removeAt(position);
                                              registerNotifier.filesAdditionalMob2.removeAt(position);


                                              if (registerNotifier.platformFileAdditional2.length == 0) {
                                                registerNotifier.isFileAddedAdditional = false;
                                                registerNotifier.isFileLoadingAdditional = true;
                                                registerNotifier.extraprogressValue = 0.0;
                                                registerNotifier.isFileUploadedToServer2 = false;
                                              }
                                            }else {
                                              registerNotifier
                                                  .filesAdditionalMobAdd
                                                  .removeAt(position);
                                              registerNotifier.sizeAdditionalAdd
                                                  .removeAt(position);
                                              registerNotifier
                                                  .platformFileAdditionalAdd
                                                  .removeAt(position);

                                              if (registerNotifier
                                                  .filesAdditionalMobAdd
                                                  .length ==
                                                  0) {
                                                registerNotifier.isFileAdded =
                                                false;
                                                registerNotifier.isFileLoading = true;
                                                registerNotifier.progressValue = 0.0;
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    buildTextDrop(
                                        text: file[position]?.name,
                                        fontSize: 12,
                                        fontColor: Colors.grey,
                                        true),
                                    const Spacer(),
                                    buildTextDrop(
                                        text: '${size[position]}/5 MB',
                                        fontColor: Colors.grey,
                                        false),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () {
                                        if(dropbox == 1){
                                          registerNotifier.platformFileAdditional1.removeAt(position);
                                          registerNotifier.filesAdditionalMob1.removeAt(position);

                                          if (registerNotifier.platformFileAdditional1.length == 0) {
                                            registerNotifier.isFileAdded = false;
                                            registerNotifier.isFileLoading = true;
                                            registerNotifier.progressValue = 0.0;
                                            registerNotifier.isFileUploadedToServer = false;
                                          }
                                        } else if(dropbox == 2){
                                          registerNotifier.platformFileAdditional2.removeAt(position);
                                          registerNotifier.filesAdditionalMob2.removeAt(position);


                                          if (registerNotifier.platformFileAdditional2.length == 0) {
                                            registerNotifier.isFileAddedAdditional = false;
                                            registerNotifier.isFileLoadingAdditional = true;
                                            registerNotifier.extraprogressValue = 0.0;
                                            registerNotifier.isFileUploadedToServer2 = false;
                                          }
                                        }else {
                                          registerNotifier
                                              .filesAdditionalMobAdd
                                              .removeAt(position);
                                          registerNotifier.sizeAdditionalAdd
                                              .removeAt(position);
                                          registerNotifier
                                              .platformFileAdditionalAdd
                                              .removeAt(position);

                                          if (registerNotifier
                                              .filesAdditionalMobAdd
                                              .length ==
                                              0) {
                                            registerNotifier.isFileAdded =
                                            false;
                                            registerNotifier.isFileLoading = true;
                                            registerNotifier.progressValue = 0.0;
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                          LinearProgressIndicator(
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade400),
                            value: progressValue,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 20);
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextDrop(
                          text: 'Uploading...',
                          fontColor: Colors.blue,
                          fontSize: 16,
                          false),
                      Row(
                        children: [
                          buildTextDrop(
                              text: file?.name,
                              fontSize: 12,
                              fontColor: Colors.grey,
                              true),
                          const Spacer(),
                          buildTextDrop(
                              text: '$size/5 MB',
                              fontColor: Colors.grey,
                              false),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: onIconClosePressUpload,
                          ),
                        ],
                      ),
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                        value: progressValue,
                      ),
                    ],
                  ),
          )));
}

Widget finishUploadMobile(context, file, onIconClosePressFinish, size,
    fileImage, isAllowMultiple, RegisterNotifier registerNotifier, {dropbox, onTap}) {
  var width = kIsWeb
      ? getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.86
          : isTab(context) || isMobile(context)
              ? getScreenWidth(context) * 0.70
              : getScreenWidth(context) * 0.46
      : screenSizeWidth < 450
          ? screenSizeWidth * 0.86
          : isTabSDK(context) || isMobileSDK(context)
              ? screenSizeWidth * 0.70
              : screenSizeWidth * 0.46;
  return isAllowMultiple
      ?       Column(
        children: [

          Container(
              width: width,
              height: getScreenWidth(context) < 350 ? 110 : 90,
              color: Color(0xffF4F8FF),
              child: FilePickerMobile(onTap: onTap)),
          Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: GridView.builder(
          shrinkWrap: true,
          itemCount: file.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getScreenWidth(context) < 400 ? 1 :getScreenWidth(context) < 1000 ? 2 :getScreenWidth(context) < 1200 ? 3 :getScreenWidth(context) < 1600 ? 4 : 5,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1 / 0.3333,
          ),
          itemBuilder: (context, position) {
            return DashedRect(
              color: hanBlueTint400,
              strokeWidth: 0.5,
              gap: 3.0,
              child: Container(
                height: 100,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          // height: getScreenHeight(context) * 0.07,
                          // width: getScreenWidth(context) * 0.03,
                          child: file[position]!.name.contains('pdf')
                              ? Image.asset(
                            AppImages.pdfImage,
                            height: 20,
                            width: 20,
                          )
                              : Image.file(fileImage[position],height: 50, width: 50,fit: BoxFit.fill),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildMultiTextDrop(
                                  text: file[position]!.name,
                                  fontColor: Colors.blue,
                                  fontSize: 12,
                                  false),
                              buildTextDrop(
                                  text: size[position],
                                  fontColor: Colors.grey,
                                  fontSize: 10,
                                  false),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {
                          if(dropbox == 1){
                            registerNotifier.platformFileAdditional1.removeAt(position);
                            registerNotifier.filesAdditionalMob1.removeAt(position);
                            registerNotifier.sizeAdditional1.removeAt(position);
                            registerNotifier.progressValue = 0.0;

                            if (registerNotifier.platformFileAdditional1.length == 0) {
                              registerNotifier.isFileAdded = false;
                              registerNotifier.isFileLoading = true;
                              registerNotifier.isFileUploadedToServer = false;
                            }
                          } else if(dropbox == 2){
                            registerNotifier.platformFileAdditional2.removeAt(position);
                            registerNotifier.filesAdditionalMob2.removeAt(position);
                            registerNotifier.extraprogressValue = 0.0;
                            registerNotifier.sizeAdditional2.removeAt(position);


                            if (registerNotifier.platformFileAdditional2.length == 0) {
                              registerNotifier.isFileAddedAdditional = false;
                              registerNotifier.isFileLoadingAdditional = true;
                              registerNotifier.isFileUploadedToServer2 = false;
                            }
                          }else{
                            file.removeAt(position);
                            fileImage.removeAt(position);
                            size.removeAt(position);

                            registerNotifier.progressValue = 0.0;

                            if (file.length == 0) {file.clear();
                            registerNotifier.isFileAdded = false;
                            registerNotifier.isFileLoading = true;
                            registerNotifier.isFileUploadedToServer = false;
                            }
                          }
                        },
                        child: Icon(
                          Icons.close, size: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
    ),
  ),
        ],
      )
      : Container(
    width: width,
    height: getScreenWidth(context) < 350 ? 110 : 90,
    color: Color(0xffF4F8FF),
        child: ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: file!.name.contains('pdf')
                    ? Image.asset(
                        AppImages.pdfImage,
                        width: 50,
                      )
                    : Image.file(
                        fileImage,
                        width: 70,
                      )),
            title: buildTextDrop(
                text: file!.name, fontColor: Colors.blue, fontSize: 14, false),
            subtitle: buildTextDrop(text: size, fontColor: Colors.grey, false),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onIconClosePressFinish,
            ),
          ),
      );
}

class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;
  final child;

  DashedRect(
      {this.color = Colors.black,
      this.strokeWidth = 1.0,
      this.gap = 5.0,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(strokeWidth / 2),
        child: CustomPaint(
          child: child,
          painter:
              DashRectPainter(color: color, strokeWidth: strokeWidth, gap: gap),
        ),
      ),
    );
  }
}

class DashRectPainter extends CustomPainter {
  double strokeWidth;
  Color color;
  double gap;

  DashRectPainter(
      {this.strokeWidth = 5.0, this.color = Colors.red, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path _topPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    Path _rightPath = getDashedPath(
      a: math.Point(x, 0),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _leftPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(_topPath, dashedPaint);
    canvas.drawPath(_rightPath, dashedPaint);
    canvas.drawPath(_bottomPath, dashedPaint);
    canvas.drawPath(_leftPath, dashedPaint);
  }

  Path getDashedPath({
    required math.Point<double> a,
    required math.Point<double> b,
    required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x.toDouble(), currentPoint.y.toDouble())
          : path.moveTo(currentPoint.x.toDouble(), currentPoint.y.toDouble());
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
