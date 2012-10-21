//
//  NSObject+ConvertExtension.h
//  csv2plist
//
//  Created by aliueKurone on 8/30/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const NSStringZeroLength;


@interface NSObject (ConvertExtension)

- (NSString *)nameTagString;

- (NSString *)nameTagNumberWithInteger;
- (NSString *)nameTagNumberWithFloat;

- (NSString *)nameTagData;

- (NSString *)nameTagDate;

- (NSString *)nameTagBooleanWithTrue;
- (NSString *)nameTagBooleanWithFalse;


- (NSString *)convertToSaveFilesInFilePath;

@end
