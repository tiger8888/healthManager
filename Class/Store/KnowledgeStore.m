//
//  KnowledgeStore.m
//  HealthManager
//
//  Created by user on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "KnowledgeStore.h"
#import "af'

@implementation KnowledgeStore

+ (KnowledgeStore *)sharedStore {
    static KnowledgeStore *knowledgeStore = nil;
    if (!knowledgeStore) {
        knowledgeStore = [KnowledgeStore new];
    }
    return knowledgeStore;
}

- (void)fetchTopInfo:(int)count withCompletion:(void (^)(KnowledgeStore *obj, NSError *err))block {
    
}
@end
