//
//  Deck.h
//  Machismo
//
//  Created by Emil Culic on 15/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
