//
//  JSONObject.h
//  AnimationSurf
//
//  Created by Duanwwu on 14-6-10.
//  Copyright (c) 2014年 DZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONTransferable.h"

@interface JSONObject : JSONTransferable 

@property (nonatomic, retain) NSString *name;

@property (nonatomic) int price;

@property (nonatomic, retain) NSDictionary *dic;

@property (nonatomic, retain) NSArray *items;

@property (nonatomic, retain) JSONObject *subJson;

@end

@interface JSONObject2 : JSONObject
{
    @public
    NSString *_readOnly;
}

@property (nonatomic, readonly, copy) NSString *readOnly;

@end

