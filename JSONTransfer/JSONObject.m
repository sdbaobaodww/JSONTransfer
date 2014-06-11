//
//  JSONObject.m
//  AnimationSurf
//
//  Created by Duanwwu on 14-6-10.
//  Copyright (c) 2014年 DZH. All rights reserved.
//

#import "JSONObject.h"

@implementation JSONObject

- (void)dealloc
{
    self.name       = nil;
    self.dic        = nil;
    self.subJson    = nil;
    self.items      = nil;
    [super dealloc];
}

- (NSDictionary *)transferMap
{
    return @{@"dic":@"mapping"};
}

@end

@implementation JSONObject2

- (void)dealloc
{
    [_readOnly release];
    [super dealloc];
}

- (NSDictionary *)transferMap
{
    return @{@"dic":@"mapping",@"items":[JSONTransferPropertyDescriptor descriptorWithKeyName:@"items" itemClass:[JSONObject class]],@"readOnly":[JSONTransferPropertyDescriptor descriptorWithKeyName:@"_readonly" itemClass:NULL]};
}

@end