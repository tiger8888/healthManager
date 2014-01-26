//
//  SessionMessageSqlite.h
//  HealthManager
//
//  Created by user on 14-1-26.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SessionMessage.h"

@interface SessionMessageSqlite : NSObject
{
    sqlite3 *_db;
}

+ (SessionMessageSqlite *)sharedManager;
- (void)insertOne:(SessionMessage *)msg;
- (NSArray *)queryAll;
- (void)closeDB;
@end
