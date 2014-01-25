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
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) Grid *cardViewGrid;
@end

@implementation CardGameViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object: nil];
    [self updateUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)orientationChanged:(id)sender
{
    self.cardViewGrid = nil;
    [self updateUI];
}

- (NSMutableArray *) cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    
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
    [self.game chooseCardAtIndex:chosenViewIndex];
    
    [self updateUI];
}



- (IBAction)touchRedealButton {
    self.game = nil;
    [self updateUI];
}

- (void)updateUI
{
    if (![self.cardViewGrid inputsAreValid]) return;
    
    for (UIView *subview in self.cardViews)
        [subview removeFromSuperview];
    [self.cardViews removeAllObjects];
    
    for (NSUInteger cardIndex = 0; cardIndex < [self.game cardCount]; cardIndex++) {
        Card *card = [self.game cardAtIndex:cardIndex];
        
        UIView *cardView = [self getViewForCard:card];
        [self.cardViews addObject:cardView];

        NSUInteger gridRow = cardIndex / [self.cardViewGrid columnCount];
        NSUInteger gridColumn = cardIndex % [self.cardViewGrid columnCount];
        
        [cardView setFrame:[self.cardViewGrid frameOfCellAtRow:gridRow inColumn:gridColumn]];
        
        if (card.isMatched) [cardView setBackgroundColor:[UIColor grayColor]];
        
        if (card.isMatched)
            [cardView setAlpha: 0.6];
        [self.cardDeckView addSubview:cardView];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

@end
