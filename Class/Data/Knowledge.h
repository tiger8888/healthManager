//
//  Knowledge.h
//  HealthManager
//
//  Created by PanPeng on 14-1-7.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Knowledge : NSObject<NSCopying>
@property (nonatomic) int id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

- (id)initWithId:(int)knowledgeId withTitle:(NSString *)knowledgeTitle withContent:(NSString *)knowledgeContent;
@end
