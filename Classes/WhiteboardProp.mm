//
//  WhiteboardProp.m
//  JXWhiteboard
//
//  Created by Alexander Favaro on 8/3/10.
//  Copyright 2010 Stanford University. All rights reserved.
//

#import "WhiteboardProp.h"

#include <stdlib.h>

@implementation WhiteboardProp

- (id)initWithName:(NSString *)name {
	return [super initWithName:name
				   replicaName:[NSString stringWithFormat:@"%@%d", name, arc4random()]];
}

- (NSDictionary *)strokeWithColor:(int)color width:(int)width points:(NSArray *)points {
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:[NSNumber numberWithInt:arc4random()] forKey:@"id"];
	[dic setObject:[NSString stringWithFormat:@"#%x", color] forKey:@"color"];
	[dic setObject:[NSNumber numberWithInt:width] forKey:@"width"];
	[dic setObject:[[points copy] autorelease] forKey:@"points"];
	return dic;
}

- (void)dealloc {
    [super dealloc];
}


@end
