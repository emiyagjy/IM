//
//  IMXMPPManager.m
//  IM
//
//  Created by gujy on 13-8-13.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "IMXMPPManager.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import "IMTools.h"


#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
 
#endif


@implementation IMXMPPManager

@synthesize xmppStream=_xmppStream;
@synthesize xmppReconnect=_xmppReconnect;


IMXMPPManager *sharedManager;

+(IMXMPPManager*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[IMXMPPManager alloc]init];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];

    });

    [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID] forKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_PASSWORD] forKey:kXMPPmyPassword];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    // Setup the XMPP stream
    [sharedManager setupStream];

    return sharedManager;
}






////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	//NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }

	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		//xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
    
    // Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	if (!_xmppReconnect) {
        _xmppReconnect = [[XMPPReconnect alloc] init];
    }



    
    
    // Activate xmpp modules
    
	[_xmppReconnect         activate:_xmppStream];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
	[_xmppStream setHostName:kXMPPHost];
	[_xmppStream setHostPort:kXMPPtPort];
	
    
	// You may need to alter these settings depending on the server you're connecting to
//	allowSelfSignedCertificates = NO;
//	allowSSLHostNameMismatch = NO;
    

    
    if (![self connect]) {
        [[[UIAlertView alloc]initWithTitle:@"服务器连接失败" message:@"ps:" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
    };
}

- (void)teardownStream
{
	[_xmppStream removeDelegate:self];
    
    [_xmppReconnect         deactivate];
	[_xmppStream disconnect];
	
	_xmppStream = nil;

}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![_xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	// ===这句注释掉 改成下面这句   [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    [_xmppStream setMyJID:[XMPPJID jidWithUser:myJID domain:kXMPPHost resource:@"ios"]];
	password = myPassword;
    
	NSError *error = nil;
	if (![_xmppStream connect:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[_xmppStream disconnect];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    
}


//一些服务器也许需要链接过程加密.如果是这个原因，xmpp stream将自动进行安全连接.如果使用错误的证书，
//你需要实现xmppStream:willSecureWithSettings:delegate方法使用默认的安全设置
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
//	if (allowSelfSignedCertificates)
//	{
//		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
//	}
//	
//	if (allowSSLHostNameMismatch)
//	{
//		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
//	}
//	else
//	{
//		// Google does things incorrectly (does not conform to RFC).
//		// Because so many people ask questions about this (assume xmpp framework is broken),
//		// I've explicitly added code that shows how other xmpp clients "do the right thing"
//		// when connecting to a google server (gmail, or google apps for domains).
//		
//		NSString *expectedCertName = nil;
//		
//		NSString *serverDomain = xmppStream.hostName;
//		NSString *virtualDomain = [xmppStream.myJID domain];
//		
//		if ([serverDomain isEqualToString:@"talk.google.com"])
//		{
//			if ([virtualDomain isEqualToString:@"gmail.com"])
//			{
//				expectedCertName = virtualDomain;
//			}
//			else
//			{
//				expectedCertName = serverDomain;
//			}
//		}
//		else if (serverDomain == nil)
//		{
//			expectedCertName = virtualDomain;
//		}
//		else
//		{
//			expectedCertName = serverDomain;
//		}
//		
//		if (expectedCertName)
//		{
//			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
//		}
//	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

// 密码验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	// DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    // 上线
	[self goOnline];
    // HUD
    [IMTools showHUDWithSuccess:nil];
    
    // 再次保存用户名 和 密码
    [[NSUserDefaults standardUserDefaults]setObject:sender.myJID.user forKey:kMY_USER_ID];
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:kMY_USER_PASSWORD];
    
    //发送登陆成功的全局通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPLoginSuccessNotifaction object:nil];
    
}

// 密码验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    DDLogError(@"%@",@"密码验证失败");
    [IMTools showHUDWithError:MyLocalString(@"MSG_FAIL_LOGIN_01")];
    // 断开连接
    [self teardownStream];
    
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    
    NSUInteger status=[[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPGetVistor] integerValue];
    
    NSUInteger fstatus=[[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPGetFastWord] integerValue];
    
    
    if (status==IMIQGetVisitor) {
        //发送读取访客信息的全局通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPGetVisitorSuccessNotifaction object:iq];
        
        // 还原
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:IMIQDefault] forKey:kXMPPGetVistor];
        
    }
    
    
    if(fstatus==IMIQGetFastWork){
        [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPGetFastWorkSuccessNotifaction object:iq];
        
        // 还原
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:IMIQDefault] forKey:kXMPPGetFastWord];
        
    }
    
    
	//DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq elementID]);
	
	return NO;

}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    
	if ([message isChatMessageWithBody])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:kXMPPReceiveMsgNotifaction object:message];

// 
//        [[[UIAlertView alloc]initWithTitle:@"收到新消息" message:body delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];        
    }
    //   NSLog(@"displayName:%@",displayName);
    
    //        MessageEntity *messageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity"
    //                                                                     inManagedObjectContext:self.managedObjectContext];
    
    //        messageEntity.content = body;
    //        messageEntity.sendDate = [NSDate date];
    //        PersonEntity *senderUserEntity = [self fetchPerson:displayName];
    //        messageEntity.sender = senderUserEntity;
    //        //把这条消息加入到联系人发送的消息中
    //        [senderUserEntity addSendedMessagesObject:messageEntity];
    //        messageEntity.receiver = [self fetchPerson:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]];
    //        NSLog(@"sender:%@,receiver:%@",messageEntity.sender.name,messageEntity.receiver.name);
    //        [self saveContext];
    
//    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
//    {
        // We are not active, so use a local notification instead
        //			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        //			localNotification.alertAction = @"Ok";
        //			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
        //
        //			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//    }
	
}
 



- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    LOG(@"presence = %@", presence);
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            
       

        }else if ([presenceType isEqualToString:@"unavailable"]) {
            
            // 发送访客离线通知
            [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPVisitorOfflineNotifaction object:presenceFromUser];

            
        }
        
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
}


- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
  
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
        
        // 服务器连接失败
        [IMTools showHUDWithError:MyLocalString(@"MSG_LOADING_ERROR")];
        
	}
}



@end
