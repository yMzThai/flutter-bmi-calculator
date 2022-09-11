import 'package:bmi_calculator/constants/string_constant.dart';

import '../modules/notice_module.dart';

List<NoticeModule> noticeInit(){
  return [
    NoticeModule(header: StringConstant.noticeHeader1, body: StringConstant.noticeBody1),
    NoticeModule(header: StringConstant.noticeHeader2, body: StringConstant.noticeBody2),
    NoticeModule(header: StringConstant.noticeHeader3, body: StringConstant.noticeBody3),
    NoticeModule(header: StringConstant.noticeHeader4, body: StringConstant.noticeBody4),
    NoticeModule(header: StringConstant.noticeHeader5, body: StringConstant.noticeBody5),
    NoticeModule(header: StringConstant.noticeHeader6, body: StringConstant.noticeBody6),
  ];
}