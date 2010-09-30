//
//  JXWhiteboardAppDelegate.h
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/2/10.
//  Copyright Stanford University 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WhiteboardViewController;

@interface JXWhiteboardAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WhiteboardViewController *whiteboardViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WhiteboardViewController *whiteboardViewController;

@end

