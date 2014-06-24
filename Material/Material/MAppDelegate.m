//
//  MAppDelegate.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "MAppDelegate.h"
#import "Login.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation MAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    Login *login=[[Login alloc] init];
//    self.window.rootViewController=login;
//    [self.window makeKeyAndVisible];
    [[Captuvo sharedCaptuvoDevice] setDecoderGoodReadBeeperVolume:BeeperVolumeLow persistSetting:YES];
    [[Captuvo sharedCaptuvoDevice] enableDecoderPowerUpBeep:NO];
    

    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    reachability.reachableBlock = ^(Reachability *reachability) {
       
    };
    reachability.unreachableBlock = ^(Reachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:@"网络连接已断开"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            AudioServicesPlaySystemSound(1013);
            [alert show];
        });
        
    };
    [reachability startNotifier];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
     [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    // Restart any tasks that were paused (or not yet started) while  the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
