//
//  DialogueDetail.m
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 聊天明细记录
 */

#import "DialogueDetail.h"

@implementation DialogueDetail
@synthesize m_parentID=_m_parentID;
@synthesize m_Message=_m_Message;
@synthesize m_Status=_m_Status;
@synthesize m_Date=_m_Date;
@synthesize m_lookStatus=_m_lookStatus;


- (NSString *)description {
    
    NSString *format = @"{\n"
    "    m_parentID =  %d;\n"
    "    m_Message =  %@;\n"
    "    m_Status = %d;\n"
    "    m_Date =  %@;\n"
    "    m_lookStatus =  %d;\n"
    

    
    "}";
    
    return [NSString stringWithFormat:format,
            self.m_parentID,
            self.m_Message,
            self.m_Status,
            self.m_Date,
            self.m_lookStatus
            ];
}


@end
