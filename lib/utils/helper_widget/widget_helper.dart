import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/manage_receiver_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

import '../common/app_widgets.dart';

mixin WidgetHelper {}

List<String> emptyDataList = ['No Data Found'];
var displayData;

Widget buildButton(context,
    {name,
    double? fontSize,
    fontWeight,
    fontColor,
    color,
    double? width,
    double? height,
    void Function()? onPressed}) {
  var commonWidth = kIsWeb ? getScreenWidth(context) * 0.22 : screenSizeWidth * 0.22 ;
  return SizedBox(
    height: height ?? 40,
    width: width ?? commonWidth,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          elevation: MaterialStateProperty.all(0),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ))),
      child: buildText(
          text: name ?? '',
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w700,
          fontColor: fontColor),
      onPressed: onPressed ?? () {},
    ),
  );
}

Widget commonBackAndContinueButton(context,
    {name,
    number,
    double? widthBetween,
    void Function()? onPressedBack,
    void Function()? onPressedContinue,
    double? backWidth,
    double? continueWidth,
    double? backHeight,
    double? continueHeight,
    double? fontSize1,
    double? fontSize2,
    name2}) {
  return Row(
    children: [
      buildButton(context,
          name: name ?? S.of(context).back,
          onPressed: onPressedBack ??
              () {
                name == S.of(context).backToLogin
                    ?SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken):null;
                name == S.of(context).backToLogin
                    ? Navigator.pushNamed(
                        context, loginRoute) //Get.to(() => LoginScreenWeb())
                    : Provider.of<CommonNotifier>(context, listen: false)
                        .decrementCounter();
              },
          height: backHeight ?? 42,
          width: backWidth ?? getScreenWidth(context) * 0.22,
          fontColor: hanBlue,
          fontSize: fontSize1,
          color: hanBlueTint200),
      SizedBox(width: widthBetween ?? getScreenWidth(context) * 0.02),
      buildButton(context,
          name: name2 ?? S.of(context).continues,
          onPressed: onPressedContinue ??
              () async {

                await SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {
                  Navigator.pushNamed(context,personalDetailsRoute );

                });

              },
          width: continueWidth ?? getScreenWidth(context) * 0.22,
          height: continueHeight ?? 42,
          fontColor: white,
          fontSize: fontSize2,
          color: hanBlue),
    ],
  );
}
Widget expansionTileContainer(context,
    {bool? isSender = false,
    isReceiver,
    String? name,
    String? bankDetails,
    String? accountHolderName,
    onExpansionChanged,
    String? Country,
    String? currency,
    String? bankName,
    String? accountNumber,
       dltOnPressed,
    trailing}) {
  return Theme(
    data: ThemeData().copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      trailing: trailing,
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 10),
        buildText(text: name, fontSize: 16, fontWeight: FontWeight.w700),
        SizedBox(height: 8)
      ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(
              text: bankDetails,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontColor: Color(0xff717885)),
          SizedBox(height: 10)
        ],
      ),
      onExpansionChanged: onExpansionChanged,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Color(0xffECECEC)),
              SizedBoxHeight(context, 0.01),
              getScreenWidth(context) < 850
                  ? Column(
                      children: [
                        buildDetailRow(
                            context,
                            buildName(context,
                                name: S.of(context).accountHolderName),
                            buildDescription(description: accountHolderName)),
                        SizedBox(height: 5),
                        buildDetailRow(
                            context,
                            buildName(context, name: S.of(context).countryWeb),
                            buildDescription(description: Country)),
                        Visibility(
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                buildDetailRow(
                                    context,
                                    buildName(context,
                                        name: S.of(context).currencyWeb),
                                    buildDescription(
                                        description: currency ?? '')),
                              ],
                            ),
                            visible: isSender ?? false),
                        SizedBox(height: 5),
                        buildDetailRow(
                            context,
                            buildName(context, name: S.of(context).bank),
                            buildDescription(description: bankName)),
                        SizedBox(height: 5),
                        buildDetailRow(
                            context,
                            buildName(context,
                                name: S.of(context).accountNumberWeb),
                            buildDescription(description: accountNumber)),
                      ],
                    )
                  : isSender == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildAccountDetailsText(
                                title: buildName(context,
                                    name: S.of(context).accountHolderName),
                                subtitle: buildDescription(
                                    description: accountHolderName)),
                            buildAccountDetailsText(
                                title: buildName(context,
                                    name: S.of(context).countryWeb),
                                subtitle:
                                    buildDescription(description: Country)),
                            Visibility(
                                visible: isSender!,
                                child: buildAccountDetailsText(
                                    title: buildName(context,
                                        name: S.of(context).currencyWeb),
                                    subtitle: buildDescription(
                                        description: currency ?? ''))),
                            buildAccountDetailsText(
                                title: buildName(context,
                                    name: S.of(context).bank),
                                subtitle:
                                    buildDescription(description: bankName)),
                            SizedBox(width: getScreenWidth(context) * 0.05),
                            buildAccountDetailsText(
                                title: buildName(context,
                                    name: S.of(context).accountNumberWeb),
                                subtitle: buildDescription(
                                    description: accountNumber)),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildAccountDetailsText(
                                title: buildName(context,
                                    name: S.of(context).accountHolderName),
                                subtitle: buildDescription(
                                    description: accountHolderName)),
                            buildAccountDetailsText(
                                title: buildName(context,
                                    name: S.of(context).countryWeb),
                                subtitle:
                                    buildDescription(description: Country)),
                            buildAccountDetailsText(
                                title: buildName(context,
                                    name: S.of(context).bank),
                                subtitle:
                                    buildDescription(description: bankName)),
                            SizedBoxWidth(context, 0.05),
                            buildAccountDetailsText(
                                title: buildName(context,
                                    name: S.of(context).accountNumberWeb),
                                subtitle: buildDescription(
                                    description: accountNumber)),
                          ],
                        ),
              Visibility(
                visible: isReceiver ?? false,
                child: Column(
                  children: [
                    SizedBoxHeight(context, 0.045),
                    getScreenWidth(context) < 350
                        ? Column(
                            children: [
                              buildButton(context,
                                  name: S.of(context).sendMoneyWeb,
                                  onPressed: () async {
                                Provider.of<CommonNotifier>(context,
                                        listen: false)
                                    .updateClassNameNavigationData(
                                        "Manage receivers");
                                SharedPreferencesMobileWeb.instance.setStepperRoute('Stepper', 'Manage receivers');
                                await SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {
                                  Navigator.pushNamed(context,fundTransferSelectAccountRoute );

                                });

                              },
                                  fontColor: Color(0xff3F70D4),
                                  color: Color(0xffD9E2F6),
                                  width: isMobile(context) ? 150 : 250),
                              SizedBoxHeight(context, 0.02),
                              GestureDetector(
                                onTap: dltOnPressed,
                                child:  buildText(
                                    text: S.of(context).deleteReceiver,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    fontColor: Color(0xffFD1413)),
                              )

                            ],
                          )
                        : Row(
                            children: [
                              buildButton(context,
                                  name: S.of(context).sendMoneyWeb,
                                  onPressed: () async {

                                Provider.of<CommonNotifier>(context,
                                        listen: false)
                                    .updateClassNameNavigationData(
                                        "Manage receivers");
                                SharedPreferencesMobileWeb.instance.setStepperRoute('Stepper', 'Manage receivers');
                                await SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {
                                  Navigator.pushNamed(context,fundTransferSelectAccountRoute );

                                });

                              },
                                  fontColor: Color(0xff3F70D4),
                                  color: Color(0xffD9E2F6),
                                  width: isMobile(context) ? 150 : 250),
                              SizedBoxWidth(context, 0.02),
                              GestureDetector(
                                onTap: dltOnPressed,
                                child:buildText(
                                    text: S.of(context).deleteReceiver,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    fontColor: Color(0xffFD1413))
                              )

                            ],
                          ),
                  ],
                ),
              ),
              SizedBoxHeight(context, 0.02),
            ],
          ),
        )
      ],
    ),
  );
}

