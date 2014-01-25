//
//  PlayingCardGameViewController.m
//  Machismo
//
//  Created by Emil Culic on 22/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *) initialGame
{
    return [[CardMatchingGame alloc] initWithCardCount:30
                                             usingDeck:[self createDeck]];

}

- (UIView *) getViewForCard:(PlayingCard *)card
{
    PlayingCardView *cardView = [[PlayingCardView alloc] init];
    cardView.rank = card.rank;
    cardView.suit = card.suit;
    cardView.faceUp = card.isChosen || card.isMatched;
    
    return cardView;
}

@end
