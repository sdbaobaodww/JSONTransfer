//
//  JSONTransferable.m
//  AnimationSurf
//
//  Created by Duanwwu on 14-5-17.
//  Copyright (c) 2014年 DZH. All rights reserved.
//

#import "JSONTransferable.h"
#import "NSObject+RuntimeUtil.h"

@implementation JSONTransferable

+ (instancetype)objectWithJsonDictionary:(NSDictionary*)dictionary
{
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init]))
    {
        NSDictionary *transferMap   = [self transferMap];
        
        [[JSONTransferable propertyDicOfClass:[self class]] enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSDictionary *dic, BOOL *stop) {
            
            id descriptor           = [transferMap objectForKey:propertyName];//字符串或者JSONTransferPropertyDescription类型
            
            NSString *keyName       = [descriptor respondsToSelector:@selector(keyName)] ? [descriptor keyName] : descriptor;//属性名称对应的字典Key
            
            if (keyName == nil) //默认为属性名称
                keyName             = propertyName;
            
			id value                = [dictionary valueForKey:keyName];//取得数据字典中对应的值
			
			if (value == [NSNull null] || value == nil)
                return;
            
            if ([[dic objectForKey:kPropertyReadOnlyKey] boolValue])//属性只读
                return;
			
			if ([value isKindOfClass:[NSDictionary class]])//如果值为字典
            {
                NSString *className = [dic objectForKey:kPropertyTypeKey];
				Class clazz         = NSClassFromString(className);
                
                if ([NSObject clazz:clazz conformsToProtocol:@protocol(JSONTransfer)]) //实现JSONTransfer协议
                {
                    value           = [[[clazz alloc] initWithJsonDictionary:value] autorelease];
                }
                else
                {
                    NSAssert([clazz isSubclassOfClass:[NSDictionary class]], @"属性类型非法");
                }
			}
			else if ([value isKindOfClass:[NSArray class]])//如果值是数组
            {
				NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[(NSArray *)value count]];
				
				for (id child in value)
                {
                    if ([[child class] isSubclassOfClass:[NSDictionary class]])//数组项为字典类型
                    {
                        Class itemClazz     = NULL;
                        
                        if ([descriptor respondsToSelector:@selector(arryItemClass)])
                            itemClazz       = [descriptor arryItemClass];
                        
                        if (itemClazz == NULL)
                            continue;
                        
                        if ([itemClazz isSubclassOfClass:[NSDictionary class]]) //字典对象
                        {
                            [childObjects addObject:child];
                        }
                        else if ([NSObject clazz:itemClazz conformsToProtocol:@protocol(JSONTransfer)]) //实现JSONTransfer协议
                        {
                            id childItem    = [[[itemClazz alloc] initWithJsonDictionary:child] autorelease];
                            [childObjects addObject:childItem];
                        }
                        else
                        {
                            NSAssert(NO, @"属性类型非法");
                        }
					}
                    else    //数组项为基本数据类型
                    {
						[childObjects addObject:child];
					}
				}
				
				value = childObjects;
			}
            
			[self setValue:value forKey:propertyName];
        }];
	}
	return self;
}

- (NSMutableDictionary *)toJsonDictionary
{
    NSMutableDictionary *jsonDic        = [NSMutableDictionary dictionary];
    NSDictionary *transferMap           = [self transferMap];
    [[JSONTransferable propertyDicOfClass:[self class]] enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSDictionary *dic, BOOL *stop) {
        
        id descriptor                   = [transferMap objectForKey:propertyName];//字符串或者JSONTransferPropertyDescription类型
        
        NSString *keyName               = [descriptor respondsToSelector:@selector(keyName)] ? [descriptor keyName] : descriptor;//属性名称对应的字典Key
        
        if (keyName == nil) //默认为属性名称
            keyName                     = propertyName;
        
        id value                        = [self valueForKey:propertyName];
        
        if (value)
            [jsonDic setObject:[self recursionWithPropertyValue:value] forKey:keyName];
    }];
    
    return jsonDic;
}

- (id)recursionWithPropertyValue:(id)value
{
    if ([value conformsToProtocol:@protocol(JSONTransfer)])
    {
        return [value toJsonDictionary];
    }
    else if([value isKindOfClass:[NSArray class]])
    {
        NSMutableArray *childrens   = [NSMutableArray array];
        
        for (id valueItem in value)
        {
            [childrens addObject:[self recursionWithPropertyValue:valueItem]];
        }
        
        return childrens;
    }
    else
    {
        return value;
    }
}

- (NSDictionary *)transferMap
{
    return nil;
}

@end

@implementation JSONTransferPropertyDescriptor

- (instancetype)initWithKeyName:(NSString *)keyName
{
    return [self initWithKeyName:keyName itemClass:NULL];
}

- (instancetype)initWithKeyName:(NSString *)keyName itemClass:(Class)itemClass
{
    if (self = [super init])
    {
        self.keyName            = keyName;
        self.arryItemClass      = itemClass;
    }
    return self;
}

+ (instancetype)descriptorWithKeyName:(NSString *)keyName
{
    return [self descriptorWithKeyName:keyName itemClass:NULL];
}

+ (instancetype)descriptorWithKeyName:(NSString *)keyName itemClass:(Class)itemClass
{
    return [[self alloc] initWithKeyName:keyName itemClass:itemClass];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"keyName:%@   arrayItemClass:%@",self.keyName,NSStringFromClass(self.arryItemClass)];
}

- (void)dealloc
{
    [_keyName release];
    _arryItemClass = nil;
    [super dealloc];
}

@end
