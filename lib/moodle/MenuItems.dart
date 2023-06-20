import 'package:flutter/material.dart';
import 'MenuItem.dart';

class MenuItems {
  static const List<MyMenuItem> items = [
    itemSync,
    itemImport,
    itemExport,
    // itemDeletData,
    // itemDeletAll,
    // itemUplode,
    itemLogout,
    itemWhatsapp,
    // itemContactUs
  ];

  static const itemSync = MyMenuItem(text: "مزامنة", icon: Icons.sync_outlined);
  static const itemImport = MyMenuItem(text: "ادراج ملف اكسل", icon: Icons.download);

  static const itemExport = MyMenuItem(text: "تصدير", icon: Icons.file_upload);
  static const itemLogout = MyMenuItem(text: "تسجيل خروج", icon: Icons.logout);
  // static const itemContactUs = MyMenuItem(text: "الأبلاغ عن مشكلة", icon: Icons.bug_report,);

  // static const itemDeletData =
  //     MyMenuItem(text: "Delete All Data ", icon: Icons.delete);

  // static const itemDeletAll =
  //     MyMenuItem(text: "Delete DataBase", icon: Icons.delete_forever);

  // static const itemUplode =
  //     MyMenuItem(text: "Upload Data", icon: Icons.upload_file_outlined);
  static const itemWhatsapp =
      MyMenuItem(text: "ارسال النجاز عبر واتساب", icon: Icons.message_outlined);
}
