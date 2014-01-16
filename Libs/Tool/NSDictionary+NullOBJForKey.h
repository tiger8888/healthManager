//
//  NSDictionary+NullOBJForKey.h
//  ITBook2.0
//
//  Created by LiShuo on 13-12-20.
//  Copyright (c) 2013年 com.firstde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullOBJForKey)

- (id)categoryObjectForKey:(id)aKey;

@end

@interface NSMutableDictionary (NullOBJForKey)

- (void)categorySetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end