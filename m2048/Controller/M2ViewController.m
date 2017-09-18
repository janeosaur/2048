//
//  M2ViewController.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2ViewController.h"
#import "M2SettingsViewController.h"

#import "M2Scene.h"
#import "M2GameManager.h"
#import "M2ScoreView.h"
#import "M2GridView.h"

#import "M2Grid.h"
#import "M2Tile.h"
#import "M2Scene.h"

#import <Skillz/Skillz.h>



@implementation M2ViewController {
  IBOutlet UILabel *_targetScore;
  IBOutlet UILabel *_subtitle;
  IBOutlet M2ScoreView *_scoreView;
  IBOutlet M2ScoreView *_bestView;

    M2Grid *_grid;
 
    M2Scene *_scene;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    
  [[Skillz skillzInstance] launchSkillz];

  [self updateState];
  
  _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:@"Best Score"]];
    
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    M2Scene * scene = [M2Scene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [self updateScore:0];
    [scene startNewGame];
    
    _scene = scene;
    _scene.controller = self;
    
}

- (void)countDown {

    matchLength -=1;
    seconds.text = [NSString stringWithFormat:@"%i", matchLength];
    if (matchLength == 0) {
        NSLog(@"time ran out");
        [timer invalidate];
        [self endGame];
    }
}

- (void)tournamentWillBegin:(NSDictionary *)gameParameters
              withMatchInfo:(SKZMatchInfo *)matchInfo
{
    // This code is called when a player starts a game in the Skillz portal.
    NSLog(@"Game Parameters: %@", gameParameters);
    NSLog(@"match length: %@", gameParameters[@"matchLength"]);
    NSLog(@"Now starting a game… matchInfo: %@", matchInfo);
    
    // INCLUDE CODE HERE TO START YOUR GAME
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    M2Scene * scene = [M2Scene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [self updateScore:0];
    [scene startNewGame];
    
    _scene = scene;
    _scene.controller = self;

    
    // initialize timer
    matchLength = 60;
    matchLength = [gameParameters[@"matchLength"] intValue];
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:YES];
    

    
    // END OF CODE TO START GAME
}

- (void)skillzWillExit
{
    // This code is called when exiting the Skillz portal
    //back to the normal game.
    NSLog(@"Skillz exited.");
}


- (void)updateState
{
  [_scoreView updateAppearance];
  [_bestView updateAppearance];

  _targetScore.textColor = [GSTATE buttonColor];
  
  long target = [GSTATE valueForLevel:GSTATE.winningLevel];
  
  if (target > 100000) {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
  } else if (target < 10000) {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
  } else {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
  }
  
  _targetScore.text = [NSString stringWithFormat:@"%ld", target];
  
  _subtitle.textColor = [GSTATE buttonColor];
  _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
  _subtitle.text = [NSString stringWithFormat:@"Join the numbers to get to %ld!", target];

}


- (void)updateScore:(NSInteger)score
{
  _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
  if ([Settings integerForKey:@"Best Score"] < score) {
    [Settings setInteger:score forKey:@"Best Score"];
    _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
  }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Pause Sprite Kit. Otherwise the dismissal of the modal view would lag.
  ((SKView *)self.view).paused = YES;
}


- (IBAction)abortButtonPressed:(id)sender
{
        [[Skillz skillzInstance] notifyPlayerAbortWithCompletion:^() {
            [self updateScore:0];
            [_scene startNewGame];
            NSLog(@"Player is forfeiting the game");
        }];
}


- (IBAction)keepPlaying:(id)sender
{
  // [self hideOverlay];
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
  ((SKView *)self.view).paused = NO;
  if (GSTATE.needRefresh) {
    [GSTATE loadGlobalState];
    [self updateState];
    [self updateScore:0];
    [_scene startNewGame];
  }
}


- (void)endGame
{
    if ([[Skillz skillzInstance] tournamentIsInProgress]) {
        // The game ended and it was in a Skillz tournament,
        // so report the score and go back to Skillz.
        [[Skillz skillzInstance] displayTournamentResultsWithScore:_scoreView.score.text
                                                    withCompletion:^{
                                                        // Code in this block is called when exiting to Skillz
                                                        // and reporting the score.
                                                        NSLog(@"Reporting score to Skillz…");
                                                    }];
    }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

@end
