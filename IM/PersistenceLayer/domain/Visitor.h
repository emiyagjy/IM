//
//  Visitor.h
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//



#import <Foundation/Foundation.h>


typedef enum {
    IMVistorOffline = 0, // 下线
    IMVistorOnline // 上线
    
} IMVistorStatus;

@interface Visitor : NSObject

@property (nonatomic,strong) NSString* m_VisitorJid;   // 访客JID
@property (nonatomic,strong) NSString* m_VisitorName;  // 访客名称
@property (nonatomic,strong) NSString* m_VisitorIP;    // 访客的IP地址
@property (nonatomic,strong) NSString* m_VisitorUrl;   // 访客所访问的页面
@property (nonatomic,strong) NSString* m_VisitorSrc;   // 访客所访问页面的域名
@property (nonatomic,assign) NSUInteger m_VisitorStauts;// 访客咨询状态  0 无 1 对话中 2 拒绝邀请 3 对话结束

@end
