//
//  DialogueMasterBL.h
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogueMaster.h"


@interface DialogueMasterBL : NSObject


// 创建聊天记录
- (NSMutableArray *) createDialogue:(DialogueMaster *) dialogueModel;


// 查询聊天记录
- (NSMutableArray *) findAllDialogue;


// 根据JID,读取聊天ID
- (NSUInteger) findIDWithJID:(NSString *)strJID;

// 根据JID判断有无重复记录
- (BOOL) checkDataWithJID:(NSString *)strJID;

@end
