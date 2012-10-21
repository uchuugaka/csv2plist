//
//  NSString+ConvertExtension.m
//  csv2plist
//
//  Created by aliueKurone on 9/9/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//

#import "NSString+ConvertExtension.h"

@implementation NSString (ConvertExtension)

- (NSNumber *)numberValue
{
  return [NSNumber numberWithInteger:[self integerValue]];
}
@end
