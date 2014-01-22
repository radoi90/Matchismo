//
//  CardMatchingGame.h
//  Machismo
//
//  Created by Emil Culic on 15/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSArray *)chosenCards;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger numberOfCardsToMatch;
@end
