//
//  DialogueMaster.h
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IMDialogueMasterReceive = 0,
    IMDialogueMasterOnline,
    IMDialogueMasterHistory

} IMDialogueMasterStatus;


@interface DialogueMaster : NSObject


@property (nonatomic,assign) NSUInteger m_ID;      // 聊天id
@property (nonatomic,strong) NSString *m_JID;      // JID 区分
@property (nonatomic,strong) NSString *m_IP;   // ip 地址
@property (nonatomic,assign) NSUInteger m_Status;   // 聊天记录状态
//1.访客主动发来的对话信息
//2.已建立连接的对话信息
//3.历史对话信息
@property (nonatomic,strong) NSDate *m_Date; // 时间


@end

