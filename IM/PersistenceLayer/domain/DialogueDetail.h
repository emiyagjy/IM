//
//  DialogueDetail.h
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IMDialogueDetialReceive = 0,
    IMDialogueDetailSend
    
} IMDialogueDetailStatus;

typedef enum { // 发送的信息默认为0
    IMDialogueDNolooking = 1,
    IMDialogueDHaslooking= 2
    
} IMDialogueDlookStatus;



@interface DialogueDetail : NSObject

@property (nonatomic,assign) NSUInteger m_parentID; // 父类ID
@property (nonatomic,strong) NSString *m_Message; // 消息
@property (nonatomic,assign) NSUInteger m_Status;  // 消息的状态 0=receive 1=send
@property (nonatomic,strong) NSString *m_Date; // 时间

@property (nonatomic,assign) NSUInteger m_lookStatus; //内容是否被浏览过



@end
