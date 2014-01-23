//
//  SetCard.m
//  Machismo
//
//  Created by Emil Culic on 22/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "SetCard.h"


@implementation SetCard

@synthesize matched = _matched;

- (void)setMatched:(BOOL)matched {
    _matched = NO;
}

// 3 set cards match when, for each attribute, they are all equal
// or all have different values (pair-wise distinct)
- (int)match:(NSArray *)otherCards
{
    if ([otherCards count] != [SetCard maxNumber] -1) return 0;
    
    SetCard *otherCard0 = otherCards[0];
    SetCard *otherCard1 = otherCards[1];
    
    if (!(([self.color isEqualToString:otherCard0.color] && [self.color isEqualToString:otherCard1.color]) ||
          (![self.color isEqualToString:otherCard0.color] && ![otherCard0.color isEqualToString:otherCard1.color]
           && ![otherCard1.color isEqualToString:self.color]))) {
        return 0;
          }
    
    if (!(([self.shape isEqualToString:otherCard0.shape] && [self.shape isEqualToString:otherCard1.shape]) ||
          (![self.shape isEqualToString:otherCard0.shape] && ![otherCard0.shape isEqualToString:otherCard1.shape]
           && ![otherCard1.shape isEqualToString:self.shape]))) {
              return 0;
          }
    
    if (!(([self.shading isEqualToString:otherCard0.shading] && [self.shading isEqualToString:otherCard1.shading]) ||
          (![self.shading isEqualToString:otherCard0.shading] && ![otherCard0.shading isEqualToString:otherCard1.shading]
           && ![otherCard1.shading isEqualToString:self.shading]))) {
              return 0;
          }
    
    if (!((self.number == otherCard0.number && self.number == otherCard1.number) ||
         (self.number != otherCard0.number && otherCard0.number != otherCard1.number && otherCard1.number != self.number))) {
        return 0;
    }
    
    return 1;
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading])
    {
        _shading = shading;
    }
}

+ (NSArray *)validShadings{
    return @[@"solid", @"outlined", @"striped"];
}

+ (NSUInteger)maxNumber {
    return 3;
}
@end