Widget buildName(context, {name}) {
  return buildText(
      text: name,
      fontWeight: FontWeight.w400,
      fontSize: getScreenWidth(context) < 850 ? 16 : 14,
      fontColor: Color(0xff717885));
}

Widget buildDescription({description}) {
  return buildText(
      text: description??"", fontWeight: FontWeight.w400, fontSize: 16);
}

Widget buildAccountDetailsText(
    {required Widget title, required Widget subtitle}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, SizedBox(height: 4), subtitle],
    ),
  );
}

Widget buildDetailRow(context, title, description) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: title,
      ),
      SizedBox(width: 10),
      Expanded(flex: 1, child: description),
    ],
  );
}

Widget  buildPagination({
  String? type,
  IconData? iconData,
  double? height,
  double? width,
  bool? isIcon,
  required void Function() buttonFunction,
  String? pageCount,
  int? selectedPageCount,
  required BuildContext context,
  EdgeInsetsGeometry? padding}) {
  Widget? pagerItem;
  bool visible = true;

 return InkWell(
   onTap: buttonFunction,
   child: Container(
      height: AppConstants.thirtyFive,
      width: AppConstants.thirtyFive,
      decoration: BoxDecoration(
          color: !isIcon!?((selectedPageCount == int.parse(pageCount.toString())))? hanBlue : white: white,
          borderRadius: radiusAll12(context),
          border: Border.all(
              color: dividercolor)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              child: isIcon?Icon(iconData,
                  size: 20,
                  color: Colors.grey):Text(
                pageCount!,
                textAlign: TextAlign.center,
                style: selectedPageCount == int.parse(pageCount)
                    ? whiteTextStyle16(context).copyWith(fontSize: pageCount.length > 2 ? 14:16)
                    : blackTextStyle16(context).copyWith(fontSize: pageCount.length > 2 ? 14:16),
              ),
            ),
          ),
        ),
    ),
 );

}

