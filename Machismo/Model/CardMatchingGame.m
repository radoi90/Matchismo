//
//  CardMatchingGame.m
//  Machismo
//
//  Created by Emil Culic on 15/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) NSInteger costToChose;
@property (nonatomic, readwrite) NSInteger mismatchPenalty;
@property (nonatomic, readwrite) NSInteger matchBonus;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated initializer
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            self.numberOfCardsToMatch = deck.numberOfCardsToMatch;
        }
    }
    
    self.mismatchPenalty = 2;
    self.matchBonus = 4;
    self.costToChose = 1;
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    
     if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init];
            
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [cardsToMatch addObject:otherCard];
                    
                    if ([cardsToMatch count] + 1 == self.numberOfCardsToMatch) {
                        int matchScore = [card match:cardsToMatch];
                        if (matchScore) {
                            self.score += matchScore * self.matchBonus;
                            for(Card *cardToMatch in cardsToMatch) {
                                cardToMatch.matched = YES;
                                cardToMatch.chosen = NO;
                            }
                            card.matched = YES;
                            card.chosen  = NO;
                            return;
                        } else {
                            self.score -= self.mismatchPenalty;
                            for(Card *cardToMatch in cardsToMatch)
                                cardToMatch.chosen = NO;
                        }
                        break;
                    }
                }
            }
            
            card.chosen = YES;
            self.score -= self.costToChose;
        }
    }
}

- (NSArray *)chosenCards
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (Card *card in self.cards)
        if (card.isChosen && !card.isMatched) [temp addObject:card];
    
    return [temp copy];
}

@end
