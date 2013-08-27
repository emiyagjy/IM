//
//  DialogueDetailBL.h
//  IM
//
//  Created by gujy on 13-8-22.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogueDetail.h"


@interface DialogueDetailBL : NSObject


// 创建聊天明细记录
- (NSMutableArray *) createDialogue:(DialogueDetail *) dialogueModel;





// 查询聊天明细记录
- (NSMutableArray *) findAllDialogue;

// 根据ID 查询聊天明细记录
- (NSMutableArray *) findAllDialogueWithID:(NSUInteger)parentID;



// 查看所有未浏览的记录的数量
- (NSUInteger) findCountWithNolooking;


// 根据ID 更新所有未浏览的记录 变为 已浏览
// return 0 =  1=
- (NSUInteger) updateLookingStatusWithID:(NSUInteger) parentID;




// 向服务端发送聊天记录
- (void) sendDialogueWithMessage:(NSString *)strMsg to:(NSString *) to;
 
@end