class DoubleBackToCloseApp extends StatefulWidget {
  final SnackBar snackBar;
  final Widget child;

  const DoubleBackToCloseApp({
    Key? key,
    required this.snackBar,
    required this.child,
  }) : super(key: key);

  @override
  _DoubleBackToCloseAppState createState() => _DoubleBackToCloseAppState();
}

class _DoubleBackToCloseAppState extends State<DoubleBackToCloseApp> {
  var _closedCompleter = Completer<SnackBarClosedReason>()
    ..complete(SnackBarClosedReason.remove);
  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform ==TargetPlatform.iOS ;
  bool get _isSnackBarVisible => !_closedCompleter.isCompleted;
  bool get _willHandlePopInternally =>
      ModalRoute.of(context)?.willHandlePopInternally ?? false;

  @override
  Widget build(BuildContext context) {
    assert(() {
      _ensureThatContextContainsScaffold();
      return true;
    }());

    if (_isAndroid) {
      return WillPopScope(
        onWillPop: _handleWillPop,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }


  Future<bool> _handleWillPop() async {
    if (_isSnackBarVisible) {
      logoutAlert(context);
      return true;
    } else {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.hideCurrentSnackBar();
      _closedCompleter = scaffoldMessenger
          .showSnackBar(widget.snackBar)
          .closed
          .wrapInCompleter();
      return false;
    }
  }

  void _ensureThatContextContainsScaffold() {
    if (Scaffold.maybeOf(context) == null) {
      throw FlutterError(
        '`DoubleBackToCloseApp` must be wrapped in a `Scaffold`.',
      );
    }
  }
}

extension<T> on Future<T> {
  Completer<T> wrapInCompleter() {
    final completer = Completer<T>();
    then(completer.complete).catchError(completer.completeError);
    return completer;
  }
}
Widget buildText(
    {text,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    fontColor,
    FontStyle? fontStyle,
    maxLines,
    decoration}) {
  return Text(text,
      maxLines: maxLines,
      style: TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: fontColor ?? black,
          decoration: decoration,height: height));
}
String hintData='';
Widget CustomizeDropdown(BuildContext context,{ManageReceiverNotifier? manageReceiverNotifier,FutureOr<Iterable<Object>> Function(TextEditingValue)?  optionsBuilder,String Function(Object)? displayStringForOption,hintText,displayName,optionsViewBuilder,onChanged,onSubmitted,onSelected,double? width,TextEditingController? controller, Widget Function(BuildContext, TextEditingController, FocusNode, void Function())? fieldViewBuilder,String? helperText,String? Function(String?)? validation,double? height,bool? isEnable,fillColor, displayText,focusNode,List<String>? dropdownItems,double? dropdownHeight, inputFormatters}) {
  FocusNode focusNode = FocusNode();
  String storedData = '';
  bool fieldValidation= false;
  TextEditingController widthController = TextEditingController();
  String widthData="";
  if(kIsWeb){
    hintData='';
  }
  return StatefulBuilder(
      builder: (context,setState) {
        focusNode.addListener(() {
          setState((){
            fieldValidation = focusNode.hasFocus;
          });
        });
        return Container(
            width: width ?? getScreenWidth(context) * 0.90,
            decoration: BoxDecoration(),
            child: Autocomplete(

                optionsBuilder: optionsBuilder ?? (TextEditingValue textEditingValue) {
                  if(dropdownItems!.isEmpty) {
                    return emptyDataList;
                  }
                  if(textEditingValue.text.isEmpty && dropdownItems.isNotEmpty) {
                    return dropdownItems.where((element) => element.toLowerCase().toString().contains(textEditingValue.text.toLowerCase()));
                  }
                  if(dropdownItems.where((element) => element.toLowerCase().toString().contains(textEditingValue.text.toLowerCase())).isEmpty)  {
                    return emptyDataList;
                  } else {
                    return dropdownItems.where((element) => element.toLowerCase().toString().contains(textEditingValue.text.toLowerCase()));
                  }
                },
                displayStringForOption: displayStringForOption ?? (option) => '$option',
                fieldViewBuilder: fieldViewBuilder ?? (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  fieldTextEditingController.addListener(() {
                    if(fieldTextEditingController.text == S
                        .of(context)
                        .statuswithout || fieldTextEditingController.text == "Receiver Country"){
                      setState((){
                        fieldFocusNode.unfocus();
                        focusNode.unfocus();
                      });
                    }

                  });
                 kIsWeb? widthController.addListener(() {
                    if(widthData != widthController.text){

                        if(fieldTextEditingController.text.isEmpty) {
                          if (dropdownItems!.contains(hintData)) {
                            fieldTextEditingController.text = hintData;
                          }
                        }
                        fieldFocusNode.unfocus();
                    }
                  }):null;
                  widthController.text = getScreenWidth(context).toString();
                  fieldTextEditingController.addListener(() {
                    if(dropdownItems!.contains(fieldTextEditingController.text)){

                      focusNode.unfocus();

                    }
                  });
                  return Container(
                    height: height,
                    child: Focus(
                      focusNode: focusNode,
                      onFocusChange: (hasFocus) {
                        if(!hasFocus){

                          if(dropdownItems!.contains(fieldTextEditingController.text)){
                            fieldTextEditingController.text = fieldTextEditingController.text;
                            if(manageReceiverNotifier == null)controller!.text = fieldTextEditingController.text;
                            storedData = fieldTextEditingController.text;
                            hintData = fieldTextEditingController.text;
                            if(fieldTextEditingController.text == S
                                .of(context)
                                .statuswithout || fieldTextEditingController.text == "Receiver Country"){
                              setState((){
                                fieldTextEditingController.clear();
                                controller!.clear();
                              });
                            }

                          }else{
                            fieldTextEditingController.text = storedData.isEmpty? '' : storedData;
                          }

                        }else{
                          setState((){
                            if(controller!.text.isNotEmpty){
                              storedData = controller.text;
                              hintData = controller.text;
                              fieldTextEditingController.clear();
                              controller.clear();
                            } else {
                              storedData = fieldTextEditingController.text;
                              hintData = fieldTextEditingController.text;
                              fieldTextEditingController.clear();
                              controller.clear();
                            }
                          });
                        }
                      },
                      child: TextFormField(

                        enabled: isEnable,
                        controller: controller!.text.isEmpty
                            ? fieldTextEditingController
                            : controller,
                        onEditingComplete: (){

                          List<String> dropdownItemsLowercase = dropdownItems!.map((e) => e.toLowerCase()).toList();
                          if(dropdownItemsLowercase.contains(fieldTextEditingController.text.toLowerCase())){

                            dropdownItems.forEach((element) {

                              if(element.toLowerCase() == fieldTextEditingController.text.toLowerCase()){

                                fieldTextEditingController.text = element;
                                focusNode.unfocus();
                              }
                            });
                          }else{

                            fieldTextEditingController.text = storedData.isEmpty? '' : storedData;
                            focusNode.unfocus();
                          }
                        },
                        onFieldSubmitted: onSubmitted,
                        focusNode: fieldFocusNode,
                        inputFormatters: inputFormatters ?? [],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:  fieldValidation?(value){return null;}:validation ??

                                (value) {
                              if (value == null || value.isEmpty) {
                                return fieldValidation?null:'field is required';
                              }
                              return null;
                            },

                        decoration: InputDecoration(
                          helperText: helperText,
                          contentPadding: EdgeInsets.all(12),
                          hintText: storedData.isNotEmpty ? storedData : hintText ?? S
                              .of(context)
                              .select,
                          hintStyle: hintStyle(context),
                          errorMaxLines: 4,
                          errorStyle: focusNode.hasFocus?TextStyle(height: 0.1,fontSize: 0.1,color: Colors.transparent):TextStyle(color: errorTextField,
                            fontSize: 11.5,fontWeight: FontWeight.w500),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: errorTextField),
                              borderRadius: BorderRadius.circular(5)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: errorTextField),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: hanBlueTint500),
                              borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: fieldBorderColorNew)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: fieldBorderColorNew)),
                          fillColor: fillColor ?? Colors.white,
                          filled: true,
                          hoverColor: Colors.white,
                          border: OutlineInputBorder(),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 19.0),
                            child: Image.asset('assets/images/arrow-down.png',
                              color: Color(0xff292D32), width: 10, height: 20,),
                          ),
                        ),

                        onChanged: onChanged,


                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                  );

                },
                onSelected: onSelected,
                optionsViewBuilder: optionsViewBuilder
            )
        );
      }
  );
}
class CustomRangePickerResponse{
  CustomRangePickerResponse(this.dateTime,this.dateTime2);
  DateTime? dateTime;
  DateTime? dateTime2;
}
Future<CustomRangePickerResponse> DateRangePickerWithYear(BuildContext context,DateTime? selectedFromDate,DateTime? selectedToDate) async {
  DateTime? dateTime;
  DateTime? dateTime2;
  await showDatePicker(context: context, initialDate: selectedFromDate !=null?selectedFromDate:DateTime.now(), firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime.now(),fieldLabelText: 'Select From Date',helpText: 'Select From Date').then((value) async{
    dateTime = value;
    if(value != null) {
      await showDatePicker(context: context,
          initialDate:  DateFormat('MM/dd/yyyy').format(value!)==DateFormat('MM/dd/yyyy').format(DateTime.now())?  value :selectedToDate != null ?DateFormat('MM/dd/yyyy').format(value!).compareTo(DateFormat('MM/dd/yyyy').format(selectedToDate!))<0||DateFormat('MM/dd/yyyy').format(value!).compareTo(DateFormat('MM/dd/yyyy').format(selectedToDate!))>0?value.add(Duration(days: 0)): selectedToDate : DateFormat('MM/dd/yyyy').format(value!)==DateFormat('MM/dd/yyyy').format(DateTime.now())?value:value.add(Duration(days: 0)),
          firstDate: DateFormat('MM/dd/yyyy').format(value)==DateFormat('MM/dd/yyyy').format(DateTime.now())?value:value.add(Duration(days: 0)),
          lastDate: DateTime.now(),
          fieldLabelText: 'Select To Date',helpText: 'Select To Date').then((value) {
        dateTime2 = value;
      });
    }
  });
  return CustomRangePickerResponse(dateTime,dateTime2);
}
class CommonTextField extends StatefulWidget {
  CommonTextField(
      {this.height,
      this.width,
      this.prefix,
      this.isPasswordVisible,
      this.controller,
      this.hintText,
      this.border,
      this.validator,
      this.contentPadding,
      this.hintStyle,
      this.prefixIcon,
      this.inputFormatters,
      this.suffixIcon,
      this.maxLength,
      this.onTap,
      this.maxWidth,
      this.maxHeight,
      this.autoValidateMode,
      this.enabledBorder,
      this.helperText,
      this.initialValue,
      this.style,
      this.errorStyle,
      this.readOnly,
      this.prefixIconConstraints,
      this.keyboardType,
      this.onChanged,
      this.onFieldSubmitted,
      this.validatorEmptyErrorText,
      this.validatorErrorText,
      this.minLengthErrorText,
      this.isEmailValidator,
      this.isPasswordValidator,
      this.isMobileNumberValidator,
      this.isAccountNumberValidator,
      this.isMinimumLengthText,
      this.isConsumerNumberValidator,
      this.isOTPNumberValidator,
      this.isEnable,
      this.fillColor,
      this.containerColor,
        this.focusNode,
        this.maxLines,
      Key? key})
      : super(key: key);
  double? height;
  double? width;
  int? maxLength;
  double? maxWidth;
  double? maxHeight;
  AutovalidateMode? autoValidateMode;
  Widget? prefix;
  bool? isPasswordVisible;
  TextEditingController? controller;
  String? hintText;
  InputBorder? border;
  String? Function(String?)? validator;
  EdgeInsetsGeometry? contentPadding;
  TextStyle? hintStyle;
  Widget? prefixIcon;
  List<TextInputFormatter>? inputFormatters;
  Widget? suffixIcon;
  void Function()? onTap;
  InputBorder? enabledBorder;
  String? helperText;
  String? initialValue;
  TextStyle? style;
  TextStyle? errorStyle;
  bool? readOnly;
  BoxConstraints? prefixIconConstraints;
  TextInputType? keyboardType;
  void Function(String)? onChanged;
  void Function(String)? onFieldSubmitted;
  String? validatorEmptyErrorText;
  String? validatorErrorText;
  String? minLengthErrorText;
  bool? isEmailValidator = false;
  bool? isPasswordValidator = false;
  bool? isMobileNumberValidator = false;
  bool? isAccountNumberValidator = false;
  bool? isMinimumLengthText = false;
  bool? isConsumerNumberValidator = false;
  bool? isOTPNumberValidator = false;
  bool? isEnable;
  Color? fillColor;
  Color? containerColor;
  FocusNode? focusNode;
  int? maxLines;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.containerColor ?? Colors.white,
      height: widget.height,
      width: widget.width ?? getScreenWidth(context) * 0.22,
      child: TextFormField(
          onFieldSubmitted: widget.onFieldSubmitted ?? (String){},
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          style: widget.style,
          readOnly: widget.readOnly ?? false,
          enabled: widget.isEnable,
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          maxLines: widget.maxLines ?? 1,
          autovalidateMode: widget.autoValidateMode ?? AutovalidateMode.onUserInteraction,
          validator: widget.validator ??
              (value) {
                if (value == null || value.isEmpty || value == " ") {
                  return widget.validatorEmptyErrorText;
                } else if (widget.isEmailValidator == true &&
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  return enterValidMail;
                } else if (widget.isMobileNumberValidator == true &&
                    value.length < 8) {
                  return enterValidNumber;
                } else if (widget.isConsumerNumberValidator == true &&
                    value.length <= 6) {
                  return S.of(context).enterValidConsumerNumber;
                } else if (widget.isOTPNumberValidator == true &&
                    value.length < 4) {
                  return enterValidOTP;
                } else if (widget.isAccountNumberValidator == true &&
                    value.length <= 10) {
                  return "Enter valid Account Number";
                } else if (widget.isMinimumLengthText == true &&
                    value.length <= 2) {
                  return widget.minLengthErrorText;
                }
                return null;
              },
          controller: widget.controller,
          initialValue: widget.initialValue,
          obscureText: widget.isPasswordVisible ?? false,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            errorMaxLines: 4,
              errorStyle: widget.errorStyle ?? TextStyle(color: errorTextField,
                  fontSize: 11.5,fontWeight: FontWeight.w500),
              fillColor: widget.fillColor ?? Colors.white,
              filled: true,
              hoverColor: Colors.white,
              suffixIconConstraints: BoxConstraints(

                maxHeight: widget.maxHeight ?? 17.0,
                maxWidth: widget.maxWidth ?? 55.0,
              ),
              prefixIconConstraints: widget.prefixIconConstraints,
              helperText: widget.helperText,
              counterText: '',
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ?? hintStyle(context),
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.fromLTRB(16, 12, 12, 12),
              prefix: widget.prefix,
              prefixIcon: widget.prefixIcon,
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fieldBorderColorNew),
                  borderRadius: BorderRadius.circular(5)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: errorTextField), 
                  borderRadius: BorderRadius.circular(5)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: errorTextField),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: hanBlueTint500),
                  borderRadius: BorderRadius.circular(5)),
              enabledBorder: isHover == true
                  ? OutlineInputBorder(
                      borderSide: BorderSide(color: hanBlueTint300))
                  : OutlineInputBorder(
                      borderSide: BorderSide(color: fieldBorderColorNew),
                      borderRadius: BorderRadius.circular(5)),
              border: widget.border ?? const OutlineInputBorder(),
              suffixIcon: widget.suffixIcon)),
    );
  }
}

