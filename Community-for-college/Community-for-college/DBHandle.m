//
//  DBHandle.m
//  Community-for-college
//
//  Created by lanou3g on 16/8/15.
//  Copyright © 2016年 彭鑫. All rights reserved.
//

#import "DBHandle.h"
#import <sqlite3.h>

@interface DBHandle ()

@property (strong , nonatomic) NSString *dbPath;
@end

@implementation DBHandle

- (NSString *)dbPath{
    if (_dbPath == nil) {
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        _dbPath = [document stringByAppendingString:@"/Community-for-college.sqlite"];
        NSLog(@"%@",_dbPath);
    }
    return _dbPath;
}

+ (DBHandle *)sharedDBHandle
{
    static DBHandle *dbhandle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dbhandle == nil) {
            dbhandle = [[DBHandle alloc]init];
        }
    });
    return dbhandle;
}

static sqlite3 *db = nil;

- (void)openDB
{
    BOOL result = sqlite3_open(self.dbPath.UTF8String, &db);
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
}

- (void)closeDB
{
    BOOL result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        NSLog(@"关闭数据库成功");
    }else{
        NSLog(@"关闭数据库失败");
    }
}

#pragma mark --- BoyBooks

- (void)createBoyBooks
{
    NSString *sqlsString = @"create table if not exists BoyBooks(nid text primary key not null,name text,classes text, desc text,lastChapterName text,imgUrl text,author text)";
    int result = sqlite3_exec(db, sqlsString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"建表成功");
    }else{
        NSLog(@"建表失败");
    }
}



- (void)insertWithBoyBooksnid:(NSString *)nid Name:(NSString *)name classes:(NSString *)classes desc:(NSString *)desc lastChapterName:(NSString *)lastChapterName imgUrl:(NSString *)imgUrl author:(NSString *)author
{
    NSString *sqlString = [NSString stringWithFormat:@"insert into BoyBooks(nid,name,classes,desc,lastChapterName,imgUrl,author)values('%@','%@','%@','%@','%@','%@','%@')",nid,name,classes,desc,lastChapterName,imgUrl,author];
    int result = sqlite3_exec(db, sqlString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
}




- (BOOL)searchWithBoynid:(NSString *)nid
{
    NSString *sqlString = [NSString stringWithFormat:@"select * from BoyBooks where nid = %@",nid];
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    
    BOOL tag = 0;
    
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            tag = 1;
        }
    }else{
        NSLog(@"查询失败%d",result);
    }
    sqlite3_finalize(stmt);
    
    return tag;
}

- (NSMutableArray *)searBoyBooks
{
    NSString *sqlString = @"select * from BoyBooks";
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    NSMutableArray *array = [NSMutableArray array];
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *nid = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *classes = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            NSString *desc = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            NSString *lastChapterName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            NSString *imgUrl = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            NSString *author = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];

            NSDictionary *dic = @{@"nid":nid,@"name":name,@"classes":classes,@"desc":desc,@"lastChapterName":lastChapterName,@"imgUrl":imgUrl,@"author":author,};
            [array addObject:dic];
            
        }
    }
    sqlite3_finalize(stmt);
    

    return array;
}




- (void)deleteWitBoynid:(NSString *)nid
{
    NSString *sqlString = [NSString stringWithFormat:@"delete from BoyBooks where nid = %@",nid];
    int result = sqlite3_exec(db, sqlString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    
    
}

#pragma mark --- GirlBooks


- (void)createGirlBooks
{
    NSString *sqlsString = @"create table if not exists GirlBooks(nid text primary key not null,name text,classes text, desc text,lastChapterName text,imgUrl text,author text)";
    int result = sqlite3_exec(db, sqlsString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"建表成功");
    }else{
        NSLog(@"建表失败");
    }
}

- (void)insertWithGirlBooksnid:(NSString *)nid Name:(NSString *)name classes:(NSString *)classes desc:(NSString *)desc lastChapterName:(NSString *)lastChapterName imgUrl:(NSString *)imgUrl author:(NSString *)author
{
    NSString *sqlString = [NSString stringWithFormat:@"insert into GirlBooks(nid,name,classes,desc,lastChapterName,imgUrl,author)values('%@','%@','%@','%@','%@','%@','%@')",nid,name,classes,desc,lastChapterName,imgUrl,author];
    int result = sqlite3_exec(db, sqlString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
}

- (BOOL)searchWithGirlnid:(NSString *)nid
{
    NSString *sqlString = [NSString stringWithFormat:@"select * from BoyBooks where nid = %@",nid];
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    
    BOOL tag = 0;
    
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            tag = 1;
        }
    }else{
        NSLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    
    return tag;
}


- (NSMutableArray *)searGirlBooks
{
    NSString *sqlString = @"select * from GirlBooks";
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    NSMutableArray *array = [NSMutableArray array];
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *nid = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *classes = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            NSString *desc = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            NSString *lastChapterName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            NSString *imgUrl = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            NSString *author = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
            
            NSDictionary *dic = @{@"nid":nid,@"name":name,@"classes":classes,@"desc":desc,@"lastChapterName":lastChapterName,@"imgUrl":imgUrl,@"author":author,};
            [array addObject:dic];
            
        }
    }
    sqlite3_finalize(stmt);
    
    
    return array;
}


- (void)deleteWitGirlnid:(NSString *)nid
{
    NSString *sqlString = [NSString stringWithFormat:@"delete from GirlBooks where nid = %@",nid];
    int result = sqlite3_exec(db, sqlString.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    
    
}




@end
