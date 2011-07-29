//
//  RKDynamicObjectMappingSpec.m
//  RestKit
//
//  Created by Blake Watters on 7/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "RKSpecEnvironment.h"
#import "RKDynamicObjectMapping.h"
#import "RKDynamicMappingModels.h"

@interface RKDynamicObjectMappingSpec : RKSpec <RKDynamicObjectMappingDelegate>

@end

@implementation RKDynamicObjectMappingSpec

- (void)itShouldPickTheAppropriateMappingBasedOnAnAttributeValue {
    RKDynamicObjectMapping* dynamicMapping = [RKDynamicObjectMapping dynamicMapping];
    RKObjectMapping* girlMapping = [RKObjectMapping mappingForClass:[Girl class] block:^(RKObjectMapping* mapping) {
        [mapping mapAttributes:@"name", nil];
    }];
    RKObjectMapping* boyMapping = [RKObjectMapping mappingForClass:[Boy class] block:^(RKObjectMapping* mapping) {
        [mapping mapAttributes:@"name", nil];
    }];
    [dynamicMapping setObjectMapping:girlMapping whenValueOfKey:@"type" isEqualTo:@"Girl"];
    [dynamicMapping setObjectMapping:boyMapping whenValueOfKey:@"type" isEqualTo:@"Boy"];
    RKObjectMapping* mapping = [dynamicMapping objectMappingForData:RKSpecParseFixture(@"girl.json")];
    assertThat(mapping, is(notNilValue()));
    assertThat(NSStringFromClass(mapping.objectClass), is(equalTo(@"Girl")));
    mapping = [dynamicMapping objectMappingForData:RKSpecParseFixture(@"boy.json")];
    assertThat(mapping, is(notNilValue()));
    assertThat(NSStringFromClass(mapping.objectClass), is(equalTo(@"Boy")));
}

// TODO: Add cases for NSNumber, NSDate, etc...

- (void)itShouldPickTheAppropriateMappingBasedOnDelegateCallback {
    RKDynamicObjectMapping* dynamicMapping = [RKDynamicObjectMapping dynamicMapping];
    dynamicMapping.delegate = self;
    RKObjectMapping* mapping = [dynamicMapping objectMappingForData:RKSpecParseFixture(@"girl.json")];
    assertThat(mapping, is(notNilValue()));
    assertThat(NSStringFromClass(mapping.objectClass), is(equalTo(@"Girl")));
    mapping = [dynamicMapping objectMappingForData:RKSpecParseFixture(@"boy.json")];
    assertThat(mapping, is(notNilValue()));
    assertThat(NSStringFromClass(mapping.objectClass), is(equalTo(@"Boy")));
}

- (void)itShouldPickTheAppropriateMappingBasedOnBlockDelegateCallback {
    RKDynamicObjectMapping* dynamicMapping = [RKDynamicObjectMapping dynamicMapping];
    dynamicMapping.delegateBlock = ^ RKObjectMapping* (id data) {
        if ([[data valueForKey:@"type"] isEqualToString:@"Girl"]) {
            return [RKObjectMapping mappingForClass:[Girl class] block:^(RKObjectMapping* mapping) {
                [mapping mapAttributes:@"name", nil];
            }];
        } else if ([[data valueForKey:@"type"] isEqualToString:@"Boy"]) {
            return [RKObjectMapping mappingForClass:[Boy class] block:^(RKObjectMapping* mapping) {
                [mapping mapAttributes:@"name", nil];
            }];
        }
        
        return nil;
    };
    RKObjectMapping* mapping = [dynamicMapping objectMappingForData:RKSpecParseFixture(@"girl.json")];
    assertThat(mapping, is(notNilValue()));
    assertThat(NSStringFromClass(mapping.objectClass), is(equalTo(@"Girl")));
    mapping = [dynamicMapping objectMappingForData:RKSpecParseFixture(@"boy.json")];
    assertThat(mapping, is(notNilValue()));
    assertThat(NSStringFromClass(mapping.objectClass), is(equalTo(@"Boy")));
}

// TODO: It should blow up when invoked with a collection?

#pragma mark - RKDynamicObjectMappingDelegate

- (RKObjectMapping*)objectMappingForData:(id)data {
    if ([[data valueForKey:@"type"] isEqualToString:@"Girl"]) {
        return [RKObjectMapping mappingForClass:[Girl class] block:^(RKObjectMapping* mapping) {
            [mapping mapAttributes:@"name", nil];
        }];
    } else if ([[data valueForKey:@"type"] isEqualToString:@"Boy"]) {
        return [RKObjectMapping mappingForClass:[Boy class] block:^(RKObjectMapping* mapping) {
            [mapping mapAttributes:@"name", nil];
        }];
    }
    
    return nil;
}

@end