class CommonDropDownField extends StatefulWidget {
  CommonDropDownField(
      {Key? key,
      required this.items,
      this.height,
      this.width,
      this.hintText,
      this.border,
      this.errorBorder,
      this.color,
      this.enabledBorder,
      this.prefix,
      this.hintStyle,
      this.contentPadding,
      this.onChanged,
      this.onSaved,
      this.onChangedMultiple,
      this.validator,
      this.multiValidator,
      this.boolValidation,
      this.showSearchBox,
      this.disable,
      this.selectedItem,
      this.multiSelectedItems,
      this.maxHeight,
      this.helperText,
      this.multipleSelection = false,this.containerColor})
      : super(key: key);
  List<String> items;
  double? height;
  double? width;
  String? hintText;
  InputBorder? border;
  InputBorder? errorBorder;
  Color? color;
  bool? disable;
  bool multipleSelection;
  InputBorder? enabledBorder;
  Widget? prefix;
  TextStyle? hintStyle;
  String? helperText;
  EdgeInsetsGeometry? contentPadding;
  void Function(String?)? onChanged;
  void Function(List<String>)? onChangedMultiple;
  void Function(String?)? onSaved;
  String? Function(String?)? validator;
  String? Function(List<String>?)? multiValidator;
  bool? boolValidation;
  bool? showSearchBox;
  String? selectedItem;
  List<String>? multiSelectedItems;
  double? maxHeight;
  Color? containerColor;

