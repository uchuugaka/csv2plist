//
//  CSVReadingState.m
//  csv2plist
//
//  Created by aliueKurone on 9/17/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//

#import "CSVReadingState.h"



@implementation CSVReadingState

@synthesize currentState = _currentState;

- (id)init
{
  self = [super init];
  
  if (self) {
    _currentState = CSVReadingStateNonescaped;
  }
  
  return self;
}

@end
