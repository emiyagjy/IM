//
//  IMXMPPManager.h
//  IM
//
//  Created by gujy on 13-8-13.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface IMXMPPManager : NSObject
{
    
    NSString *password;
    BOOL isXmppConnected;
}


@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
// 失去连接, 自动重连
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;

- (BOOL)connect;
- (void)disconnect;


+(IMXMPPManager*)sharedInstance;


#pragma mark -------连接XMPP服务器-----------

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;



@end
