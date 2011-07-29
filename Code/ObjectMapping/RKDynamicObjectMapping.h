//
//  RKDynamicObjectMapping.h
//  RestKit
//
//  Created by Blake Watters on 7/28/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "RKObjectMapping.h"

/**
 Return the appropriate object mapping given a mappable data
 */
@protocol RKDynamicObjectMappingDelegate <NSObject>

@required
- (RKObjectMapping*)objectMappingForData:(id)data;

@end

#ifdef NS_BLOCKS_AVAILABLE
typedef RKObjectMapping*(^RKDynamicObjectMappingDelegateBlock)(id);
#endif

@interface RKDynamicObjectMapping : NSObject {
    NSMutableArray* _matchers;
    id<RKDynamicObjectMappingDelegate> _delegate;
    #ifdef NS_BLOCKS_AVAILABLE
    RKDynamicObjectMappingDelegateBlock _delegateBlock;
    #endif
}

@property (nonatomic, assign) id<RKDynamicObjectMappingDelegate> delegate;

#ifdef NS_BLOCKS_AVAILABLE
@property (nonatomic, copy) RKDynamicObjectMappingDelegateBlock delegateBlock;
#endif

+ (RKDynamicObjectMapping*)dynamicMapping;

- (void)setObjectMapping:(RKObjectMapping*)objectMapping whenValueOfKey:(NSString*)key isEqualTo:(id)value;

- (RKObjectMapping*)objectMappingForData:(id)data;

@end
