//
//  SendMsgMessage.h
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "XMPPMessage.h"

@interface SendMsgMessage : XMPPMessage


+ (SendMsgMessage *)messageWithType:(NSString *)type to:(XMPPJID *)to from:(XMPPJID *)from;


- (id)initWithType:(NSString *)type to:(XMPPJID *)to from:(XMPPJID *)from;


@end
