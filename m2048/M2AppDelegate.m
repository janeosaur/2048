//
//  M2AppDelegate.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2AppDelegate.h"
#import "M2ViewController.h"
#import <Skillz/Skillz.h>

@implementation M2AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
//  [[Skillz skillzInstance] performSelector:@selector(setDevTS) withObject:nil];
    
  [[Skillz skillzInstance] initWithGameId:@"4328"
                              forDelegate:(M2ViewController *)self.window.rootViewController
                          withEnvironment:SkillzSandbox
                                allowExit:NO];
    
  return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    //If your app uses portrait:
    return UIInterfaceOrientationMaskPortrait;
}

@end
