//
//  RKDynamicObjectMapping.m
//  RestKit
//
//  Created by Blake Watters on 7/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "RKDynamicObjectMapping.h"

@interface RKDynamicObjectMappingMatcher : NSObject {
    NSString* _key;
    id _value;
    RKObjectMapping* _objectMapping;
}

@property (nonatomic, readonly) RKObjectMapping* objectMapping;

- (id)initWithKey:(NSString*)key value:(id)value objectMapping:(RKObjectMapping*)objectMapping;
- (BOOL)isMatchForData:(id)data;

@end

@implementation RKDynamicObjectMappingMatcher

@synthesize objectMapping = _objectMapping;

- (id)initWithKey:(NSString*)key value:(id)value objectMapping:(RKObjectMapping*)objectMapping {
    self = [super init];
    if (self) {
        _key = [key retain];
        _value = [value retain];
        _objectMapping = [objectMapping retain];
    }
    
    return self;
}

- (void)dealloc {
    [_key release];
    [_value release];
    [_objectMapping release];
    [super dealloc];
}

- (BOOL)isMatchForData:(id)data {
    // TODO: Need to move the flexible comparison used in RKObjectMappingOperation into a reusable place
    return [[data valueForKey:_key] isEqualToString:_value];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation RKDynamicObjectMapping

@synthesize delegate = _delegate;
@synthesize delegateBlock = _delegateBlock;

+ (RKDynamicObjectMapping*)dynamicMapping {
    return [[self new] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
        _matchers = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc {
    [_matchers release];
    [super dealloc];
}

- (void)setObjectMapping:(RKObjectMapping*)objectMapping whenValueOfKey:(NSString*)key isEqualTo:(id)value {
    RKDynamicObjectMappingMatcher* matcher = [[RKDynamicObjectMappingMatcher alloc] initWithKey:key value:value objectMapping:objectMapping];
    [_matchers addObject:matcher];
    [matcher release];
}

- (RKObjectMapping*)objectMappingForData:(id)data {
    RKObjectMapping* mapping = nil;
    
    // Consult the declarative matchers first
    for (RKDynamicObjectMappingMatcher* matcher in _matchers) {
        if ([matcher isMatchForData:data]) {
            return matcher.objectMapping;
        }
    }
    
    // Otherwise consult the delegates
    if (self.delegate) {
        mapping = [self.delegate objectMappingForData:data];
        if (mapping) {
            // TODO: Logging
            return mapping;
        }
    }
    
    if (self.delegateBlock) {
        mapping = self.delegateBlock(data);
    }
    
    return mapping;
}

// TODO: Would you ever want to force a dynamic mapping???
- (BOOL)forceCollectionMapping {
    return NO;
}

@end
