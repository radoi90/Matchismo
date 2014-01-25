//
//  PlayingCardView.h
//  Machismo
//
//  Created by Emil Culic on 25/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end
