//
//  IMChatViewController.h
//  IM
//
//  Created by gujy on 13-8-15.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMBaseChatViewController.h"
#import "XMPP.h"

@class Visitor;

@interface IMChatViewController : IMBaseChatViewController<IMMessagesViewDelegate,IMMessagesViewDataSource>


// 消息发给谁
@property (nonatomic,strong) Visitor *visitor;

@property (strong, nonatomic) NSArray *messageArray;
@property (strong, nonatomic) NSArray *fastWordArray; // 快捷用语


// 收到消息
- (void) finishReceive:(NSArray*) dialogueArray;

// 更新访客状态
- (void) updateVisitroStatus:(NSUInteger) status;

// 读取快捷用语
- (void) getFastWordData:(XMPPIQ *)iq;

@end