  @override
  State<CommonDropDownField> createState() => _CommonDropDownFieldState();
}

class _CommonDropDownFieldState extends State<CommonDropDownField> {
  bool isErrorMessage = false;
  bool isHover = false;
  List<String> listData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

      widget.items.sort();
      listData = widget.items;
      listData.sort();

    });
  }
  @override
  Widget build(BuildContext context) {
    widget.items.sort();
    listData = widget.items;
    listData.sort();

    return Theme(
        data: Theme.of(context).copyWith(
            hoverColor: Colors.transparent, splashColor: Colors.transparent),
        child: Container(
          color: widget.containerColor ??  Colors.white,

          height: widget.height,
          width: widget.width ?? getScreenWidth(context) * 0.25,
          child: widget.multipleSelection
              ? DropdownSearch<String>.multiSelection(
                  onChanged: (value) {
                    widget.onChangedMultiple!(value);

                  },
                  onSaved: (value) {

                  },
                  enabled: widget.disable == false ? false : true,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  items: listData,
                  selectedItems: widget.multiSelectedItems ?? [],

                  popupProps: PopupPropsMultiSelection.menu(scrollbarProps: ScrollbarProps(thumbVisibility: true),
                    menuProps: Theme.of(context).platform == TargetPlatform.iOS ? MenuProps(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300))) : MenuProps(),
                    showSearchBox: widget.showSearchBox ?? true,
                    constraints: BoxConstraints(maxHeight: widget.maxHeight ?? 250),
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      helperText: widget.helperText,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: widget.hintText,
                      contentPadding: widget.contentPadding ??
                          const EdgeInsets.fromLTRB(16, 0, 12, 0),
                      prefix: widget.prefix,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorTextField),
                          borderRadius: BorderRadius.circular(5)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorTextField),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: hanBlueTint500),
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: widget.enabledBorder ??
                          const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffCECFD5))),
                      labelStyle: widget.hintStyle,
                      fillColor: widget.color ?? white,
                      filled: true,
                      hoverColor: Colors.red,
                      border: widget.border ??
                          OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffCECFD5))),
                    ),
                  ),
                )
              : DropdownSearch<String>(
                  selectedItem: widget.selectedItem,
                  onChanged: widget.onChanged,
                  enabled: widget.disable == false ? false : true,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  items: listData,
                  onSaved: widget.onSaved,
                  validator: widget.validator ??
                      (value) => value == null ? 'field is required' : null,
                  popupProps: PopupProps.menu(

                    scrollbarProps: ScrollbarProps(thumbVisibility: true),
                    menuProps: Theme.of(context).platform == TargetPlatform.iOS ? MenuProps(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300))) : MenuProps(),
                    showSearchBox: widget.showSearchBox ?? true,
                    constraints:
                        BoxConstraints(maxHeight: widget.maxHeight ?? 250),
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      helperText: widget.helperText,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: widget.hintText,
                      contentPadding: widget.contentPadding ??
                          const EdgeInsets.fromLTRB(16, 12, 12, 12),
                      prefix: widget.prefix,
                      errorBorder: widget.errorBorder ?? OutlineInputBorder(
                          borderSide: BorderSide(color: errorTextField),
                          borderRadius: BorderRadius.circular(5)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: errorTextField),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: hanBlueTint500),
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: widget.enabledBorder ??
                          const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffCECFD5))),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffCECFD5))),
                      labelStyle: widget.hintStyle,
                      fillColor: widget.color ?? white,
                      filled: true,
                      hoverColor: Colors.red,
                      border: widget.border ??
                          OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffCECFD5))),
                    ),
                  ),
                ),
        ));
  }
}

