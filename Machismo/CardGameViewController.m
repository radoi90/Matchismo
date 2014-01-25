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
#import "Grid.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *cardDeckView;
@property (strong, nonatomic) IBOutlet UINavigationItem *scoreTitle;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) Grid *cardViewGrid;
@end

@implementation CardGameViewController

- (NSMutableArray *)actionHistory {
    if (!_actionHistory) _actionHistory = [[NSMutableArray alloc] init];
    return _actionHistory;
}

- (Grid *) cardViewGrid
{
    if (!_cardViewGrid) _cardViewGrid = [[Grid alloc] init];
    
    _cardViewGrid.size                  = self.cardDeckView.frame.size;
    _cardViewGrid.cellAspectRatio       = 0.63;
    _cardViewGrid.minimumNumberOfCells  = [self.game cardCount];
    
    return _cardViewGrid;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (NSMutableArray *) cardViews
{
    if (!_cardViews)
    {
        _cardViews = [[NSMutableArray alloc] init];
    
        for (NSUInteger cardIndex = 0; cardIndex < [self.game cardCount]; cardIndex++)
        {
            Card *card = [self.game cardAtIndex:cardIndex];
        
            [_cardViews addObject:[self getViewForCard:card]];
        }
    }
    
    return _cardViews;
    
}

- (UIView *)getViewForCard:(Card *)card // abstract
{
    return nil;
}

- (CardMatchingGame *) initialGame // abstract
{
    return nil;
}

- (CardMatchingGame *) game
{
    if (!_game) _game = [self initialGame];
    
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}

- (IBAction)tapCardDeckView:(UITapGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateEnded) return;
    
    CGPoint tapPoint = [sender locationInView:self.cardDeckView];
    UIView *hitView = [self.cardDeckView hitTest:tapPoint withEvent:NULL];
    
    if ([hitView superview] != self.cardDeckView) return;
 
    NSInteger chosenViewIndex = [self.cardViews indexOfObject:hitView];
    Card *chosenCard = [self.game cardAtIndex:chosenViewIndex];
    
    NSInteger oldScore = self.game.score;
    NSArray *oldChosenCards = self.game.chosenCards;
    NSMutableString *chosenCardsString = [[NSMutableString alloc] init];
    for (Card *card in oldChosenCards)
        [chosenCardsString appendString:card.contents];
    
    BOOL isCardBeingUnchose = chosenCard.isChosen;
    [chosenCardsString appendString:chosenCard.contents];
    
    [self.game chooseCardAtIndex:chosenViewIndex];
    hitView = self getViewForCard:chosenCard
    
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
    if (![self.cardViewGrid inputsAreValid]) return;
    NSLog(@"%d\t%d", [self.cardViewGrid rowCount], [self.cardViewGrid columnCount]);
    
    for (NSUInteger cardViewIndex = 0; cardViewIndex < [self.cardViews count]; cardViewIndex++) {
        UIView *cardView = [self.cardViews objectAtIndex:cardViewIndex];
        
        NSUInteger gridRow = cardViewIndex / [self.cardViewGrid columnCount];
        NSUInteger gridColumn = cardViewIndex % [self.cardViewGrid columnCount];
        
        [cardView setFrame:[self.cardViewGrid frameOfCellAtRow:gridRow inColumn:gridColumn]];
        [self.cardDeckView addSubview:cardView];
    }
    
    self.scoreTitle.title = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

@end
