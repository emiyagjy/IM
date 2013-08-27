//
//  DialogueDetailDAO.m
//  IM
//
//  Created by gujy on 13-8-22.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 对聊天明细数据进行控制
 */

#import "DialogueDetailDAO.h"

#import "IMTools.h"

#import "XMPP.h"
#import "IMXMPPManager.h"
#import "SendMsgMessage.h"

static DialogueDetailDAO *sharedManager=nil;

@implementation DialogueDetailDAO

@synthesize listData=_listData;
@synthesize dbDialogueDetail=_dbDialogueDetail;


+(DialogueDetailDAO*)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[DialogueDetailDAO alloc]init];
        
    });
    
    return sharedManager;
}

- (id) init
{
    self=[super init];
    if (self) {
        _listData=[[NSMutableArray alloc] initWithCapacity:0];
        _dbDialogueDetail=[[IMDBDialogueDetail alloc] init];
        [_dbDialogueDetail createTable];
    }
    
    return self;
}

// 保存聊天明细记录
- (int) create:(DialogueDetail*) model
{
    [_dbDialogueDetail setDialogue:model];
    [_dbDialogueDetail insertTable];
    return 0;
}

//查询所有数据方法
- (NSMutableArray*) findAllWithCondition:(NSUInteger) parentID
{
    FMResultSet *resultSet=nil;
    
    if (parentID!=0) {
        resultSet=[_dbDialogueDetail findDataWithID:parentID];
    }else{
        resultSet=[_dbDialogueDetail findData];
    }
    
    // 移除再添加
    [_listData removeAllObjects];
    
    while ([resultSet next]) {
        DialogueDetail *model=[[DialogueDetail alloc] init];
        model.m_parentID = [resultSet intForColumn:@"PARENTID"];
        model.m_Message= [resultSet stringForColumn:@"MESSAGE"];
        model.m_Status=[resultSet intForColumn:@"STATUS"];
        NSString *strDate=[resultSet stringForColumn:@"DATE"];
        model.m_Date=[IMTools DateToTime:strDate];
        [_listData addObject:model];
    }
    
    return _listData;
    
}


// 查看所有未浏览的记录的数量
- (NSUInteger) findAllCountWithNolooking
{
    return [_dbDialogueDetail findQuantityWithNolooking];
}

// 向服务端发送聊天记录
- (void) sendMessage:(NSString *)strMsg to:(NSString *) to
{
    IMXMPPManager *manager= [IMXMPPManager sharedInstance];
    // from 
    XMPPJID *jidFrom=[manager.xmppStream myJID];
    
    XMPPJID *jidTo=[XMPPJID jidWithString:to];
    
    // body
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:strMsg];
    
    SendMsgMessage *sendMsg=[SendMsgMessage messageWithType:@"chat" to:jidTo from:jidFrom];
    [sendMsg addChild:body];
    
    
    [manager.xmppStream sendElement:sendMsg];
    
}


@end
