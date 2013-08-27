//
//  DialogueDetailBL.m
//  IM
//
//  Created by gujy on 13-8-22.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "DialogueDetailBL.h"
#import "DialogueDetailDAO.h"


@implementation DialogueDetailBL


// 保存聊天明细记录
- (NSMutableArray *) createDialogue:(DialogueDetail *) dialogueModel
{
    DialogueDetailDAO *dao=[DialogueDetailDAO sharedManager];
    [dao create:dialogueModel];
    return  [dao findAllWithCondition:dialogueModel.m_parentID];
}


// 查询聊天明细记录
- (NSMutableArray *) findAllDialogue
{
    DialogueDetailDAO *dao=[DialogueDetailDAO sharedManager];
    return  [dao findAllWithCondition:0];
}

// 根据ID 查询聊天明细记录
- (NSMutableArray *) findAllDialogueWithID:(NSUInteger)parentID
{
    DialogueDetailDAO *dao=[DialogueDetailDAO sharedManager];
    return  [dao findAllWithCondition:parentID];
}


// 根据ID 更新所有未浏览的记录 变为 已浏览
// return 0 =  1=
- (NSUInteger) updateLookingStatusWithID:(NSUInteger) parentID
{
    
}



// 查看所有未浏览的记录的数量
- (NSUInteger) findCountWithNolooking
{
    DialogueDetailDAO *dao=[DialogueDetailDAO sharedManager];
    return [dao findAllCountWithNolooking];
}





// 向服务端发送聊天记录
- (void) sendDialogueWithMessage:(NSString *)strMsg to:(NSString *) to;
{
    DialogueDetailDAO *dao=[DialogueDetailDAO sharedManager];
    [dao sendMessage:strMsg to:to];
}




@end
