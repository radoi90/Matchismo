//
//  SetCardGameViewController.m
//  Machismo
//
//  Created by Emil Culic on 22/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] initWithShapes:@[@"▲", @"●", @"■"]
                                        colors:@[@"red", @"green", @"blue"]];
}

- (NSString *)titleForCard:(SetCard *)card
{
    NSMutableString *titleString = [[NSMutableString alloc] init];
    
    for(int i = 0; i < card.number; i ++)
    {
        [titleString appendString:card.shape];
    }
    
    return titleString;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront_chosen" : @"cardfront"];
}

@end
