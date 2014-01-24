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
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

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
                            self.score += matchScore * MATCH_BONUS;
                            for(Card *cardToMatch in cardsToMatch) {
                                cardToMatch.matched = YES;
                                cardToMatch.chosen = NO;
                            }
                            card.matched = YES;
                            card.chosen  = NO;
                            return;
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            for(Card *cardToMatch in cardsToMatch)
                                cardToMatch.chosen = NO;
                        }
                        break;
                    }
                }
            }
            
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
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
