//
//  CSVReadingState.h
//  csv2plist
//
//  Created by aliueKurone on 9/17/12.
//  Copyright (c) 2012 kaku. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _CSVReadingCurrentState{
  
  CSVReadingStateNonescaped,
  CSVReadingStateEscaped, // 最初の二重引用符
  CSVReadingStateAfterCarriageReturn, // 行変更
  CSVReadingStateAfterDoubleQuote // 閉じるための二重引用符
  
} CSVReadingStateCurrent;


@interface CSVReadingState : NSObject

@property (nonatomic) CSVReadingStateCurrent currentState;



@end
