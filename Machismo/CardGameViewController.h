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

@interface CardGameViewController : UIViewController

// protected
// for subclasses
- (Deck *)createDeck; // abstract

@end
