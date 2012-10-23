//
//  PlistObjectTranslator.m
//  csv2plist
//
//  Created by aliueKurone on 9/9/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//

#import "PlistObjectTranslator.h"

#import "NSObject+ConvertExtension.h"
#import "NSString+ConvertExtension.h"


@implementation PlistObjectTranslator

@synthesize autoAssignDataType = _autoAssignDataType;

// 指定されたdatatypeに適うnameTagを返却する。同時に，値に相応しいdataTypeかチェックする
- (NSString *)plistObjectValueWithStringValue:(NSString *)argString specifyDataType:(PlistObjectTranslatorDataType)argDataType returnedNameTag:(NSString **)argNameTag
{
  /*
   NSDate
   NSData
   NSNumber
   NSString
   Boolean
   */
  
  NSString *plistObjectValue = NSStringZeroLength;
  *argNameTag = NSStringZeroLength;
  
  if (argDataType == PlistObjectTranslatorDataTypeString) {
    // NSStringに変換
    plistObjectValue = argString;
    *argNameTag = [self nameTagString];
  }
  else if (argDataType == PlistObjectTranslatorDataTypeNumber) {
    // NSNumberに変換
    plistObjectValue = argString;
    
    NSScanner *scanner = [NSScanner scannerWithString:argString];
    int na = 0;
    double da = 0.0;
    
    if ([scanner scanInt:&na] && [scanner isAtEnd])  *argNameTag = [self nameTagNumberWithInteger];
    else if ([scanner scanDouble:&da]) *argNameTag = [self nameTagNumberWithFloat];
    
  }
  else if (argDataType == PlistObjectTranslatorDataTypeDate) {
    // NSDateに変換
    // 2012-08-28T16:03:53Z
    NSString *dateFormatList[] = {@"yyyy/MM/dd",
                                  @"yyyy-MM-dd",
                                  @"yyyyMMdd",
                                  @"yyyy-MM-ddTHH:mm:ssZ"};
    
    NSDate *date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSLog(@"sizeof(dateFormatList) / sizeof(id) is %lu", sizeof(dateFormatList) / sizeof(id));
    
    for (int i = 0; i < sizeof(dateFormatList) / sizeof(id); i++) {
      
      [formatter setDateFormat:dateFormatList[i]];
      
      date = [formatter dateFromString:argString];
      if (date != nil) break;
    }
    
    if (date == nil) {
      [formatter setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];  // 公式のフォーマット
      plistObjectValue = [formatter stringFromDate:[NSDate date]];
    }
    
    *argNameTag = [self nameTagDate];
  }
  else if (argDataType == PlistObjectTranslatorDataTypeData) {
    // NSDataに変換
    plistObjectValue = [[argString dataUsingEncoding:NSUTF8StringEncoding] description];
    *argNameTag = [self nameTagData];
  }

  else if (argDataType == PlistObjectTranslatorDataTypeBoolean) {
    // BOOL(not object)に変換
    BOOL boolean = [argString boolValue];
    if (boolean) {
      plistObjectValue = @"YES";
      *argNameTag = [self nameTagBooleanWithTrue];
    }
    else {
      plistObjectValue = @"NO";
      *argNameTag = [self nameTagBooleanWithFalse];
    }
  }
            
  if (plistObjectValue == nil && argDataType != PlistObjectTranslatorDataTypeBoolean) {
    NSLog(@"%@ can't translate stringValue to object", NSStringFromClass([self class]));
    abort();
  }
  // これは仮プラグ。このメソッドで値とネームタグが相応しいか調べることができるかもしれない。
if (*argNameTag == NSStringZeroLength) {
    NSLog(@"no match value with nameTag");
  }
  
  return plistObjectValue;
}

#pragma mark - value datatype check

#pragma mark - 

- (PlistObjectTranslatorDataType)plistObjectTranslatorDataTypeWithDataType:(NSString *)argDataTypeString
{
  PlistObjectTranslatorDataType result;
  
  if ([argDataTypeString isEqualToString:@"String"]) {
    result = PlistObjectTranslatorDataTypeString;
  }
  
  else if ([argDataTypeString isEqualToString:@"Number"]) {
    result = PlistObjectTranslatorDataTypeNumber;
  }
  else if ([argDataTypeString isEqualToString:@"Date"]) {
    result = PlistObjectTranslatorDataTypeDate;
  }
  
  else if ([argDataTypeString isEqualToString:@"Data"]) {
    result = PlistObjectTranslatorDataTypeData;
  }
  else if ([argDataTypeString isEqualToString:@"Boolean"]) {
    result = PlistObjectTranslatorDataTypeBoolean;
  }
  
  return result;
}

@end