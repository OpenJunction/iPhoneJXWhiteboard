//
//  JXWhiteboardAppDelegate.m
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/2/10.
//  Copyright Stanford University 2010. All rights reserved.
//

#import "JXWhiteboardAppDelegate.h"
#import "WhiteboardViewController.h"

@implementation JXWhiteboardAppDelegate

@synthesize window;
@synthesize whiteboardViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	whiteboardViewController = [[WhiteboardViewController alloc] init];
	
    // Override point for customization after app launch. 
    [window addSubview:whiteboardViewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [whiteboardViewController release];
    [window release];
    [super dealloc];
}


@end
