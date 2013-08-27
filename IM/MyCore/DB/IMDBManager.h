//
//  IMDBManager.h
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"


@interface IMDBManager : NSObject


@property (retain, nonatomic) FMDatabase *DB;
@property (retain, nonatomic) NSString *DBNamePath;


+(IMDBManager*)sharedInstance;

// 实例化
- (id)initWithDBName:(NSString *)dbName;

// 删除数据库
- (void)deleteDatabse;

// 打开数据库
- (void)readyDatabse;

// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName;
// 获得表的数据条数
- (BOOL) getTableItemCount:(NSString *)tableName;
// 创建表
- (BOOL) createTable:(NSString *)tableName withArguments:(NSString *)arguments;
// 删除表-彻底删除表
- (BOOL) deleteTable:(NSString *)tableName;
// 清除表-清数据
- (BOOL) eraseTable:(NSString *)tableName;
// 插入数据
- (BOOL)insertTable:(NSString*)sql, ...;
// 修改数据
- (BOOL)updateTable:(NSString*)sql, ...;


#pragma mark 获得所有数据

- (FMResultSet *) getDb_AllData:(NSString *)tableName withCondition:(NSString *) condition;

#pragma mark 判断是否存在相同的数据

- (NSUInteger) checkTableData:(NSString *)tableName withCondition:(NSString *)strCondition;

#pragma mark 获得单一数据

// 整型
- (NSInteger)getDb_Integerdata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 布尔型
- (BOOL)getDb_Booldata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 字符串型
- (NSString *)getDb_Stringdata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 二进制数据型
- (NSData *)getDb_Bolbdata:(NSString *)tableName withFieldName:(NSString *)fieldName;

@end
