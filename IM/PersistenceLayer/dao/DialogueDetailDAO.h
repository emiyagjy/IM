//
//  DialogueDetailDAO.h
//  IM
//
//  Created by gujy on 13-8-22.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMDBDialogueDetail.h"

@interface DialogueDetailDAO : NSObject


// 保存数据列表
@property (nonatomic,strong) NSMutableArray *listData;

// 数据库
@property (nonatomic,strong) IMDBDialogueDetail *dbDialogueDetail;

+ (DialogueDetailDAO *) sharedManager;

// 保存聊天明细数据
- (int) create:(DialogueDetail*) model;

// 向服务端发送聊天记录
- (void) sendMessage:(NSString *)strMsg to:(NSString *) to;
 
// 查询所有数据方法
- (NSMutableArray*) findAllWithCondition:(NSUInteger) parentID;

// 查看所有未浏览的记录的数量
- (NSUInteger) findAllCountWithNolooking;



@end
