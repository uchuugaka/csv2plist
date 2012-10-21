//
//  NSObject+ConvertExtension.m
//  csv2plist
//
//  Created by aliueKurone on 8/30/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//

#import "NSObject+ConvertExtension.h"


NSString * const NSStringZeroLength = @"";


@implementation NSObject (ConvertExtension)

- (NSString*)defaultStringValue:(NSString*)key
{
	NSString *string = @"";
  
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
	// string value
	if([defaults objectForKey:key]){
		string = [defaults objectForKey:key];
	}
  
	return string;
}


#pragma mark - name tag collection in plist

- (NSString *)nameTagString
{
  return [self defaultStringValue:@"optNameTagString"];
}

- (NSString *)nameTagNumberWithInteger
{
  return [self defaultStringValue:@"optNameTagNumberInteger"];
}

- (NSString *)nameTagNumberWithFloat
{
  return [self defaultStringValue:@"optNameTagNumberReal"];
}

- (NSString *)nameTagData
{
  return [self defaultStringValue:@"optNameTagData"];
}

- (NSString *)nameTagDate
{
  return [self defaultStringValue:@"optNameTagDate"];
}

- (NSString *)nameTagBooleanWithTrue
{
  return [self defaultStringValue:@"optNameTagBooleanTrue"];
}

- (NSString *)nameTagBooleanWithFalse
{
  return [self defaultStringValue:@"optNameTagBooleanFalse"];
}

#pragma mark - file path

- (NSString *)convertToSaveFilesInFilePath
{
  return [self defaultStringValue:@"optSaveFilesInFilePath"];
}

@end
