//
//  VGAppDelegate.m
//  VGApp
//
//  Created by Daryl Fensom on 01/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGAppDelegate.h"

#import "VGViewController.h"



@implementation VGAppDelegate

@synthesize navigationController = _navigationController;
@synthesize Cards                =  mCards;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    
    VGViewController *viewController = [[VGViewController alloc] initWithNibName:@"VGViewController" bundle:nil];
    
    
    
    // Override point for customization after application launch.
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.navigationController.navigationBar.translucent = NO;
    
   // self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.01 green:0.15 blue:0.44 alpha:1];
    
   
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"Helvetica Neue" size:17.0f]}];
    
    //*****************
    //DATA
    //*****************
        
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
