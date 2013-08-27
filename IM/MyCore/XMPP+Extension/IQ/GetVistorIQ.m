//
//  GetVistorIQ.m
//  MyXMPPTest
//
//  Created by gujy on 13-8-12.
//  Copyright (c) 2013年 com.test. All rights reserved.
//


/**
 获取在线访客内容xml的拼接
 */

#import "GetVistorIQ.h"

#import "XMPPJID.h"
#import "NSXMLElement+XMPP.h"

@implementation GetVistorIQ

/**
 初始化的xml节点
 */

+ (GetVistorIQ *)iqWithType:(NSString *)type to:(XMPPJID *)jidTo from:(XMPPJID *) jidFrom elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
    return [[GetVistorIQ alloc] initWithType:type to:jidTo from:jidFrom elementID:eid child:childElement];
}


- (id)initWithType:(NSString *)type to:(XMPPJID *)jidTo from:(XMPPJID *) jidFrom elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	if (self = [super initWithType:type to:jidTo elementID:eid child:childElement])
	{
        if (jidFrom)
			[self addAttributeWithName:@"from" stringValue:[jidFrom full]];
 	}
	return self;
}

 

@end
