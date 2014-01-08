//
//  KnowledgeStore.h
//  HealthManager
//
//  Created by user on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowledgeStore : NSObject

+ (KnowledgeStore *)sharedStore;

- (void)fetchTopInfo:(int)count withCompletion:(void (^)(NSMutableArray *obj, NSError *err))block;
@end
