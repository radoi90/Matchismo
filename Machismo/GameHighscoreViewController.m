//
//  GameHighscoreViewController.m
//  Machismo
//
//  Created by Emil Culic on 24/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "GameHighscoreViewController.h"

@interface GameHighscoreViewController ()
@property (weak, nonatomic) IBOutlet UITextView *highscoreTextView;

@end

@implementation GameHighscoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateUI];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    NSArray *userHighscoreData = [[NSUserDefaults standardUserDefaults] arrayForKey:@"highscores"];
    
    if (userHighscoreData) {
        NSMutableString *text = [[NSMutableString alloc] init];
        
        for (NSDictionary *highscoreRecord in userHighscoreData) {
            [text appendFormat:@"%ld started on: %@ duration: %@ [%@]\n",
             (long)[[highscoreRecord valueForKey:@"highscore"] integerValue],
             [highscoreRecord valueForKey:@"date"],
             [highscoreRecord valueForKey:@"gameDuration"],
             [highscoreRecord valueForKey:@"gameType"]];
            
        }
        
        [self.highscoreTextView setText:text];
    }

}

@end
