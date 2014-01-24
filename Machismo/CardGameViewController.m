//
//  CardGameViewController.m
//  Machismo
//
//  Created by Emil Culic on 14/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameHistoryViewController.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutlet UINavigationItem *scoreTitle;
@end

@implementation CardGameViewController

- (NSMutableArray *)actionHistory {
    if (!_actionHistory) _actionHistory = [[NSMutableArray alloc] init];
    return _actionHistory;
}

- (CardMatchingGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSInteger oldScore = self.game.score;
    NSArray *oldChosenCards = self.game.chosenCards;
    NSMutableString *chosenCardsString = [[NSMutableString alloc] init];
    for (Card *card in oldChosenCards)
        [chosenCardsString appendString:card.contents];
    
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    Card *chosenCard = [self.game cardAtIndex:chosenButtonIndex];
    BOOL isCardBeingUnchose = chosenCard.isChosen;
    [chosenCardsString appendString:chosenCard.contents];
    
    [self.game chooseCardAtIndex:chosenButtonIndex];
    
    NSArray *currentChosenCards = self.game.chosenCards;
    NSInteger scoreDiff = self.game.score - oldScore;
    NSAttributedString *actionDescription;
    
    if (!isCardBeingUnchose) {
        // MATCH: increment in score, display which cards were matched.
        if (scoreDiff > 0)
        {
            actionDescription = [[NSAttributedString alloc] initWithString:
            [NSString stringWithFormat:@"Matched %@ for %ld points.", chosenCardsString, (long)scoreDiff]];
        }
        // MISMATCH
        else if ([currentChosenCards count] <= [oldChosenCards count]) {
            actionDescription = [[NSAttributedString alloc] initWithString:
            [NSString stringWithFormat:@"%@ don't match! %ld point penalty!", chosenCardsString, (long)-scoreDiff-self.game.costToChose]];
        }
    }
    
    if (actionDescription) {
        [self.actionHistory addObject:actionDescription];
    }
    
    [self updateUI];
}



- (IBAction)touchRedealButton {
    self.game = nil;
    self.actionHistory = nil;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    self.scoreTitle.title = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    return [[NSAttributedString alloc] initWithString:(card.isChosen || card.isMatched) ? card.contents : @""];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen || card.isMatched) ? @"cardfront" : @"cardback"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show history"]) {
        if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
            GameHistoryViewController *ghvc = (GameHistoryViewController *)segue.destinationViewController;
            NSMutableAttributedString *history = [[NSMutableAttributedString alloc] init];
            
            for(NSAttributedString *actionDescription in self.actionHistory)
            {
                [history appendAttributedString:actionDescription];
                [history appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
            ghvc.historyToDisplay = [history copy];
        }
    }
}

@end
