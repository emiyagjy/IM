//
//  DialogueMasterBL.m
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "DialogueMasterBL.h"
#import "DialogueMasterDAO.h"

@implementation DialogueMasterBL

- (NSMutableArray *) createDialogue:(DialogueMaster *) dialogueModel
{
    
    DialogueMasterDAO *dao=[DialogueMasterDAO sharedManager];
    NSUInteger n=[dao create:dialogueModel];
    [dao findAll];
    if (n==1) {
        return nil;
    }
    return  [dao findAll];
    
}


// 查询聊天记录
- (NSMutableArray *) findAllDialogue
{
    DialogueMasterDAO *dao=[DialogueMasterDAO sharedManager];
    return  [dao findAll];
}


// 根据JID,读取聊天ID
- (NSUInteger) findIDWithJID:(NSString *)strJID
{
    DialogueMasterDAO *dao=[DialogueMasterDAO sharedManager];
    return  [dao findID:strJID];
}

// 根据JID 判断有无重复记录
- (BOOL) checkDataWithJID:(NSString *)strJID
{
    DialogueMasterDAO *dao=[DialogueMasterDAO sharedManager];
    return  [dao checkDataWithJID:strJID];
}


@end
