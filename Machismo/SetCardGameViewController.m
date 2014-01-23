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
                                        colors:@[@"red", @"green", @"purple"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    NSString *symbol = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        symbol = [setCard.shape stringByPaddingToLength:setCard.number
                                             withString:setCard.shape
                                        startingAtIndex:0];
        if ([setCard.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.shading isEqualToString:@"solid"])
            [attributes setObject:@-5
                           forKey:NSStrokeWidthAttributeName];
        if ([setCard.shading isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                                                   NSStrokeWidthAttributeName : @-5,
                                                   NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                                   NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName]
                                                                                     colorWithAlphaComponent:0.1]
                                                   }];
        if ([setCard.shading isEqualToString:@"outlined"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
    }
    return [[NSMutableAttributedString alloc] initWithString:symbol
                                                  attributes:attributes];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront_chosen" : @"cardfront"];
}

@end