androidDatePicker(context, RegisterNotifier? registerNotifier,
    TextEditingController controller,
    {ManageReceiverNotifier?  manageReceiverNotifier,DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
  var chosenDateTime = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(1950),
    lastDate: lastDate ?? DateTime(2100),
  );
  if(registerNotifier!=null)
    {
      registerNotifier.selectedDate = chosenDateTime!;
    }
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(chosenDateTime!);
      controller.text = formatted;


}

iosDatePicker(BuildContext context, RegisterNotifier? registerNotifier,
    TextEditingController controller,
    {ManageReceiverNotifier?  manageReceiverNotifier,DateTime? initialDateTime, DateTime? minimumDate, DateTime? maximumDate}) {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.25,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (value) {
              if(registerNotifier!=null)
                {
                  registerNotifier.selectedDate = value;
                }

              final DateFormat formatter = DateFormat('yyyy-MM-dd');
              final String formatted = formatter.format(value);

              controller.text = formatted;
            },
            initialDateTime: initialDateTime ?? DateTime.now(),
            minimumDate: minimumDate ?? DateTime(1945),
            maximumDate: maximumDate ?? DateTime(3000),

          ),
        );
      });
}


Widget buildDropDownContainer(BuildContext context,
    {required options,required onSelected,required List<String> dropdownData,
    constraints,
    double? dropDownHeight,
    double? dropDownWidth,
    }) {
  ScrollController scrollController = ScrollController();
  return Align(
    alignment: Alignment.topLeft,
    child: Scrollbar(
      controller: scrollController,
      thumbVisibility: options.length < 3 ? false : true,
      child: Material(
        child: Container(
          width: dropDownWidth ?? constraints.biggest.width,
          height: dropDownHeight,
          decoration: BoxDecoration(border: Border.all(color: Colors.black38),color: Colors.white70),
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(10.0),
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              var option = options.elementAt(index);
              return InkWell(
                hoverColor:  option == S.of(context).noDataFound ? Colors.transparent : Colors.grey.shade300,
                highlightColor: option == S.of(context).noDataFound ? Colors.transparent : null,
                splashColor: option == S.of(context).noDataFound ? Colors.transparent : null,
                onTap: () {
                  if(option == S.of(context).noDataFound) {

                  } else {
                    onSelected(option);
                  }

                },
                mouseCursor:  option == S.of(context).noDataFound ? SystemMouseCursors.none : SystemMouseCursors.click,
                child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: dropdownData.isEmpty ||  option == S.of(context).noDataFound
                        ? Column(
                            children: [
                              SizedBox(height: 35),
                              Text(option),
                            ])
                        : Text('${option}',style: TextStyle(fontSize: 16),)
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget someThingWentWrong(){
  return Center(
    child: SizedBox(),
  );
}
