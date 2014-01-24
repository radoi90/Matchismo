//
//  SetCardDeck.m
//  Machismo
//
//  Created by Emil Culic on 22/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        for(NSString *color in [SetCard validColors])
            for(NSString *shape in [SetCard validShapes])
                for(NSString *shading in [SetCard validShadings])
                    for(NSUInteger number = 1; number <= [SetCard maxNumber]; number++)
                    {
                        SetCard *card = [[SetCard alloc] init];
                            
                        card.color      = color;
                        card.shape      = shape;
                        card.shading    = shading;
                        card.number     = number;
                        
                        [self addCard:card];
                    }
    }
    
    return self;

}

- (NSString *)type
{
    return @"Set card";
}

- (NSUInteger)numberOfCardsToMatch
{
    return 3;
}

@end
