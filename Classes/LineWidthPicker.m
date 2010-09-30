//
//  LineWidthPicker.m
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/5/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "LineWidthPicker.h"

static CGFloat const MAX_LINE_WIDTH = 50;
static CGFloat const MIN_LINE_WIDTH	= 1;

@implementation LineWidthPicker

- (id)init {
	UIViewController *content = [[UIViewController alloc] init];
	[content setContentSizeForViewInPopover:CGSizeMake(320, 160)];
	
	if (self = [super initWithContentViewController:content]) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
		[view setBackgroundColor:[UIColor blackColor]];
		
		slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 18, 300, 22)];
		[slider addTarget:self action:@selector(previewLine)
		 forControlEvents:UIControlEventValueChanged];
		
		widthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 300, 22)];
		[widthLabel setBackgroundColor:[UIColor blackColor]];
		[widthLabel setTextColor:[UIColor whiteColor]];
		[widthLabel setTextAlignment:UITextAlignmentCenter];
		[widthLabel setText:@"10px"];
		
		linePreview = [[UIView alloc] initWithFrame:CGRectMake(60, 95, 200, 10)];
		[linePreview setBackgroundColor:[UIColor grayColor]];
		
		[view addSubview:slider];
		[view addSubview:widthLabel];
		[view addSubview:linePreview];
		[content setView:view];
		
		[content release];
		[view release];
	}
	return self;
}

- (void)dealloc {
	[slider release];
	[linePreview release];
	[super dealloc];
}

- (void)previewLine {
	CGFloat width = [self pickedWidth];
	[widthLabel setText:[NSString stringWithFormat:@"%dpx", (int)width]];
	CGRect bounds = [linePreview bounds];
	[linePreview setBounds:CGRectMake(bounds.origin.x, bounds.origin.y -
									  (width-bounds.size.height), bounds.size.width,
									  width)];
}

- (void)presentFromBarButtonItem:(UIBarButtonItem *)item withLineWidth:(CGFloat)width {
	[slider setValue:width / MAX_LINE_WIDTH];
	[self previewLine];
	[super presentPopoverFromBarButtonItem:item
				  permittedArrowDirections:UIPopoverArrowDirectionAny
								  animated:YES];
}

- (CGFloat)pickedWidth {
	CGFloat width =  [slider value] * MAX_LINE_WIDTH;
	if (width < MIN_LINE_WIDTH) {
		width = MIN_LINE_WIDTH;
	}
	return width;
}

@end
