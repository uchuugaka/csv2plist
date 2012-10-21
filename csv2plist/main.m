//
//  main.m
//  csv2plist
//
//  Created by kaku on 10/21/12.
//  Copyright (c) 2012 aliueKurone. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ConverterCore/ConverterDirector.h"
#import "NSObject+ConvertExtension.h"

int main(int argc, const char * argv[])
{
  
  @autoreleasepool {
    
    bool hasDataType = NO;
    
    NSString *inputFilePath = NSStringZeroLength;
    NSString *outputFilePath = NSStringZeroLength;
    
    
    if ([[[NSProcessInfo processInfo] arguments] count] > 1) {
      
      for (int i = 1; i < argc; i++) {
        NSString *arg = [[[NSProcessInfo processInfo] arguments] objectAtIndex:i];
        
        if ([arg isEqualToString:@"-i"]) {
          if (inputFilePath == NSStringZeroLength) {
            inputFilePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"i"];
          }
          i++;
        }
        else if ([arg isEqualToString:@"-o"]) {
          if (outputFilePath == NSStringZeroLength) {
            outputFilePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"o"];
          }
          i++;
        }
        else if ([arg isEqualToString:@"-datatype"]) {
          hasDataType = YES;
        }
      }
    }
    
    if (outputFilePath == NSStringZeroLength) {
      
      NSScanner *scanner = [NSScanner scannerWithString:inputFilePath];
      
      [scanner scanUpToString:@".csv" intoString:&outputFilePath];
      
      outputFilePath = [outputFilePath stringByAppendingString:@".plist"];
    }
    
    ConverterDirector *director = [[ConverterDirector alloc] init];
    [director autorelease];
    
    [director setTagetCSVFilePath:inputFilePath];
    [director setDataTypeToColumn:hasDataType];
    
    @try {
      [director construct];
    }
    @catch (NSException *exception) {
      fprintf(stderr, "Error: %s: %s", [[exception name] UTF8String], [[exception reason] UTF8String]);
    }
    
    
    printf("convert %s to %s\n", [inputFilePath UTF8String], [outputFilePath UTF8String]);
    
    NSXMLDocument *generetedXML = [director result];
    
    NSData *xmlData = [generetedXML XMLData];
    [xmlData writeToFile:outputFilePath atomically:YES];
    
  }
  return 0;
}
