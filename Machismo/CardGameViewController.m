//
//  CardGameViewController.m
//  Machismo
//
//  Created by Emil Culic on 14/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutlet UINavigationItem *scoreTitle;
@property (strong, nonatomic) NSMutableArray *actionHistory; // of NSAttributedString
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
    
    if (isCardBeingUnchose) {
        [chosenCardsString setString:@""];
        for (Card *card in currentChosenCards)
            [chosenCardsString appendString:card.contents];
        actionDescription = [[NSAttributedString alloc] initWithString:chosenCardsString];
    } else {
        // MATCH: increment in score, display which cards were matched.
        if (scoreDiff > 0)
        {
            actionDescription = [[NSAttributedString alloc] initWithString:
            [NSString stringWithFormat:@"Matched %@ for %ld points.", chosenCardsString, (long)scoreDiff]];
        }
        // MISMATCH or CHOSE/UNCHOSE CARD
        else {
            //CHOSE/UNCHOSE CARD
            if ([currentChosenCards count] > [oldChosenCards count]) {
                [chosenCardsString setString:@""];
                for (Card *card in currentChosenCards)
                    [chosenCardsString appendString:card.contents];
                actionDescription = [[NSAttributedString alloc] initWithString: chosenCardsString];
            }
            // MISMATCH: display which cards were mismatched
            else
            {
                actionDescription = [[NSAttributedString alloc] initWithString:
                [NSString stringWithFormat:@"%@ don't match! %ld point penalty!", chosenCardsString, (long)-scoreDiff]];
            }
        }
    }
    
    [self updateUI];
    [self.actionHistory addObject:actionDescription];
}



- (IBAction)touchRedealButton {
    self.game = nil;
    [self updateUI];
    self.resultLabel.text = @"";
    self.labelHistorySlider.maximumValue = 0;
    self.labelHistorySlider.value = 0;
    self.labelHistory = nil;
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

@end
