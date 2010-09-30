//
//  LineWidthPicker.h
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/5/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineWidthPicker : UIPopoverController {
	UISlider *slider;
	UIView *linePreview;
	UILabel *widthLabel;
}

- (CGFloat)pickedWidth;
- (void)presentFromBarButtonItem:(UIBarButtonItem *)item withLineWidth:(CGFloat)width;

@end
