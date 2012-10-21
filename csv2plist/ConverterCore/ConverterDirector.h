//
//  ConverterDirector.h
//  csv2plist
//
//  Created by aliueKurone on 9/2/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//

// 2012/09/08
//
/* --------------------------------------

 ・使い方
 ConverterDirector *director = [[ConverterDirector alloc] init]
 変換したいcsvファイルを指定する。
 NSString *filePath = @"/Users/<homename>/Desktop/sample.csv"
 [director setTargetCSVFilePath:filePath]
 
 csvからplistに変換する
 [director construct];
 
 変換したplistのオブジェクトを取り出す
 NSXMLDocument *plistObject = [director result];
 
 -------------------------------------- */

#import <Foundation/Foundation.h>
#import "XMLConverter.h"
@class CSVParser;


@interface ConverterDirector : NSObject <XMLConverterDataSource>

// designed initializer
- (id)init;

- (void)setTagetCSVFilePath:(NSString *)argFilePath;

- (void)setDataTypeToColumn:(BOOL)argBOOL;  // option
- (void)setDataTypeInNode:(NSArray *)argDataTypeList; // option

- (void)construct;
- (NSXMLDocument *)result;



@end
