//
//  JXWhiteboardViewController.h
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/2/10.
//  Copyright Stanford University 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXIPropChangeListener.h"

@class WhiteboardView;
@class WhiteboardProp;
@class LineWidthPicker;
@class ColorPicker;
@class JXJunctionActor;

@interface WhiteboardViewController : UIViewController <JXIPropChangeListener, UIAlertViewDelegate, UIPopoverControllerDelegate> {
	WhiteboardView *whiteboardView;
	WhiteboardProp *whiteboardProp;
	JXJunctionActor *actor;
	NSURL *junctionURL;
	
	UIToolbar *toolbar;
	LineWidthPicker *lineWidthPicker;
	ColorPicker *colorPicker;
	
	NSMutableArray *currentPoints;
	UIColor *currentColor;
	CGFloat currentWidth;
	BOOL isErasing;
}

@end

