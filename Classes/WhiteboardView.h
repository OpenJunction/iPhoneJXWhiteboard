//
//  JXWhiteboardView.h
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/3/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WhiteboardProp;

@interface WhiteboardView : UIView {
	WhiteboardProp *prop;
	UIBezierPath *currentStroke;
	UIColor *currentColor;
}

- (void)beginStrokeWithPoint:(CGPoint)point color:(UIColor *)color lineWidth:(CGFloat)lineWidth;
- (void)continueStrokeWithPoint:(CGPoint)point;
- (void)endStroke;

- (void)setState:(WhiteboardProp *)state;

@end
