//
//  ColorPicker.m
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/5/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "ColorPicker.h"


@implementation ColorPicker

- (id)init {
	UIViewController *content = [[UIViewController alloc] init];
	[content setContentSizeForViewInPopover:CGSizeMake(320, 160)];
	
	if (self = [super initWithContentViewController:content]) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
		[view setBackgroundColor:[UIColor blackColor]];
		
		redSlider = [[UISlider alloc] initWithFrame:CGRectMake(35, 18, 275, 22)];
		greenSlider = [[UISlider alloc] initWithFrame:CGRectMake(35, 48, 275, 22)];
		blueSlider = [[UISlider alloc] initWithFrame:CGRectMake(35, 78, 275, 22)];
		
		[redSlider addTarget:self action:@selector(previewColor)
			forControlEvents:UIControlEventValueChanged];
		[greenSlider addTarget:self action:@selector(previewColor)
			forControlEvents:UIControlEventValueChanged];
		[blueSlider addTarget:self action:@selector(previewColor)
			forControlEvents:UIControlEventValueChanged];
		
		UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 20, 22)];
		[redLabel setBackgroundColor:[UIColor blackColor]];
		[redLabel setTextColor:[UIColor whiteColor]];
		[redLabel setText:@"R:"];
		UILabel *greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 48, 20, 22)];
		[greenLabel setBackgroundColor:[UIColor blackColor]];
		[greenLabel setTextColor:[UIColor whiteColor]];
		[greenLabel setText:@"G:"];
		UILabel *blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 78, 20, 22)];
		[blueLabel setBackgroundColor:[UIColor blackColor]];
		[blueLabel setTextColor:[UIColor whiteColor]];
		[blueLabel setText:@"B:"];
		
		colorPreview = [[UIView alloc] initWithFrame:CGRectMake(120, 110, 80, 40)];
		
		[view addSubview:redSlider];
		[view addSubview:greenSlider];
		[view addSubview:blueSlider];
		[view addSubview:redLabel];
		[view addSubview:greenLabel];
		[view addSubview:blueLabel];
		[view addSubview:colorPreview];
		[content setView:view];
		
		[content release];
		[view release];
	}
	return self;
}

- (UIColor *)pickedColor {
	return [colorPreview backgroundColor];
}

- (void)previewColor {
	UIColor *color = [UIColor colorWithRed:[redSlider value]
									 green:[greenSlider value]
									  blue:[blueSlider value]
									 alpha:1.0];
	[colorPreview setBackgroundColor:color];
}

- (void)presentFromBarButtonItem:(UIBarButtonItem *)item withColor:(UIColor *)color {
	const CGFloat *components = CGColorGetComponents([color CGColor]);
	[redSlider setValue:components[0]];
	[greenSlider setValue:components[1]];
	[blueSlider setValue:components[2]];
	[self previewColor];
	[super presentPopoverFromBarButtonItem:item
				  permittedArrowDirections:UIPopoverArrowDirectionAny
								  animated:YES];
}

@end
