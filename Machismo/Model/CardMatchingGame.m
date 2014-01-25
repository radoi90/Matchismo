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
@property (nonatomic, readwrite) NSInteger highscore;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) NSInteger costToChose;
@property (nonatomic, readwrite) NSInteger mismatchPenalty;
@property (nonatomic, readwrite) NSInteger matchBonus;
@property (nonatomic, readwrite, strong) NSDate *gameStartDate;
@property (nonatomic, strong) NSString *gameType;
@end

@implementation CardMatchingGame

- (void)setScore:(NSInteger)score {
    _score = score;
    if (score > self.highscore)
        self.highscore = score;
}

- (void)setHighscore:(NSInteger)highscore {
    _highscore = highscore;
    NSDate *highscoreDate = [NSDate date];
    NSTimeInterval gameDuration = [highscoreDate timeIntervalSinceDate:self.gameStartDate];
    
    NSInteger ti = (NSInteger)gameDuration;
    long seconds = ti % 60;
    long minutes = (ti / 60) % 60;
    long hours = (ti / 3600);
    
    NSDictionary *newHighscoreRecord = @{@"highscore": [NSNumber numberWithInteger: highscore],
                                         @"date":highscoreDate,
                                         @"gameDuration":[NSString stringWithFormat:@"%02li:%02li:%02li", hours, minutes, seconds],
                                         @"gameType": self.gameType};
    
    NSArray *userHighscoreData = [[NSUserDefaults standardUserDefaults] arrayForKey:@"highscores"];
    if (userHighscoreData) {
        NSDictionary *highestScoreRecord = [userHighscoreData lastObject];
        
        if (highscore > [[highestScoreRecord valueForKey:@"highscore"] integerValue]) {
            NSMutableArray *newHighscoreData = [userHighscoreData mutableCopy];
            [newHighscoreData addObject:newHighscoreRecord];
            
            [[NSUserDefaults standardUserDefaults] setObject:[newHighscoreData copy]
                                                      forKey:@"highscores"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@[newHighscoreRecord]
                                                 forKey:@"highscores"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

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
        
        self.mismatchPenalty = 2;
        self.matchBonus = 4;
        self.costToChose = 1;
        self.gameStartDate = [NSDate date];
        self.gameType = [deck type];
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

- (void)addCards:(NSArray *)objects
{
    [self.cards addObjectsFromArray:objects];
}

- (NSUInteger)cardCount
{
    return [self.cards count];
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
