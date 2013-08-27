//
//  VisitorBL.h
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPIQ.h"
#import "XMPP.h"
@interface VisitorBL : NSObject


// 根据iq读取所有访客列表
-(NSMutableArray*) getAllVisitorData:(XMPPIQ *)iq;

// 移除离线访客
-(NSMutableArray*) removeVisitorWithName:(NSString *) strName;

// 查询访客ip地址
-(NSString *) findVisitorIpWithName:(NSString *)strName;

@end
