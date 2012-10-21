//
//  CSVParser.m
//  csv2plist
//
//  Created by aliueKurone on 12/05/11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSVParser.h"

#import "CSVReadingState.h"


NSString * const CSVContentInfoColumnCountKey = @"columnCount";
NSString * const CSVContentInfoRowCountKey = @"rowCount";


// Private Method
@interface CSVParser()

@property (nonatomic, retain) NSArray *contentLines;

- (NSString *)pv_loadCSVFileOfPath:(NSString *)argPath;

- (NSArray *)pv_componentsSeparatedByThelineWithString:(NSString *)argString;
- (void)pv_countColumnPerLine:(NSString *)aLine;
@end


@implementation CSVParser


@synthesize fileInfo = _fileInfo;
@synthesize contentLines = _contentLines;


#pragma mark - initialize process


// 指定イニシャライザ
- (id)init
{
    self = [super init];
    
    if (self) {
      _fileInfo = [[NSMutableDictionary alloc] init];
      _csvReadingState = [[CSVReadingState alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
  [_fileInfo release];
  [_contentLines release];
  [_csvReadingState release];
  
  [super dealloc];
}


#pragma mark - parse csv source


- (void)parseFileDataWithFilePath:(NSString *)path
{
  if (path == @"") {
    NSLog(@"filePath is zero length");
    return;
  }
  if (path == nil) {
    NSLog(@"filePath is nil");
    return;
  }
  
  @autoreleasepool {
    NSString *resource = [self pv_loadCSVFileOfPath:path];
#if DEBUG
    NSLog(@"body %@", resource);
#endif
    
    _contentLines = [self pv_componentsSeparatedByThelineWithString:resource];
    [_contentLines retain];
  }
}

// Private Method
- (NSString *)pv_loadCSVFileOfPath:(NSString *)argPath
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSData *contentData = [fileManager contentsAtPath:argPath];
  
  NSString *result = [[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding];
  
#if DEBUG
  NSLog(@"result %@", result);
#endif

  return result;
}


// Private Method
- (NSArray *)pv_componentsSeparatedByThelineWithString:(NSString *)argString
{
  NSArray *result = [argString componentsSeparatedByString:@"\n"];
  
  /*--- ここでfileInfo に行数の情報が挿入される ---*/
  [_fileInfo setObject:[NSNumber numberWithUnsignedLong:[result count]] forKey:CSVContentInfoRowCountKey];
  
  [self pv_countColumnPerLine:[result objectAtIndex:0]];
  
//  NSLog(@"rows %lu", [result count]);
  
  return result;
}


- (void)pv_countColumnPerLine:(NSString *)aLine
{
  NSArray *array = [aLine componentsSeparatedByString:@","];
  
  
  /*--- ここでfileInfo に列数の情報が挿入される ---*/
  [_fileInfo setObject:[NSNumber numberWithUnsignedLong:[array count]] forKey:CSVContentInfoColumnCountKey];
//  NSLog(@"column %lu", [array count]);
  
}




#pragma mark - Private method


- (NSString *)stringWithColumn:(NSInteger)columnIndex row:(NSInteger)rowIndex
{
#if DEBUG
  NSLog(@"csvfile column %lu, row %lu",[ [self.fileInfo objectForKey:CSVContentInfoColumnCountKey] integerValue], [[self.fileInfo objectForKey:CSVContentInfoRowCountKey] integerValue]);
#endif
  
  if (columnIndex > [[self.fileInfo objectForKey:CSVContentInfoColumnCountKey] integerValue] || rowIndex > [[self.fileInfo objectForKey:CSVContentInfoRowCountKey] integerValue]) {
    
    NSLog(@"%@ is stopped", NSStringFromSelector(_cmd));
    return nil;
  }
  
#if DEBUG
  NSLog(@"in %@ class, %@ method raised", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
  NSLog(@"columnIndex %lu, rowIndex %lu, sentence ", columnIndex, rowIndex);
#endif
  
    NSString *aLine = [_contentLines objectAtIndex:rowIndex];
    
    NSArray *aColumnPerLine = [aLine componentsSeparatedByString:@","];
    
    return [aColumnPerLine objectAtIndex:columnIndex];
}






@end
