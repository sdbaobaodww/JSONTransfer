//
//  JSONTransfer.h
//  AnimationSurf
//
//  Created by Duanwwu on 14-5-17.
//  Copyright (c) 2014年 DZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONTransfer <NSObject>

/**
 * 根据数据字典创建对象
 * @param dictionary 数据字典
 * @returns 实例
 */
+ (instancetype)objectWithJsonDictionary:(NSDictionary*)dictionary;

/**
 * 根据数据字典创建对象
 * @param dictionary 数据字典
 * @returns 实例
 */
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary;

/**
 * @returns 根据对象生成数据字典
 */
- (NSMutableDictionary *)toJsonDictionary;

/**
 * 属性跟数据字段的映射关系，字典Value为NSString或者JSONTransferPropertyDescription协议类型
 * @returns 映射关系
 */
- (NSDictionary *)transferMap;

@end


/**
 * 描述属性的一些特征，可设置值字典中对应的Key，属性名称countryName对应json字典中的country_name；如果属性类型为数组，可设置数组项对应的类型
 */
@protocol JSONTransferPropertyDescriptor <NSObject>

/**
 * 数组项类型
 * @returns 数组项类型
 */
- (Class)arryItemClass;

/**
 * 对应字典中的Key
 * @returns 字典中与属性对应的Key
 */
- (NSString *)keyName;

@end