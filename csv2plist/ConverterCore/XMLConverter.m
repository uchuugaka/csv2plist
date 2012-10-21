//
//  XMLConverter.m
//  csv2plist
//
//  Created by aliueKurone on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// 間違えないように
// [xmlDocument rootElement] ⇨ <plist>
// [[xmlDocument rootElement] objectAtIndex:0] ⇨ ルート辞書 or ルート配列

#import "XMLConverter.h"
#import "PlistObjectTranslator.h"

#import "NSObject+ConvertExtension.h"
#import "NSString+ConvertExtension.h"


@interface XMLConverter()

@property (nonatomic, retain) NSArray *headerKeyList;

- (void)_addNode:(NSXMLElement *)argElement toRootObjectWithStringValue:(NSString *)argValue column:(NSUInteger)column row:(NSUInteger)row;

- (BOOL)_whetherValueIsStringOfDataType:(NSString *)argDataType;
- (BOOL)_whetherNameTag:(NSString *)argNameTag correspondWithThatOfValue:(NSString *)argStringValue;
@end


@implementation XMLConverter


@synthesize dataTypeToColumn = _dataTypeToColumn;
@synthesize rootDocument = _xmlDoc;
@synthesize dataSource = _dataSource;
@synthesize dataTypesInNode = _dataTypesInNode;
@synthesize headerKeyList = _headerKeyList;


- (id)init
{
    self = [super init];
    
    if (self) {

      _dataTypeToColumn = YES;
      _translator = [[PlistObjectTranslator alloc] init];
      
    }
    
    return self;
}


- (void)dealloc
{
  [_xmlDoc release];
  [_dataTypesInNode release];
  [_headerKeyList release];
  [_translator release];
  
  [super dealloc];
}



#pragma mark - prepare For build


- (void)prepareForBuild
{
  if ([_dataSource respondsToSelector:@selector(numberOfRowsInContent:)])
    _wholeRowCount = [_dataSource numberOfRowsInContent:self];
  
  
  if ([_dataSource respondsToSelector:@selector(numberOfColumnInContent:)])
    _wholeColumnCount = [_dataSource numberOfColumnInContent:self];
  
  
  NSXMLElement *root =
  (NSXMLElement *)[NSXMLNode elementWithName:@"plist"];
  NSDictionary *attri = [NSDictionary dictionaryWithObject:@"1.0" forKey:@"version"];
  [root setAttributesWithDictionary:attri];
  _xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
  [_xmlDoc setVersion:@"1.0"];
  [_xmlDoc setCharacterEncoding:@"UTF-8"];
  
  
  NSXMLDTD *dtd = [[NSXMLDTD alloc] init];
  [dtd setName:@"plist"];
  [dtd setSystemID:@"http://www.apple.com/DTDs/PropertyList-1.0.dtd"];
  [dtd setPublicID:@"-//Apple//DTD PLIST 1.0//EN"];
  
  [_xmlDoc setDTD:dtd];
  [dtd release];
  
  // ルートオブジェクトを作る
  NSXMLElement *rootElement = [[NSXMLElement alloc] initWithName:@"array"];
  [_xmlDoc.rootElement addChild:rootElement];
  [rootElement release];
  
  
  // dataTypeInNodeがセットされてない場合，dataTypeInNodeに列数分@"string"を格納する
  if (self.dataTypesInNode == nil) {
    
    NSMutableArray *dataTypeList = [[NSMutableArray alloc] init];
    for (int i = 0; i < _wholeColumnCount; i++) {
      [dataTypeList addObject:[NSNumber numberWithInt:PlistObjectTranslatorDataTypeString]];
    }
    self.dataTypesInNode = (NSArray *)dataTypeList;
    dataTypeList = nil;
  }
}



#pragma mark - build

