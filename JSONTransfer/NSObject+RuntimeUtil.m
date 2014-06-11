//
//  NSObject+RuntimeUtil.m
//  AnimationSurf
//
//  Created by Duanwwu on 14-5-17.
//  Copyright (c) 2014年 DZH. All rights reserved.
//

#import "NSObject+RuntimeUtil.h"
#import <objc/runtime.h>

static NSString * property_getTypeName(objc_property_t property)
{
    const char *attributes                  = property_getAttributes(property);
    NSArray *descriptions                   = [[NSString stringWithUTF8String:attributes] componentsSeparatedByString:@","];
    if([descriptions count] != 0)
    {
        NSString *typeEncode                = [descriptions firstObject];
        return [typeEncode substringWithRange:NSMakeRange(3, [typeEncode length] - 4)];
    }
    return @"@";
}

@implementation NSObject (RuntimeUtil)

static NSMutableDictionary *propertyInfoCache;

+ (BOOL)isPropertyReadOnly:(NSString*)propertyName ofClass:(Class)clazz
{
    const char *type                        = property_getAttributes(class_getProperty(clazz, [propertyName UTF8String]));
    NSString *typeString                    = [NSString stringWithUTF8String:type];
    NSArray *attributes                     = [typeString componentsSeparatedByString:@","];
    NSString *propertyType                  = [attributes objectAtIndex:1];

    return [propertyType rangeOfString:@"R"].length > 0;
}

+ (NSArray *)propertyNamesOfClass:(Class)clazz
{
    NSMutableArray *nameArray               = [NSMutableArray array];
    unsigned int count                      = 0;
    objc_property_t *properties             = class_copyPropertyList(clazz, &count);

    for (unsigned int i = 0; i < count; ++i)
    {
        objc_property_t property            = properties[i];
        const char * name                   = property_getName(property);
        
        [nameArray addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    NSArray* arr                            = [NSObject propertyNamesOfClass:class_getSuperclass(clazz)];
    [nameArray addObjectsFromArray:arr];
    return nameArray;
}

+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)clazz
{
	unsigned int count                      = 0;
	objc_property_t *properties             = class_copyPropertyList(clazz, &count);
	
	const char * cPropertyName              = [propertyName UTF8String];
	
	for (unsigned int i = 0; i < count; ++i)
    {
		objc_property_t property            = properties[i];
		const char * name                   = property_getName(property);
		if (strcmp(cPropertyName, name) == 0)
        {
			free(properties);
			NSString *className             = property_getTypeName(property);
			return NSClassFromString(className);
		}
	}
    free(properties);
	return [self propertyClassForPropertyName:propertyName ofClass:class_getSuperclass(clazz)];
}

+ (NSDictionary *)propertyDicOfClass:(Class)clazz
{
    if (!clazz)
        return nil;
    
    if (propertyInfoCache == nil) //缓存未创建
        propertyInfoCache                   = [[NSMutableDictionary alloc] init];
    
    NSString *className                     = NSStringFromClass(clazz);
    
    NSMutableDictionary *propertyDic        = [propertyInfoCache objectForKey:className];
    
    if (propertyDic)    //缓存中存在
        return propertyDic;

    propertyDic                             = [NSMutableDictionary dictionary];
    
    unsigned int count                      = 0;
    objc_property_t *properties             = class_copyPropertyList(clazz, &count);
    
    @autoreleasepool
    {
        for (unsigned int i = 0; i < count; ++i)
        {
            objc_property_t property            = properties[i];
            const char * name                   = property_getName(property);
            
            NSString *propertyType              = nil;
            BOOL isReadOnly                     = NO;
            
            const char *attributes              = property_getAttributes(property);
            NSArray *attributeArr               = [[NSString stringWithUTF8String:attributes] componentsSeparatedByString:@","];
            
            propertyType                        = [[attributeArr firstObject] substringFromIndex:1];//去掉T，剩下@encode字符
            
            if ([propertyType hasPrefix:@"@"] && [propertyType length] > 3)    //自定义对象类型 @“”
            {
                propertyType                    = [propertyType substringWithRange:NSMakeRange(2, [propertyType length] - 3)];
            }
            
            if ([[attributeArr objectAtIndex:1] rangeOfString:@"R"].length > 0) //判断是否为只读属性
                isReadOnly                      = YES;
            
            [propertyDic setObject:@{kPropertyReadOnlyKey:@(isReadOnly),kPropertyTypeKey:propertyType} forKey:[NSString stringWithUTF8String:name]];
        }
    }
    
    free(properties);
    
    Class superClass                            = class_getSuperclass(clazz);
    if (![NSStringFromClass(superClass) isEqualToString:@"NSObject"])
    {
        NSDictionary* subPropertyDic            = [NSObject propertyDicOfClass:superClass];
        if (subPropertyDic)
            [propertyDic addEntriesFromDictionary:subPropertyDic];
    }
    
    [propertyInfoCache setObject:propertyDic forKey:className];
    
    return propertyDic;
}

+ (BOOL)clazz:(Class)clazz conformsToProtocol:(Protocol *)protocol
{
    BOOL ret                = class_conformsToProtocol(clazz, protocol);
    
    if (ret)
        return YES;
    else
    {
        Class superClass    =  class_getSuperclass(clazz);
        
        if ([NSStringFromClass(superClass) isEqualToString:@"NSObject"])
            return NO;
        
        ret                 = [NSObject clazz:superClass conformsToProtocol:protocol];
    }
    
    return ret;
}

@end
