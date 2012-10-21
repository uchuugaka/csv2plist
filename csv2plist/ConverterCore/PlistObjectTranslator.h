//
//  PlistObjectTranslator.h
//  csv2plist
//
//  Created by aliueKurone on 9/9/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//
//
/* --------------------------------------
 ・機能
 plistにとって適切な値に変換しネームタグを用意する。
 
 -------------------------------------- */
#import <Foundation/Foundation.h>

typedef enum {

  PlistObjectTranslatorDataTypeString,
  PlistObjectTranslatorDataTypeNumber,
  PlistObjectTranslatorDataTypeDate,
  PlistObjectTranslatorDataTypeData,
  PlistObjectTranslatorDataTypeBoolean
  
} PlistObjectTranslatorDataType;


@interface PlistObjectTranslator : NSObject

@property(nonatomic, getter = isAutoAssignDatatype) BOOL autoAssignDataType;

// 引数として与えられた値をplistに相応しい値に変換する。ついでにnameTagも返却する
- (NSString *)plistObjectValueWithStringValue:(NSString *)argString specifyDataType:(PlistObjectTranslatorDataType)argDataType returnedNameTag:(NSString **)argNameTag;


- (PlistObjectTranslatorDataType)plistObjectTranslatorDataTypeTypeWithDataType:(NSString *)argDataTypeString; // データタイプ⇨データタイプEnumに変換
@end