- (void)buildXMLTree
{
  NSXMLElement *rootObject = (NSXMLElement *)[_xmlDoc.rootElement childAtIndex:0];
  
  if ([_dataSource respondsToSelector:@selector(convertingCSV:columnIndex:rowIndex:)]) {
    @autoreleasepool {
      // ヘッダーの文字列を取り込む
      NSMutableArray *headerList = [NSMutableArray array];
      for (int columnIndex = 0; columnIndex < _wholeColumnCount; columnIndex++) {
        if (_wholeRowCount < 1) break;
        NSString *content = [_dataSource convertingCSV:self columnIndex:columnIndex rowIndex:0];
        [headerList addObject:content];
      }
      
      self.headerKeyList = (NSArray *)headerList;
      
      // csvファイルの2行目から各列の型情報を読み込むフラグがYESの場合，読み込む
      if (self.dataTypeToColumn == YES) {
        
        NSMutableArray *dataTypes = [NSMutableArray array];
        for (int columnIndex = 0; columnIndex < _wholeColumnCount; columnIndex++) {
          if (_wholeRowCount < 2) break;
          NSString *content = [_dataSource convertingCSV:self columnIndex:columnIndex rowIndex:1];
          
          // 引数チェック
          if ([self _whetherValueIsStringOfDataType:content] == NO) {
            NSLog(@"Error: value of 2 column in csv file correspond with datatype string");
            
            NSString *reason = @"value of 2 column in csv file correspond with datatype string";
            
            NSException *exception = [NSException exceptionWithName:@"no exist datatype string at 2 row" reason:reason userInfo:nil];
            [exception raise];
          }
          
          NSNumber *enumNumber = [NSNumber numberWithInteger:[_translator plistObjectTranslatorDataTypeTypeWithDataType:content]];
          [dataTypes addObject:enumNumber];
        }
        
        self.dataTypesInNode = (NSArray *)dataTypes;
      }
    }
  }
  
  int rowIndex = 0;
  if (self.dataTypeToColumn == YES) {
    rowIndex = 2;
  }
  else {
    rowIndex = 1;
  }
  
  for (; rowIndex < _wholeRowCount; rowIndex++) {
    
    // ここのnodeは必ずdict
    NSXMLElement *node = [[NSXMLElement alloc] initWithName:@"dict"];
    [rootObject addChild:node];
    
    for (register int columnIndex = 0; columnIndex < _wholeColumnCount; columnIndex++) {
      if ([_dataSource respondsToSelector:@selector(convertingCSV:columnIndex:rowIndex:)]) {
        
        NSString *content = [_dataSource convertingCSV:self columnIndex:columnIndex rowIndex:rowIndex];
        
        [self _addNode:node toRootObjectWithStringValue:content column:columnIndex row:rowIndex];
      }
    }
    [node release];
  }
  
#if DEBUG
  NSAssert([NSPropertyListSerialization propertyList:[_xmlDoc XMLData] isValidForFormat:NSPropertyListXMLFormat_v1_0] != NO, @"generated xml is not plist");
  
  NSLog(@"rootDocument %@", _xmlDoc);
  NSLog(@"childCount %lu", [rootObject childCount]);
  
  // 試しに書き出す
  NSData *data = [_xmlDoc XMLData];
  [data writeToFile:@"/Users/kaku/test.plist" atomically:YES];
#endif
}


- (void)_addNode:(NSXMLElement *)argElement toRootObjectWithStringValue:(NSString *)argValue column:(NSUInteger)column row:(NSUInteger)row
{
  @autoreleasepool {
    // dictonaryのキーを作成
    NSXMLElement *nodeKey = [[NSXMLElement alloc] initWithName:@"key" stringValue:[self.headerKeyList objectAtIndex:column]];
    [nodeKey autorelease];
    [argElement addChild:nodeKey];
    
    
    PlistObjectTranslatorDataType dataType = (PlistObjectTranslatorDataType)[[self.dataTypesInNode objectAtIndex:column] intValue];
    
    NSString *nameTag = NSStringZeroLength;
    NSString *content = [_translator plistObjectValueWithStringValue:argValue specifyDataType:dataType returnedNameTag:&nameTag];
    
    // ネームタグが値に相応しいかチェック
    if ([self _whetherNameTag:nameTag correspondWithThatOfValue:content] == NO) {
      
      NSString *nameTagString = [self nameTagWithXMLConverterDataType:[[self.dataTypesInNode objectAtIndex:column] intValue]];
      
      NSLog(@"Error: NameTag:%@ not correspond With Value:%@ at row:%lu column:%lu", nameTagString, content, row, column);
      NSString *reason = [NSString stringWithFormat:@"NameTag:%@ not correspond With Value:%@ at row:%lu column:%lu", nameTagString, content, row, column];
      
      
      NSException *exception = [NSException exceptionWithName:@"no match data type with value" reason:reason userInfo:nil];
      [exception raise];
    }
    
    NSXMLElement *node = [[NSXMLElement alloc] initWithName:nameTag stringValue:content];
    [argElement addChild:node];
    [node autorelease];
  }
}

