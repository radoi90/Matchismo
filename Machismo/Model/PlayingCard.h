//
//  PlayingCard.h
//  Machismo
//
//  Created by Emil Culic on 15/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
