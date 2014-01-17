//
//  NSDictionary+NullOBJForKey.m
//  ITBook2.0
//
//  Created by LiShuo on 13-12-20.
//  Copyright (c) 2013年 com.firstde. All rights reserved.
//

#import "NSDictionary+NullOBJForKey.h"

@implementation NSDictionary (NullOBJForKey)

- (id)categoryObjectForKey:(id)aKey
{
    id dics = [self objectForKey:aKey];
    if ( ![dics isKindOfClass:[NSNull class]] && ![dics isEqual:@"<null>"]){
        return dics;
    }
    return nil;
}
@end


@implementation NSMutableDictionary (NullOBJForKey)
- (void)categorySetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if ( anObject == nil || [anObject isEqual:@""] ) {
        [self setObject:[NSNull null] forKey:aKey];
    }
    else{
        [self setObject:anObject forKey:aKey];
    }
}
@end