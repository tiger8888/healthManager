//
//  KnowledgeStore.m
//  HealthManager
//
//  Created by user on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "KnowledgeStore.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "Knowledge.h"

@implementation KnowledgeStore

+ (KnowledgeStore *)sharedStore {
    static KnowledgeStore *knowledgeStore = nil;
    if (!knowledgeStore) {
        knowledgeStore = [KnowledgeStore new];
    }
    return knowledgeStore;
}

- (void)fetchTopInfo:(int)count withCompletion:(void (^)(NSMutableArray *obj, NSError *err))block {
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://172.19.7.43:8080/BloodPressure/health"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs/limit=%d/json", count]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *result = (NSArray *)[[JSON objectForKey:@"feed"] objectForKey:@"entry"];
        NSMutableArray *knowledgeArr = [NSMutableArray new];
        int resultCount = (int)[result count];
        
        for (int i=0; i < resultCount; i++) {
            Knowledge *knowledge = [Knowledge new];
            [knowledge setTitle:[[[result objectAtIndex:i] objectForKey:@"im:name"] objectForKey:@"label"]];
            [knowledge setId:(int)[[[[result objectAtIndex:i] objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"] ];
            [knowledge setContent:[[[result objectAtIndex:i] objectForKey:@"im:name"] objectForKey:@"label"]];
            [knowledgeArr addObject:knowledge];
        }
        
        block(knowledgeArr, NULL);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@",error);
    }];
    [operation start];
}

- (void)fetchTopwithCompletion:(void (^)(NSMutableArray *obj, NSError *err))block {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mobile.9500.cn/95app/xiaotieshi/getxiaotieshilistmore.jsp?type=iphone"]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSArray *result = (NSArray *)[JSON objectForKey:@"xiaotieshi"];
        NSMutableArray *knowledgeArr = [NSMutableArray new];
        
        if ( result ) {
            int resultCount = (int)[result count];
            
            for (int i=0; i < resultCount; i++) {
                Knowledge *knowledge = [Knowledge new];
                [knowledge setUrl:[[result objectAtIndex:i] objectForKey:@"url"]];
                [knowledge setTitle:[[result objectAtIndex:i] objectForKey:@"title"]];
                [knowledgeArr addObject:knowledge];
            }
        }
        block(knowledgeArr, NULL);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", response);
        NSLog(@"=====");
        NSLog(@"%@",error);
    }];
    [operation start];
}

- (void)fetchDetailInfo:(NSString *)url withCompletion:(void (^)(NSMutableArray *obj, NSError *err))block {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
//        NSArray *result = (NSArray *)[JSON objectForKey:@"xiaotieshi"];
//        NSMutableArray *knowledgeArr = [NSMutableArray new];
//        
//        if ( result ) {
//            int resultCount = (int)[result count];
//            
//            for (int i=0; i < resultCount; i++) {
//                Knowledge *knowledge = [Knowledge new];
//                [knowledge setUrl:[[result objectAtIndex:i] objectForKey:@"url"]];
//                [knowledge setTitle:[[result objectAtIndex:i] objectForKey:@"title"]];
//                [knowledgeArr addObject:knowledge];
//            }
//        }
//        block(knowledgeArr, NULL);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", response);
        NSLog(@"=====");
        NSLog(@"%@",error);
    }];
    [operation start];
}
@end
