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
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchingModeControl;
@property (weak, nonatomic) IBOutlet UISlider *labelHistorySlider;
@property (strong, nonatomic) NSMutableArray *labelHistory; // of NSString
@end

@implementation CardGameViewController

- (NSMutableArray *)labelHistory {
    if (!_labelHistory) _labelHistory = [[NSMutableArray alloc] init];
    return _labelHistory;
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
    
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    
    if ([self.game cardAtIndex:chosenButtonIndex].isChosen) {
        NSInteger scoreDiff = self.game.score - oldScore + 1;
        [self updateResultLabelForScore:scoreDiff
                            chosenCards:oldChosenCards
                                   card:[self.game cardAtIndex:chosenButtonIndex]];
    } else {
        self.resultLabel.text = [self.resultLabel.text
         stringByReplacingOccurrencesOfString:[self.game cardAtIndex:chosenButtonIndex].contents
                                 withString:@""];
    }
    
    [self.labelHistory addObject:self.resultLabel.text];
    self.labelHistorySlider.maximumValue = [self.labelHistory count] - 1;
    [self moveSliderToValue:self.labelHistorySlider.maximumValue];
    
    if ([self.matchingModeControl isEnabled]) self.matchingModeControl.enabled = NO;
}

- (void)moveSliderToValue:(float)value {
    if ([self.labelHistory count]) {
        self.resultLabel.text = [self.labelHistory objectAtIndex:value];
        self.resultLabel.alpha = (value < self.labelHistorySlider.maximumValue) ? 0.3 : 1;
        self.labelHistorySlider.value = value;
    }
}

- (IBAction)slideLabelHistory:(UISlider *)sender {
    [self moveSliderToValue:sender.value];
}

- (IBAction)touchRedealButton {
    self.game = nil;
    [self updateUI];
    self.resultLabel.text = @"";
    self.matchingModeControl.enabled = YES;
    self.labelHistorySlider.maximumValue = 0;
    self.labelHistorySlider.value = 0;
    self.labelHistory = nil;
}

- (IBAction)touchMatchigModeControl:(UISegmentedControl *)sender {
    self.game.numberOfCardsToMatch = sender.selectedSegmentIndex + 2;
}

- (void)updateResultLabelForScore:(NSInteger)score
                      chosenCards:(NSArray *)chosenCards
                             card:(Card *) card
{
    NSMutableString *selectedCardsString = [[NSMutableString alloc] init];
    for (Card *card in chosenCards)
        [selectedCardsString appendString:card.contents];
    [selectedCardsString appendString:card.contents];
    
    if (score == 0) {
        NSMutableString *currSelectionString = [[NSMutableString alloc] init];
        for (Card *card in self.game.chosenCards)
            [currSelectionString appendString:card.contents];
        self.resultLabel.text = currSelectionString;
    }
    else if (score < 0) {
        self.resultLabel.text =
        [NSString stringWithFormat:@"%@ don't match! %ld point penalty!",
         selectedCardsString, (long)-score];
    }
    else if (score > 0) {
        self.resultLabel.text =
        [NSString stringWithFormat:@"Matched %@ for %ld points.", selectedCardsString, (long)score];
    }
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    self.matchingModeControl.selectedSegmentIndex = self.game.numberOfCardsToMatch - 2;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
