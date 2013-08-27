//
//  IMDbBase.m
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "IMDbBase.h"



@implementation IMDbBase

// 读取表名
- (NSString *)getTableName
{
    return nil;
}

// 读取字段
- (NSString *)getTableArguments
{
    return nil;
}

// 创建表
- (BOOL) createTable
{
    return NO;
}

// 删除表
- (void) deleteTable{}

// 清除表
- (void) eraseTable{}

// 插入表
- (void) insertTable{}

// 更新表
- (void) updateTable{}

// 获取表数据
- (FMResultSet *) findData
{
    return nil;
}



@end
