//
//  JXWhiteboardView.m
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/3/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "WhiteboardView.h"
#import "WhiteboardProp.h"

@interface WhiteboardView (Private)

- (UIColor *)colorWithStroke:(NSDictionary *)stroke;
- (UIBezierPath *)pathWithStroke:(NSDictionary *)stroke;

@end

@implementation WhiteboardView (Private)

- (UIColor *)colorWithStroke:(NSDictionary *)stroke {
	NSString *colorStr = [(NSString *)[stroke objectForKey:@"color"] substringFromIndex:1];
	NSScanner *scanner = [NSScanner scannerWithString:colorStr];
	unsigned int color;
	[scanner scanHexInt:&color];
	return [UIColor colorWithRed:((float)((color&0xFF0000)>>16)/255.0) 
						   green:((float)((color&0xFF00)>>8)/255.0)
							blue:((float)(color&0xFF)/255.0)
						   alpha:1.0];
}

- (UIBezierPath *)pathWithStroke:(NSDictionary *)stroke {
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path setLineJoinStyle:kCGLineJoinRound];
	[path setLineCapStyle:kCGLineCapRound];
	
	NSNumber *width = [stroke objectForKey:@"width"];
	[path setLineWidth:(CGFloat)[width intValue]];
	NSArray *points = [stroke objectForKey:@"points"];
	if ([points count] >= 4) {
		for (int i = 0; i < [points count]; i += 2) {
			int x = [(NSNumber *)[points objectAtIndex:i] intValue];
			int y = [(NSNumber *)[points objectAtIndex:i+1] intValue];
			CGPoint point = {(CGFloat)x, (CGFloat)y};
			if (i == 0)
				[path moveToPoint:point];
			else 
				[path addLineToPoint:point];
		}
	}
	return path;
}

@end

@implementation WhiteboardView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		currentStroke = [[UIBezierPath bezierPath] retain];
		[currentStroke setLineJoinStyle:kCGLineJoinRound];
		[currentStroke setLineCapStyle:kCGLineCapRound];
		currentColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc {
	[prop release];
	[currentStroke release];
	[currentColor release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
	NSArray *strokes = [prop items];
	for (int i = 0; i < [strokes count]; i++) {
		NSDictionary *stroke = [strokes objectAtIndex:i];
		UIBezierPath *path = [self pathWithStroke:stroke];
		if (CGRectIntersectsRect(rect, [path bounds])) {
			[[self colorWithStroke:stroke] set];
			[path stroke];
		}
	}
	
	if (CGRectIntersectsRect(rect, [currentStroke bounds])) {
		[currentColor set];
		[currentStroke stroke];
	}
}

- (void)beginStrokeWithPoint:(CGPoint)point color:(UIColor *)color lineWidth:(CGFloat)lineWidth {
	[currentStroke setLineWidth:lineWidth];
	[currentStroke moveToPoint:point];
	
	[currentColor release];
	currentColor = [color retain];
}

- (void)continueStrokeWithPoint:(CGPoint)point {
	if (![currentStroke isEmpty]) {
		[currentStroke addLineToPoint:point];
		[self setNeedsDisplay];
	}
}

- (void)endStroke {
	[currentStroke removeAllPoints];
}

- (void)setState:(WhiteboardProp *)state {
	[prop release];
	prop = [state retain];
}

@end

