//
//  SessionMessageSqlite.m
//  HealthManager
//
//  Created by user on 14-1-26.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "SessionMessageSqlite.h"

static SessionMessageSqlite *_sharedManager;

@implementation SessionMessageSqlite

+ (SessionMessageSqlite *)sharedManager {
    if (!_sharedManager)
    {
        _sharedManager = [[SessionMessageSqlite alloc] init];
    }
    
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        [self openDB];
        [self CreateTable];
    }
    
    return self;
}
- (void)openDB {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *dbFilePath = [cacheDirectory stringByAppendingString:@"/health"];
    NSLog(@"dfFilePath is :%@", dbFilePath);
    
    if (sqlite3_open([dbFilePath UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSAssert(0, @"open database failed!");
    }
}

- (void)CreateTable {
    NSString *sql_create = @"create table if not exists sessionmessage(id integer primary key, senderId integer, senderName text, sendType integer,doctorId integer, patientId integer, timeStamp text, content text);";
    
    char *errorMsg;
    if (sqlite3_exec(_db, [sql_create UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(_db);
        NSAssert(0, @"create table error: %s", errorMsg);
    }
}

- (void)insertOne:(SessionMessage *)msg {
    char *sql_insert = "insert or replace into sessionmessage(senderId, senderName, content, sendType, timeStamp, doctorId, patientId) values(?,?,?,?,?,?,?)";
//    NSLog(@"insert one recorder. sql:%s", sql_insert);
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, sql_insert, -1, &stmt, nil) == SQLITE_OK) {
//        NSLog(@"insert content=%s",[msg.content UTF8String]);
        if (sqlite3_bind_int(stmt, 1, msg.senderId) != SQLITE_OK) {
            NSLog(@"sqlite bind senderId error.");
        }
        if (sqlite3_bind_text(stmt, 2, [msg.senderName UTF8String], -1, NULL) != SQLITE_OK) {            NSLog(@"sqlite bind senderName error.");
        }
        if (sqlite3_bind_text(stmt, 3, [msg.content UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"sqlite bind content error.");
        }
        if (sqlite3_bind_int(stmt, 4, msg.sendType) != SQLITE_OK) {
            NSLog(@"sqlite bind sendType error.");
        }
        if (sqlite3_bind_text(stmt, 5, [msg.timeStamp UTF8String], -1, NULL) != SQLITE_OK) {
            NSLog(@"sqlite bind timeStamp error.");
        }
        if (sqlite3_bind_int(stmt, 6, msg.doctorId) != SQLITE_OK) {
            NSLog(@"sqlite bind timeStamp error.");
        }
        if (sqlite3_bind_int(stmt, 7, msg.patientId) != SQLITE_OK) {
            NSLog(@"sqlite bind timeStamp error.");
        }
    }
    else {
        NSLog(@"sqlite prepare stmt error");
    }
    
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSAssert(0, @"insert data error:%s", sqlite3_errmsg(_db));
    }
    
    sqlite3_finalize(stmt);
}

- (NSArray *)queryAll:(int)doctorId withPatientId:(int)patientId {
    NSMutableArray *result = [NSMutableArray new];
    SessionMessage *sessionMsg = [SessionMessage new];
    
    NSMutableString *sql_queryAll = [NSMutableString new];
    [sql_queryAll appendString:@"select id, senderId, senderName, content, sendType, timeStamp, doctorId, patientId from sessionmessage where content!='' "];
    if ( doctorId > 0 && patientId > 0) {
        
        [sql_queryAll appendString:[NSString stringWithFormat:@" and (doctorId=%d and patientId=%d)", doctorId, patientId]];
    }
    [sql_queryAll appendString:@" order by timeStamp"];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, [sql_queryAll UTF8String], -1, &stmt, nil) == SQLITE_OK) {
//        NSLog(@"sqlite prepare v2");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
//            NSLog(@"table field value is %d", sqlite3_column_int(stmt, 0));
            sessionMsg.id = sqlite3_column_int(stmt, 0);
            sessionMsg.senderId = sqlite3_column_int(stmt, 1);
            sessionMsg.senderName =  [[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(stmt, 2)];
            char *content = (char *)sqlite3_column_text(stmt, 3);
//            NSLog(@"content = %s",content);
            sessionMsg.content =  [[NSString alloc] initWithUTF8String: content?content:""];
            sessionMsg.sendType = sqlite3_column_int(stmt, 4);
            sessionMsg.timeStamp =  [[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(stmt, 5)];
            sessionMsg.doctorId = sqlite3_column_int(stmt, 6);
            sessionMsg.patientId = sqlite3_column_int(stmt, 7);
            
            [result addObject:[sessionMsg copy]];
        }
        
        sqlite3_finalize(stmt);
    }
    sessionMsg = NULL;
//    NSLog(@"QUERY ALL OVER");
    return result;
}

- (void)closeDB {
    sqlite3_close(_db);
}
@end