- (NSString *)nameTagWithXMLConverterDataType:(XMLConverterDataType)arg
{
  NSString *result = NSStringZeroLength;
  
  switch (arg) {
    case XMLConverterDataTypeString:
      result = @"String";
      break;
      
    case XMLConverterDataTypeNumber:
      result = @"Number";
      break;
      
    case XMLConverterDataTypeDate:
      result = @"Date";
      break;
      
    case XMLConverterDataTypeData:
      result = @"Data";
      break;
      
    case XMLConverterDataTypeBoolean:
      result = @"Boolean";
      break;
      
  }
  
  return result;
}

#pragma mark - input value check process

// 引数がデータタイプを表す文字列かどうかチェックする。
- (BOOL)_whetherValueIsStringOfDataType:(NSString *)argDataType
{
  BOOL isDataTypeString = NO;
  
  if ([argDataType isEqualToString:@"String"]) {
    isDataTypeString = YES;
  }
  
  else if ([argDataType isEqualToString:@"Number"]) {
    isDataTypeString = YES;
  }
  else if ([argDataType isEqualToString:@"Date"]) {
    isDataTypeString = YES;
  }
  
  else if ([argDataType isEqualToString:@"Data"]) {
    isDataTypeString = YES;
  }
  else if ([argDataType isEqualToString:@"Boolean"]) {
    isDataTypeString = YES;
  }
  
  return isDataTypeString;
}

// 与えられたネームタグとcsvファイルから読み取った値が一致するかどうか
// TODO: まだ未完成
- (BOOL)_whetherNameTag:(NSString *)argNameTag correspondWithThatOfValue:(NSString *)argStringValue
{
  /*
   NSDate
   NSData
   NSNumber
   NSString
   Boolean
   */
  
  // 最後に返却値となる変数
  BOOL isMatching = NO;

  
  // nameTagの値がstringの場合
  if ([argNameTag isEqualToString:[self nameTagString]]) {
    // stringValueの値がstringに相応しいかどうか
    isMatching = YES;
  }
  // nameTagの値がrealの場合
  else if ([argNameTag isEqualToString:[self nameTagNumberWithFloat]]) {
    // stringVaueの値がrealに相応しいかどうか
    NSScanner *scanner = [NSScanner scannerWithString:argStringValue];
    
    double da = 0.0;
    if ([scanner scanDouble:&da]) isMatching = YES;
  }
  
  // nameTagの値がintegerの場合
  else if ([argNameTag isEqualToString:[self nameTagNumberWithInteger]]) {
    
    NSScanner *scanner = [NSScanner scannerWithString:argStringValue];
    
    int na = 0;
    if ([scanner scanInt:&na] && [scanner isAtEnd]) isMatching = YES;
    
  }

  // nameTagの値がdateの場合
  else if ([argNameTag isEqualToString:[self nameTagDate]]) {
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
      
      date = [formatter dateFromString:argStringValue];
      if (date != nil) {
        isMatching = YES;
        break;
      }
    }
  
  }
  // nameTagの値がdataの場合
  else if ([argNameTag isEqualToString:[self nameTagData]]) {
    // TODO: NSData形式として相応しい値かどうか調べる方法がわからない．
    isMatching = YES;
    
  }
  // nameTagの値がtrue/の場合
  else if ([argNameTag isEqualToString:[self nameTagBooleanWithTrue]]) {
    
    isMatching = YES;
      
  }
  
  // nameTagの値がfalse/の場合
  if ([argNameTag isEqualToString:[self nameTagBooleanWithFalse]]) {
    
    isMatching = YES;
    
  }

  return isMatching;
}

@end
