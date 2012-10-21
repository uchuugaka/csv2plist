//
//  CSVParser.h
//  csv2plist
//
//  Created by aliueKurone on 12/05/11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CSVReadingState;

extern NSString * const CSVContentInfoRowCountKey;  // 行数
extern NSString * const CSVContentInfoColumnCountKey; // 列数


@interface CSVParser : NSObject
{
@private
  NSMutableDictionary *_fileInfo;
  
  CSVReadingState *_csvReadingState;
}

/*--- CSVContentInfoRowCountKey:行数が格納されたキ
      CSVContentInfoColumnCountKey:列数の格納されたキー ---*/
@property (nonatomic, retain, readonly) NSDictionary *fileInfo;


// desinged initializer
- (id)init;

- (void)parseFileDataWithFilePath:(NSString *)path;

// query
- (NSString *)stringWithColumn:(NSInteger)columnIndex row:(NSInteger)rowIndex;
@end


