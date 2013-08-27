//
//  DialogueMaster.m
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 聊天记录
 */

#import "DialogueMaster.h"


@implementation DialogueMaster : NSObject 

@synthesize m_ID=_m_ID;
@synthesize m_JID=_m_JID;
@synthesize m_IP=_m_IP;
@synthesize m_Status=_m_Status;
@synthesize m_Date=_m_Date;


- (NSString *)description {
    
    NSString *format = @"{\n"
    "    m_ID =  %d;\n"
    "    m_JID = %@;\n"
    "    m_IP =  %@;\n"
    "    m_Status = %d;\n"
    "    m_Date = %@;\n"
    
    "}";
    
    return [NSString stringWithFormat:format,
            self.m_ID,
            self.m_JID,
            self.m_IP,
            self.m_Status,
            self.m_Date
            ];
}

@end
