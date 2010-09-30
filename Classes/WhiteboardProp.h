//
//  WhiteboardProp.h
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/3/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXArrayProp.h"

@interface WhiteboardProp : JXArrayProp {

}

- (id)initWithName:(NSString *)name;

- (NSDictionary *)strokeWithColor:(int)color width:(int)width points:(NSArray *)points;

@end
