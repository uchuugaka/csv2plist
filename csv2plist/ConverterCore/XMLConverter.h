//
//  XMLConverter.h
//  csv2plist
//
//  Created by aliueKurone on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// Numberの場合，タグは<integer>と<real>が存在する

/* --------------------------
 
  _xmlDoc.rootElement - name:plist
  [_xmlDoc.rootElement objectAtIndex:0] - name: rootArray or rootDictionary
 
 
 
 -----------------------------*/

#import <Foundation/Foundation.h>
@class PlistObjectTranslator;
@protocol XMLConverterDataSource;

typedef enum _XMLConverterDataType{
  
  XMLConverterDataTypeString,
  XMLConverterDataTypeNumber,
  XMLConverterDataTypeDate,
  XMLConverterDataTypeData,
  XMLConverterDataTypeBoolean
  
} XMLConverterDataType;

  
typedef enum _XMLConverterState{
  
  XMLConverterStateNone
  
}XMLConverterState;

@interface XMLConverter : NSObject
{
@private
  NSXMLDocument *_xmlDoc;
  
  NSUInteger _wholeRowCount;
  NSUInteger _wholeColumnCount;
  
  PlistObjectTranslator *_translator;
}

@property (nonatomic, getter = isDataTypeToColumn) BOOL dataTypeToColumn; // csvファイルの2行目から各列のデータ型情報を読み込むフラグ。YES:読み込む NO:読み込まない
@property (nonatomic, readonly) NSXMLDocument *rootDocument;
@property (nonatomic, retain) NSArray *dataTypesInNode;

@property (nonatomic, assign) id<XMLConverterDataSource> dataSource;

- (id)init;

- (void)prepareForBuild;
- (void)buildXMLTree;

@end


// csvデータを受け取るためのプロトコル
@protocol XMLConverterDataSource <NSObject>

@required
- (NSUInteger)numberOfRowsInContent:(XMLConverter *)xmlConverter;
- (NSUInteger)numberOfColumnInContent:(XMLConverter *)xmlConverter;

- (NSString *)convertingCSV:(XMLConverter *)xmlConverter columnIndex:(NSInteger)columnIndex rowIndex:(NSInteger)rowIndex;

@end
