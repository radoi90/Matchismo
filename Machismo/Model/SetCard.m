//
//  SetCard.m
//  Machismo
//
//  Created by Emil Culic on 22/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "SetCard.h"


@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    if ([otherCards count] == [SetCard maxNumber] -1) {
        
    }
    
    return 0;
}

+ (NSArray *)validShadings{
    return @[@"solid", @"outlined", @"striped"];
}

+ (NSUInteger)maxNumber {
    return 3;
}
@end
