//
//  ConverterDirector.m
//  csv2plist
//
//  Created by aliueKurone on 9/2/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//

#import "ConverterDirector.h"
#import "CSVParser.h"


@implementation ConverterDirector
{
  CSVParser *_parser;
  XMLConverter *_converter;
    
  NSString *_targetFilePath;
  
  NSArray *_dataTypeInNode;
  
}

- (id)init
{
  self = [super init];
  
  if (self) {
    _parser = [[CSVParser alloc] init];
    _converter = [[XMLConverter alloc] init];
    _converter.dataSource = self;
  }
  
  return self;
}


- (void)dealloc
{
  [_parser release];
  [_converter release];
  [_dataTypeInNode release];
  
  [super dealloc];
}



- (void)setTagetCSVFilePath:(NSString *)argFilePath
{
  _targetFilePath = argFilePath;
}

- (void)setDataTypeToColumn:(BOOL)argBOOL
{
  _converter.dataTypeToColumn = argBOOL;
}


- (void)setDataTypeInNode:(NSArray *)argDataTypeList
{
  _dataTypeInNode = argDataTypeList;
  [_dataTypeInNode retain];
}

#pragma mark - construct

- (void)construct
{
  [_parser parseFileDataWithFilePath:_targetFilePath];
  [_converter setDataTypesInNode:_dataTypeInNode];
  [_converter prepareForBuild];
  
  [_converter buildXMLTree];
}


- (NSXMLDocument *)result
{
  return _converter.rootDocument;
}


#pragma mark - XMLConverter Delegate


- (NSUInteger)numberOfRowsInContent:(XMLConverter *)xmlConverter
{
  return [[_parser.fileInfo objectForKey:CSVContentInfoRowCountKey] integerValue];
}


- (NSUInteger)numberOfColumnInContent:(XMLConverter *)xmlConverter
{
  return [[_parser.fileInfo objectForKey:CSVContentInfoColumnCountKey] integerValue];
}


- (NSString *)convertingCSV:(XMLConverter *)xmlConverter columnIndex:(NSInteger)columnIndex rowIndex:(NSInteger)rowIndex
{
  return [_parser stringWithColumn:columnIndex row:rowIndex];
}


#pragma mark - setup


+ (void)initialize
{
  [self setupDefaults];
}

+ (void)setupDefaults
{
  NSDictionary *defaults = @{ @"optNameTagString":@"string",
  @"optNameTagNumberInteger":@"integer",
  @"optNameTagNumberReal":@"real",
  @"optNameTagData":@"data",
  @"optNameTagDate":@"date",
  @"optNameTagBooleanTrue":@"true/",
  @"optNameTagBooleanFalse":@"false/",
  @"optSaveFilesInFilePath":@"/Users/kaku/Desktop"};
  
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}


@end
