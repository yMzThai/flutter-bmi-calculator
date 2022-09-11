import 'package:bmi_calculator/constants/double_constant.dart';
import 'package:bmi_calculator/constants/string_constant.dart';
import '../modules/suggetion_module.dart';

double bmiCalculator({required double weight,required double height}){
  double centHeight = height /100;
  return weight/(centHeight*centHeight);
}


SuggetionModule? getSuggetion(bmi){
  SuggetionModule? suggetion;
  if(bmi > DoubleConstant.fat2){
    suggetion = SuggetionModule(header: StringConstant.fatHeader3, body: StringConstant.fatBody3);
  }else if (bmi >= DoubleConstant.fat1){
    suggetion = SuggetionModule(header: StringConstant.fatHeader2, body: StringConstant.fatBody2);
  }else if (bmi >= DoubleConstant.normal){
    suggetion = SuggetionModule(header: StringConstant.fatHeader1, body: StringConstant.fatBody1);
  }else if (bmi >= DoubleConstant.skinny){
    suggetion = SuggetionModule(header: StringConstant.normalHeader, body: StringConstant.normalBody);
  }else if (bmi > 0.0){
    suggetion = SuggetionModule(header: StringConstant.skinnyHeader, body: StringConstant.skinnyBody);
  }
  return suggetion;
}

String? getWeightSuggetion({required double weight,required double height}){
  double bmi = bmiCalculator(height: height,weight: weight);
  String? weightSuggetion;
  if((bmi > 0 && bmi < DoubleConstant.skinny)||bmi > DoubleConstant.normal){
    weightSuggetion = "${StringConstant.weightSuggetion} : ${getMinWeightSuggetion(height: height,weight:weight).toStringAsFixed(2)} - ${getMaxWeightSuggetion(height: height,weight:weight).toStringAsFixed(2)}";
  }
  return weightSuggetion;
}

double getMinWeightSuggetion({required double weight,required double height}){
  double minWeight = DoubleConstant.skinny * ((height/100)*(height/100));
  return minWeight;
}

double getMaxWeightSuggetion({required double weight,required double height}){
  double maxWeight = DoubleConstant.normal * ((height/100)*(height/100));
  return maxWeight;
}