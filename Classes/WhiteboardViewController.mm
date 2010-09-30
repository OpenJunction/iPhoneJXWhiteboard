//
//  JXWhiteboardViewController.m
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/2/10.
//  Copyright Stanford University 2010. All rights reserved.
//

#import "math.h"

#import "WhiteboardViewController.h"
#import "WhiteboardView.h"
#import "WhiteboardProp.h"
#import "LineWidthPicker.h"
#import "ColorPicker.h"

#import "JXJunctionActor.h"
#import "JXJunctionMaker.h"
#import "JXXMPPSwitchboardConfig.h"

static UIColor * const ERASE_COLOR = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
static CGFloat const ERASE_WIDTH = 30.0;

@interface PropChangeListener : NSObject <JXIPropChangeListener> {
	WhiteboardViewController *viewController;
}
- (id)initWithViewController:(WhiteboardViewController *)vc;
@end

@implementation PropChangeListener
- (id)initWithViewController:(WhiteboardViewController *)vc {
	if (self = [super init]) {
		viewController = [vc retain];
	}
	return self;
}
- (void)dealloc {
	[viewController release];
	[super dealloc];
}
- (NSString *)type {
	return EVT_CHANGE;
}
- (void)onChange:(id)data {
	[viewController onChange:data];
}
@end

@interface JunctionActor : JXJunctionActor {
	JXProp *prop;
}
- (id)initWithProp:(JXProp *)p;
@end

@implementation JunctionActor
- (id)initWithProp:(JXProp *)p {
	if (self = [super initWithRole:@"participant"]) {
		prop = [p retain];
	}
	return self;
}
- (void)dealloc {
	[prop release];
	[super dealloc];
}
- (void)onActivityJoin {
	NSLog(@"Joined!");
}
- (void)onMessageReceived:(NSDictionary *)msg header:(JXMessageHeader *)header {
	NSLog(@"Got msg!");
}
- (BOOL)onDisconnect {
	NSLog(@"Disconnected!");
	return NO;
}
- (NSArray *)getInitialExtras {
	return [NSArray arrayWithObject:prop];
}
@end

@implementation WhiteboardViewController

- (int)intWithColor:(UIColor *)color {
	const CGFloat *components = CGColorGetComponents([color CGColor]);
	int val = 0;
	val |= ((int)(components[0] * 255.0)) << 16;
	val |= ((int)(components[1] * 255.0)) << 8;
	val |= (int)(components[2] * 255.0);
	return val;
}

- (void)maybeRetryJunction {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
													message:@"Failed to connect to Whiteboard. Retry connection?"
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"OK", nil];
	[alert show];
}

- (void)initJunctionWithURL:(NSURL *)url {
	[whiteboardProp release];
	
	whiteboardProp = [[WhiteboardProp alloc] initWithName:@"whiteboard_model"];
	PropChangeListener *listener = [[PropChangeListener alloc] initWithViewController:self];
	[whiteboardProp addChangeListener:[listener autorelease]];
	[whiteboardProp addChangeListener:self];
	
	[actor leave];
	[actor release];
	actor = [[JunctionActor alloc] initWithProp:whiteboardProp];
	
	JXXMPPSwitchboardConfig *sb = [[JXXMPPSwitchboardConfig alloc] initWithHost:[url host]];
	[sb setConnectionTimeout:10];
	if ([[JXJunctionMaker getInstanceWithSwitchboard:sb] newJunctionWithURL:url actor:actor])
		[whiteboardView setState:whiteboardProp];
	else
		[self maybeRetryJunction];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [alertView firstOtherButtonIndex]) {
		[self initJunctionWithURL:junctionURL];
	}
}

- (id)init {
	if (self = [super initWithNibName:nil bundle:nil]) {
		junctionURL = [[NSURL alloc] initWithString:@"junction://openjunction.org/whiteboard"];
		
		currentPoints = [[NSMutableArray alloc] init];
		currentColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		currentWidth = 10.0;
		
		isErasing = NO;
		
		lineWidthPicker = [[LineWidthPicker alloc] init];
		colorPicker = [[ColorPicker alloc] init];
		
		[lineWidthPicker setDelegate:self];
		[colorPicker setDelegate:self];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(orientationChanged)
													 name:UIDeviceOrientationDidChangeNotification
												   object:[UIDevice currentDevice]];
	}
	return self;
}

