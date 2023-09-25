
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'dart:js' as js;

  openLink(String url)
  {
    html. window. open('${url}',"_self");

  }

  eyeIssue(FocusNode passwordFocusNode)
  {

      passwordFocusNode.unfocus();
      Future.microtask(() {
        passwordFocusNode.requestFocus();
        js.context.callMethod("fixPasswordCss", []);
      });

  }


// }
