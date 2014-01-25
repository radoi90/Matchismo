//
//  CardGameViewController.h
//  Machismo
//
//  Created by Emil Culic on 14/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//
// Abstract class. Must implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController
- (void)updateUI;

// protected
// for subclasses
- (Deck *)createDeck; // abstract
- (CardMatchingGame *) initialGame; // abstract
- (UIView *) getViewForCard:(Card *)card; // abstract
@end
