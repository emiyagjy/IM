//
//  IMDBDialogueDetail.m
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "IMDBDialogueDetail.h"

/*
 表名 :CHATDETAIL 子聊天记录
 字段1:ID   主键
 字段2:PARENTID 主列表的id
 字段3:MESSAGE  消息
 字段4:STATUS   消息状态
       0. receive  1. send
 字段5:DATE 聊天时间，精确到分钟
 字段6:LOOKSTATUS 内容是否被浏览过
 字段7:COMMENT 冗余字段
 字段8:TAG  删除标记
 
 */

@implementation IMDBDialogueDetail
@synthesize dialogue=_dialogue;



// 读取表名
- (NSString *)getTableName
{
    return @"CHATDETAIL";
}

// 读取建表字段
- (NSString *)getTableArguments
{
    return @"ID INTEGER PRIMARY KEY AUTOINCREMENT,PARENTID INTEGER,MESSAGE TEXT,STATUS INTEGER,DATE TEXT,LOOKSTATUS,COMMENT TEXT,TAG INTEGER";
}


// 创建表
- (BOOL) createTable
{
    IMDBManager *dbManager=[IMDBManager sharedInstance];
    
    NSString *strTable=[NSString stringWithFormat:@"%@ %@",@"IF NOT EXISTS",[self getTableName]];
    NSString *strArguments=[self getTableArguments];
    
    BOOL result=[dbManager createTable:strTable withArguments:strArguments];
    
    return result;
    
    
}

// 插入表
- (void) insertTable
{
    if (_dialogue) {
        IMDBManager *dbManager=[IMDBManager sharedInstance];
        NSString *strSql=[NSString stringWithFormat:@"INSERT INTO %@(PARENTID,MESSAGE,STATUS,DATE,LOOKSTATUS,COMMENT,TAG) VALUES(%d,\"%@\",%d,\"%@\",%d,\"%@\",%d)",[self getTableName],_dialogue.m_parentID,_dialogue.m_Message,_dialogue.m_Status,_dialogue.m_Date,_dialogue.m_lookStatus,@"",0];
        [dbManager insertTable:strSql];
        
    }
}

// 获取表数据
- (FMResultSet *) findData
{
    IMDBManager *dbManager=[IMDBManager sharedInstance];
    return [dbManager getDb_AllData:[self getTableName] withCondition:nil];
}

// 根据聊天列表主ID 获取表数据
- (FMResultSet *) findDataWithID:(NSUInteger) parentID
{
    IMDBManager *dbManager=[IMDBManager sharedInstance];
    
    NSString *strCondition=[NSString stringWithFormat:@"%@%d",@"PARENTID=",parentID];
    
    return [dbManager getDb_AllData:[self getTableName] withCondition:strCondition];
}

// 获取所有 未查看聊天明细的数量
- (NSUInteger) findQuantityWithNolooking
{
    IMDBManager *dbManager=[IMDBManager sharedInstance];
    NSString *strCondition=[NSString stringWithFormat:@"%@%d",@"LOOKSTATUS=",IMDialogueDNolooking];
    
    NSUInteger c=[dbManager checkTableData:[self getTableName] withCondition:strCondition];
    return c;
}

@end











