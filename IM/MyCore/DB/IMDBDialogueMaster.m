//
//  IMDBDialogueMaster.m
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//


/*
 表名 :CHATMASTER 主聊天记录
 字段1:ID   主键
 字段2:JID  消息来源
 字段3:NAME 名称
 字段4:IP   域名地址
 字段5:DATE 聊天时间，精确到天
 字段6:STATUS
    1.访客主动发来的对话信息
    2.已建立连接的对话信息
    3.历史对话信息
 字段6:COMMENT 荣誉字段
 字段7:TAG  删除标记
 */

#import "IMDBDialogueMaster.h"

@implementation IMDBDialogueMaster
@synthesize dialogue=_dialogue;


// 读取表名
- (NSString *)getTableName
{
    return @"CHATMASTER";
}

// 读取建表字段
- (NSString *)getTableArguments
{
    return @"ID INTEGER PRIMARY KEY AUTOINCREMENT,JID TEXT,NAME TEXT,IP TEXT,DATE TEXT,STATUS INTEGER,COMMENT TEXT,TAG INTEGER";
}

// 创建表
- (BOOL) createTable
{
    IMDBManager *dbManager=[IMDBManager sharedInstance];
    
    NSString *strTable=[NSString stringWithFormat:@"%@ %@",@"IF NOT EXISTS",[self getTableName]];
    NSString *strArguments=[self getTableArguments];
    
    return [dbManager createTable:strTable withArguments:strArguments];
  
}

// 插入表
- (void) insertTable
{
    if (_dialogue) {
        IMDBManager *dbManager=[IMDBManager sharedInstance];
        
        NSString *strSql=[NSString stringWithFormat:@"INSERT INTO %@(JID,NAME,IP,DATE,STATUS,COMMENT,TAG) VALUES(\"%@\",\"%@\",\"%@\",\"%@\",%d,\"%@\",%d)",[self getTableName],_dialogue.m_JID,@"",_dialogue.m_IP,_dialogue.m_Date,_dialogue.m_Status,@"",0];
        [dbManager insertTable:strSql];
    
    }
}



// 获取表数据
- (FMResultSet *) findData
{
    IMDBManager *dbManager=[IMDBManager sharedInstance];
    
    FMResultSet *resultSet=[dbManager getDb_AllData:[self getTableName] withCondition:nil];
    return resultSet;
}


// 根据条件判断数据是否重复
- (BOOL) checkData:(NSString *)strCondition
{
    IMDBManager *dbManager=[IMDBManager sharedInstance];
    return [dbManager checkTableData:[self getTableName] withCondition:strCondition];
}






@end
