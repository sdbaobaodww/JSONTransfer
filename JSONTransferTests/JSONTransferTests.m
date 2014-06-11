//
//  JSONTransferTests.m
//  JSONTransferTests
//
//  Created by Duanwwu on 14-6-10.
//  Copyright (c) 2014年 DZH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONObject.h"

@interface JSONTransferTests : XCTestCase

@end

@implementation JSONTransferTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testWithSimpleArrayItem
{
    NSDictionary *dic = @{@"name":@"testJsonObject", @"price":@(1000), @"mapping": @{@"test1":@"111",@"test2":@"222"}, @"items": @[@"item1",@(2222),@"item3"], @"subJson":@{@"name":@"subObject", @"price": @(12341234)}};
    
    JSONObject *object = [[[JSONObject alloc] initWithJsonDictionary:dic] autorelease];
    
    XCTAssert([object.name isEqualToString:@"testJsonObject"], @"name error");
    XCTAssert(object.price == 1000, @"price error");
    XCTAssert([object.dic count] == 2, @"dic error");
    XCTAssert([object.items count] == 3, @"items error");
    XCTAssert(object.subJson, @"subjson error");
    
    NSDictionary *json = [object toJsonDictionary];
    
    NSLog(@"测试成功");
}

- (void)testWithComplexArrayItem
{
    NSDictionary *dic = @{@"name":@"testJsonObject", @"price":@(1000), @"mapping": @{@"test1":@"111",@"test2":@"222"}, @"items": @[@{@"name":@"subObject", @"price": @(12341234)}], @"subJson":@{@"name":@"subObject", @"price": @(12341234)}};
    
    JSONObject2 *object = [[[JSONObject2 alloc] initWithJsonDictionary:dic] autorelease];
    
    XCTAssert([object.name isEqualToString:@"testJsonObject"], @"name error");
    XCTAssert(object.price == 1000, @"price error");
    XCTAssert([object.dic count] == 2, @"dic error");
    XCTAssert([object.items count] == 1, @"items error");
    XCTAssert([[object.items firstObject] isKindOfClass:[JSONObject class]], @"item type error");
    XCTAssert(object.subJson, @"subjson error");
    
    NSDictionary *json = [object toJsonDictionary];
    
    NSLog(@"测试成功");
}

- (void)testReadOnlyProperty
{
    NSDictionary *dic = @{@"name":@"testJsonObject", @"price":@(1000), @"mapping": @{@"test1":@"111",@"test2":@"222"}, @"items": @[@{@"name":@"subObject", @"price": @(12341234)}], @"subJson":@{@"name":@"subObject", @"price": @(12341234)}, @"_readonly":@"testReadOnly"};
    
    JSONObject2 *object = [[[JSONObject2 alloc] initWithJsonDictionary:dic] autorelease];
    
    XCTAssert([object.name isEqualToString:@"testJsonObject"], @"name error");
    XCTAssert(object.price == 1000, @"price error");
    XCTAssert([object.dic count] == 2, @"dic error");
    XCTAssert([object.items count] == 1, @"items error");
    XCTAssert([[object.items firstObject] isKindOfClass:[JSONObject class]], @"item type error");
    XCTAssert(object.subJson, @"subjson error");
    XCTAssert(object.readOnly == nil, @"readOnly error");
    
    object->_readOnly           = @"readOnly";
    
    NSDictionary *json = [object toJsonDictionary];
    
    NSLog(@"测试成功");
}

@end
