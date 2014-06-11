//
//  NSObject+RuntimeUtil.h
//  AnimationSurf
//
//  Created by Duanwwu on 14-5-17.
//  Copyright (c) 2014年 DZH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPropertyReadOnlyKey    @"Property_ReadOnly"
#define kPropertyTypeKey        @"Property_Type"

@interface NSObject (RuntimeUtil)

/**
 * 判断某个属性是否是只读属性
 * @param propertyName 属性名称
 * @param clazz 属性所在对象的类
 * @returns 只读YES，否则NO
 */
+ (BOOL)isPropertyReadOnly:(NSString*)propertyName ofClass:(Class)clazz;

/**
 * 属性的对象类型
 * @param propertyName 属性名称
 * @param clazz 属性所在对象的类
 * @returns
 */
+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)clazz;

/**
 * 类的所有属性名称，包括父类的属性
 * @param clazz 类
 * @returns 属性名称集合
 */
+ (NSArray *)propertyNamesOfClass:(Class)clazz;

/**
 * 类的所有属性信息，Key为属性名称，Value对该属性描述字典(包括属性对应的类型，和是否只读)，包括父类的属性
 * @param clazz 类
 * @returns 该类型所有属性信息
 */
+ (NSDictionary *)propertyDicOfClass:(Class)clazz;

/**
 * 判断类是否实现协议，当前类如果没有实现协议，则递归调用判断父类是否实现，直到父类为NSObject
 * @param clazz 类
 * @param protocol 协议
 * @returns 类实现协议YES，否则NO
 */
+ (BOOL)clazz:(Class)clazz conformsToProtocol:(Protocol *)protocol;

@end
