//
//  GetVistorIQ.h
//  MyXMPPTest
//
//  Created by gujy on 13-8-12.
//  Copyright (c) 2013年 com.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPIQ.h"






@interface GetVistorIQ : XMPPIQ



/**
 * Creates and returns a new autoreleased XMPPIQ element.
 * If the type or elementID parameters are nil, those attributes will not be added.
 **/
+ (GetVistorIQ *)iqWithType:(NSString *)type to:(XMPPJID *)jidTo from:(XMPPJID *) jidFrom elementID:(NSString *)eid child:(NSXMLElement *)childElement;

/**
 * Creates and returns a new XMPPIQ element.
 * If the type or elementID parameters are nil, those attributes will not be added.
 **/
- (id)initWithType:(NSString *)type to:(XMPPJID *)jidTo from:(XMPPJID *) jidFrom elementID:(NSString *)eid child:(NSXMLElement *)childElement;

 




@end
