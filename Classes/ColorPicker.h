//
//  ColorPicker.h
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/5/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ColorPicker : UIPopoverController {
	UISlider *redSlider;
	UISlider *greenSlider;
	UISlider *blueSlider;
	UIView *colorPreview;
}

- (UIColor *)pickedColor;
- (void)presentFromBarButtonItem:(UIBarButtonItem *)item withColor:(UIColor *)color;

@end
