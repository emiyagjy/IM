//
//  MainBL.m
//  IM
//
//  Created by gujy on 13-8-26.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "MainBL.h"
#import "XMPP.h"
#import "IMXMPPManager.h"

#import "GetVistorIQ.h"

@implementation MainBL


// 发送xml 读取访客
-(void) sendVisitorXML
{
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:kXMPPGetVistor];
    IMXMPPManager *manager= [IMXMPPManager sharedInstance];
    XMPPJID *jid=[manager.xmppStream myJID];
    GetVistorIQ *iq=[GetVistorIQ iqWithType:@"get" to:nil from:jid elementID:[manager.xmppStream generateUUID] child:query];
    
    [manager.xmppStream sendElement:iq];
    
    // 保存状态
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:IMIQGetVisitor] forKey:kXMPPGetVistor];

}

// 发送xml 读取快捷用语
-(void) sendFastWordXML
{
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:kXMPPGetFastWord];
    IMXMPPManager *manager= [IMXMPPManager sharedInstance];
    XMPPJID *jid=[manager.xmppStream myJID];
    GetVistorIQ *iq=[GetVistorIQ iqWithType:@"get" to:nil from:jid elementID:[manager.xmppStream generateUUID] child:query];
    
    [manager.xmppStream sendElement:iq];
    
    // 保存状态
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:IMIQGetFastWork] forKey:kXMPPGetFastWord];
    
    
}


@end
