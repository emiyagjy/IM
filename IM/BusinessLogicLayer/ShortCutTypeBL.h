//
//  ShortCutTypeBL.h
//  IM
//
//  Created by gujy on 13-8-27.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPIQ.h"
#import "XMPP.h"


@interface ShortCutTypeBL : NSObject


// 根据iq读取所有快捷用语的列表
// 根据类型区分
-(NSMutableArray*) getAllShortCutDataWithType:(XMPPIQ *)iq;

// 根据iq读取所有快捷用语的列表
// 不根据类型区分
-(NSMutableArray*) getAllShortCutDataWithNoType:(XMPPIQ *)iq;
@end
