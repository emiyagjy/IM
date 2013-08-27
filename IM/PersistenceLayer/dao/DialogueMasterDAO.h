//
//  DialogueMasterDAO.h
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMDBDialogueMaster.h"

@interface DialogueMasterDAO : NSObject

// 保存数据列表
@property (nonatomic,strong) NSMutableArray *listData;

// 数据库
@property (nonatomic,strong) IMDBDialogueMaster *dbDialogueMaster;

+(DialogueMasterDAO*)sharedManager;


// 保存聊天数据
- (int) create:(DialogueMaster*) model;

// 移除聊天数据
- (int) deleteWithName:(NSString *) strName;

// 根据JID,读取聊天ID
- (NSUInteger) findID:(NSString *) strJID;

// 根据JID判断有无重复记录
- (BOOL) checkDataWithJID:(NSString *)strJID;

//查询所有数据方法
- (NSMutableArray*) findAll;



@end
