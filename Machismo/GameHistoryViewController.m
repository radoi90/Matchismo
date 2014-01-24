//
//  GameHistoryViewController.m
//  Machismo
//
//  Created by Emil Culic on 24/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@end

@implementation GameHistoryViewController

- (void)setHistoryToDisplay:(NSAttributedString *)historyToDisplay
{
    _historyToDisplay = historyToDisplay;
    if (self.view.window) [self updateUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void) updateUI
{
    [self.historyTextView setAttributedText:self.historyToDisplay];
}
@end
