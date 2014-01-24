//
//  SetCard.h
//  Machismo
//
//  Created by Emil Culic on 22/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

+ (NSArray *)validShadings;
+ (NSUInteger)maxNumber;
+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (NSArray *)cardsFromText:(NSString *)text;
@end
