//
//  JSONTransferable.h
//  AnimationSurf
//
//  Created by Duanwwu on 14-5-17.
//  Copyright (c) 2014年 DZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONTransfer.h"

/**
 * 处理不了的几种情况（复杂对象指非NSArray、NSDictionary、NSString、NSNumber的对象）
 * 1，属性为数组，但数组元素既有复杂对象又有基本对象；
 * 2，属性为复杂对象，但没有实现JSONTransfer协议
 */
@interface JSONTransferable : NSObject<JSONTransfer>

@end

@interface JSONTransferPropertyDescriptor : NSObject<JSONTransferPropertyDescriptor>

@property (nonatomic, retain) NSString *keyName;

@property (nonatomic) Class arryItemClass;

- (instancetype)initWithKeyName:(NSString *)keyName;

- (instancetype)initWithKeyName:(NSString *)keyName itemClass:(Class)itemClass;

+ (instancetype)descriptorWithKeyName:(NSString *)keyName;

+ (instancetype)descriptorWithKeyName:(NSString *)keyName itemClass:(Class)itemClass;

@end
