//
//  SendMsgMessage.m
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 发送信息xml的拼接
 */
#import "XMPPJID.h"
#import "NSXMLElement+XMPP.h"

#import "SendMsgMessage.h"

@implementation SendMsgMessage


/**
 初始化的xml节点
 */

+ (SendMsgMessage *)messageWithType:(NSString *)type to:(XMPPJID *)to from:(XMPPJID *)from
{
    return [[SendMsgMessage alloc] initWithType:type to:to from:from];
}

- (id)initWithType:(NSString *)type to:(XMPPJID *)to from:(XMPPJID *)from
{
    self=[super initWithType:type to:to];
    
    if (self) {
        if (from)
        [self addAttributeWithName:@"from" stringValue:[from description]];

    }
    return self;
    
}

@end