- (void)dealloc {
	[whiteboardView release];
	[whiteboardProp release];
	[actor release];
	[junctionURL release];
	
	[currentPoints release];
	[lineWidthPicker release];
    [super dealloc];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	whiteboardView = [[WhiteboardView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[whiteboardView setBackgroundColor:[UIColor whiteColor]];
	
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear All"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(clearWhiteboard)];
	UIBarButtonItem *lineWidthButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Line Width"
																		style:UIBarButtonItemStyleBordered
																	   target:self 
																	   action:@selector(showLineWidthPicker:)];
	UIBarButtonItem *eraseButton = [[UIBarButtonItem alloc] initWithTitle:@"Eraser"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(toggleErase:)];
	UIBarButtonItem *colorButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Color"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(showColorPicker:)];
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																		   target:nil
																		   action:nil];
	
	toolbar = [[UIToolbar alloc] initWithFrame:[whiteboardView frame]];
	[toolbar setItems:[NSArray arrayWithObjects:lineWidthButton, colorButton, space, eraseButton, clearButton, nil]];
	[toolbar sizeToFit];
	CGRect toolbarFrame = [toolbar frame];
	[toolbar setFrame:CGRectMake(toolbarFrame.origin.x, [whiteboardView frame].size.height -
								 toolbarFrame.size.height, toolbarFrame.size.width,
								 toolbarFrame.size.height)];
	[toolbar setBarStyle:UIBarStyleBlack];
	[toolbar setTranslucent:YES];
	[whiteboardView addSubview:[toolbar autorelease]];
	
	[self setView:[whiteboardView autorelease]];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self performSelector:@selector(initJunctionWithURL:)
			   withObject:junctionURL afterDelay:0.1];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)orientationChanged {
	/*
	CGRect frame = [whiteboardView frame];
	CGRect toolbarFrame = [toolbar frame];
	CGAffineTransform transform;
	switch ([[UIDevice currentDevice] orientation]) {
		case UIDeviceOrientationLandscapeLeft:
			[toolbar setFrame:CGRectMake(toolbarFrame.origin.x, toolbarFrame.origin.y,
										 frame.size.height, toolbarFrame.size.height)];
			[toolbar setCenter:CGPointMake(toolbarFrame.size.height/2, frame.size.height/2)];
			transform = CGAffineTransformMakeRotation(M_PI_2);
			[toolbar setTransform:transform];
			break;

		default:
			break;
	}
	 */
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[toolbar release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint point = [(UITouch *)[touches anyObject] locationInView:whiteboardView];
	[currentPoints addObject:[NSNumber numberWithInt:(int)point.x]];
	[currentPoints addObject:[NSNumber numberWithInt:(int)point.y]];
	[whiteboardView beginStrokeWithPoint:point
								   color:isErasing? ERASE_COLOR:currentColor
							   lineWidth:isErasing? ERASE_WIDTH:currentWidth];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint point = [(UITouch *)[touches anyObject] locationInView:whiteboardView];
	[currentPoints addObject:[NSNumber numberWithInt:(int)point.x]];
	[currentPoints addObject:[NSNumber numberWithInt:(int)point.y]];
	[whiteboardView continueStrokeWithPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[whiteboardProp addDictionary:[whiteboardProp strokeWithColor:isErasing? [self intWithColor:ERASE_COLOR]:[self intWithColor:currentColor]
															width:isErasing? (int)ERASE_WIDTH:(int)currentWidth
														   points:currentPoints]];
	[currentPoints removeAllObjects];
	[whiteboardView endStroke];
}

- (NSString *)type {
	return EVT_SYNC;
}

- (void)onChange:(id)data {
	[whiteboardView performSelectorOnMainThread:@selector(setNeedsDisplay)
									 withObject:nil waitUntilDone:NO];
}

- (void)clearWhiteboard {
	[whiteboardProp clear];
	[whiteboardView setNeedsDisplay];
}

- (void)showLineWidthPicker:(id)sender {
	if ([colorPicker isPopoverVisible]) {
		[colorPicker dismissPopoverAnimated:YES];
		[currentColor release];
		currentColor = [[colorPicker pickedColor] retain];
	}
	
	if ([lineWidthPicker isPopoverVisible]) {
		[lineWidthPicker dismissPopoverAnimated:YES];
		currentWidth = [lineWidthPicker pickedWidth];
	} else {
		[lineWidthPicker presentFromBarButtonItem:sender
									withLineWidth:currentWidth];
	}
}

- (void)showColorPicker:(id)sender {
	if ([lineWidthPicker isPopoverVisible]) {
		[lineWidthPicker dismissPopoverAnimated:YES];
		currentWidth = [lineWidthPicker pickedWidth];
	}
	
	if ([colorPicker isPopoverVisible]) {
		[colorPicker dismissPopoverAnimated:YES];
		[currentColor release];
		currentColor = [[colorPicker pickedColor] retain];
	} else {
		[colorPicker presentFromBarButtonItem:sender
									withColor:currentColor];
	}
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	if (popoverController == lineWidthPicker) {
		currentWidth = [lineWidthPicker pickedWidth];
	} else if (popoverController == colorPicker) {
		[currentColor release];
		currentColor = [[colorPicker pickedColor] retain];
	}
}

- (void)toggleErase:(id)sender {
	if (isErasing) {
		isErasing = NO;
		[(UIBarButtonItem *)sender setTitle:@"Eraser"];
	} else {
		isErasing = YES;
		[(UIBarButtonItem *)sender setTitle:@"Stop Erasing"];
	}
}


@end
