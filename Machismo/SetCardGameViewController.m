//
//  SetCardGameViewController.m
//  Machismo
//
//  Created by Emil Culic on 22/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] initWithShapes:@[@"", @"", @""]
                                        colors:@[@"red", @"green", @"blue"]];
}

@end
