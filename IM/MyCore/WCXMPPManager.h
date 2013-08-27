//
//  WCXMPPManager.h
//  WeChat
//
//  Created by Reese on 13-8-10.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h> 
#import "XMPPFramework.h"

@interface WCXMPPManager : NSObject <XMPPRosterDelegate>

{
    XMPPStream *xmppStream;
    
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    
    
//	XMPPRosterCoreDataStorage *xmppRosterStorage;
//    XMPPvCardCoreDataStorage *xmppvCardStorage;
    
	XMPPvCardTempModule *xmppvCardTempModule;
//	XMPPvCardAvatarModule *xmppvCardAvatarModule;
    
    
	//XMPPCapabilities *xmppCapabilities;
	//XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    

}
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
////@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
////@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
////@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
//@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
//@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;


//- (NSManagedObjectContext *)managedObjectContext_roster;
//- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;




+(WCXMPPManager*)sharedInstance;


#pragma mark -------连接XMPP服务器-----------

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;



@end
