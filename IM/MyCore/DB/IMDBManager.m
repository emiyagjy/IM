//
//  IMDBManager.m
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "IMDBManager.h"


@interface IMDBManager()

// 读取数据保存的路径
- (NSString *)getPath:(NSString *)dbName;

@end

@implementation IMDBManager

@synthesize DBNamePath=_DBNamePath;
@synthesize DB=_DB;

static IMDBManager *sharedManager;

+(IMDBManager*)sharedInstance{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager=[[IMDBManager alloc] initWithDBName:@"IM.db"];
           [sharedManager readyDatabse];
    });
    
 
    
    return sharedManager;
    //return nil;
}

#pragma mark Private Methods 

// 数据库存储路径(内部使用)
- (NSString *)getPath:(NSString *)dbName
{
    return [kDocumentFolder stringByAppendingPathComponent:dbName];
}

- (id)initWithDBName:(NSString *)dbName
{
    self = [super init];
    if(self)
    {
        _DBNamePath = [self getPath:dbName];
        LOG(@"DBName: %@", _DBNamePath);
    }
    
    return self;
}

// 打开数据库
- (void)readyDatabse
{
    BOOL success;
    //NSError *error;
    
    //DB = [FMDatabase databaseWithPath:DBName];
    _DB = [[FMDatabase alloc] initWithPath:_DBNamePath];
    if (![_DB open])
    {
        [_DB close];
        NSAssert1(0, @"Failed to open database file with message '%@'.", [_DB lastErrorMessage]);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:_DBNamePath];
    
    if (success)
        return;
    

    
    // kind of experimentalish.
    [_DB setShouldCacheStatements:YES];
}


// 删除数据库
- (void)deleteDatabse
{
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // delete the old db.
    if ([fileManager fileExistsAtPath:_DBNamePath])
    {
        [_DB close];
        success = [fileManager removeItemAtPath:_DBNamePath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
}

// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [_DB executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        LOG(@"isTableOK %d", count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

// 获得表的数据条数
- (BOOL) getTableItemCount:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *rs = [_DB executeQuery:sqlstr];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        LOG(@"TableItemCount %d", count);
        
        return count;
    }
    
    return 0;
}

// 创建表
- (BOOL) createTable:(NSString *)tableName withArguments:(NSString *)arguments
{
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];
    if (![_DB executeUpdate:sqlstr])
        //if ([DB executeUpdate:@"create table user (name text, pass text)"] == nil)
    {
        LOG(@"Create db error!");
        return NO;
    }
    
    return YES;
}


// 删除表
- (BOOL) deleteTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![_DB executeUpdate:sqlstr])
    {
        LOG(@"Delete table error!");
        return NO;
    }
    
    return YES;
}

// 清除表
- (BOOL) eraseTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![_DB executeUpdate:sqlstr])
    {
        LOG(@"Erase table error!");
        return NO;
    }
    
    return YES;
}

// 插入数据
- (BOOL)insertTable:(NSString*)sql, ...
{
    va_list args;
    va_start(args, sql);
    
    BOOL result = [_DB executeUpdate:sql];
    
    va_end(args);
    return result;
}

// 修改数据
- (BOOL)updateTable:(NSString*)sql, ...
{
    va_list args;
    va_start(args, sql);
    
    BOOL result = [_DB executeUpdate:sql];
    
    va_end(args);
    return result;
}


#pragma mark 获得所有数据

- (FMResultSet *) getDb_AllData:(NSString *)tableName withCondition:(NSString *) condition
{
    NSString *sql=nil;
    if (!condition) {
        sql=[NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    }else{
        sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",tableName,condition];
    }
    
    FMResultSet *resultSet =[_DB executeQuery:sql];
    LOG(@"resultSet IS %@",resultSet);
    
    return resultSet;
}

#pragma mark 判断是否存在相同的数据

- (NSUInteger) checkTableData:(NSString *)tableName withCondition:(NSString *)strCondition
{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@ WHERE %@", tableName,strCondition];
    FMResultSet *rs = [_DB executeQuery:sqlstr];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        LOG(@"TableItemCount %d", count);
        return count;
    }
    
    return 0;
}


// 暂时无用
#pragma mark 获得单一数据

// 整型
- (NSInteger)getDb_Integerdata:(NSString *)tableName withFieldName:(NSString *)fieldName
{
    NSInteger result = NO;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [_DB executeQuery:sql];
    if ([rs next])
        result = [rs intForColumnIndex:0];
    [rs close];
    
    return result;
}

// 布尔型
- (BOOL)getDb_Booldata:(NSString *)tableName withFieldName:(NSString *)fieldName
{
    BOOL result;
    
    result = [self getDb_Integerdata:tableName withFieldName:fieldName];
    
    return result;
}

// 字符串型
- (NSString *)getDb_Stringdata:(NSString *)tableName withFieldName:(NSString *)fieldName
{
    NSString *result = NO;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [_DB executeQuery:sql];
    if ([rs next])
        result = [rs stringForColumnIndex:0];
    [rs close];
    
    return result;
}

// 二进制数据型
- (NSData *)getDb_Bolbdata:(NSString *)tableName withFieldName:(NSString *)fieldName
{
    NSData *result = NO;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [_DB executeQuery:sql];
    if ([rs next])
        result = [rs dataForColumnIndex:0];
    [rs close];
    
    return result;
}


@end
