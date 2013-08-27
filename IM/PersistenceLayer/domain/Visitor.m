//
//  Visitor.m
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 访客类
 */

#import "Visitor.h"

@implementation Visitor
@synthesize m_VisitorJid=_m_VisitorJid;
@synthesize m_VisitorName=_m_VisitorName;
@synthesize m_VisitorIP=_m_VisitorIP;
@synthesize m_VisitorUrl=_m_VisitorUrl;
@synthesize m_VisitorSrc=_m_VisitorSrc;
@synthesize m_VisitorStauts=_m_VisitorStauts;

- (NSString *)description {
    
    NSString *format = @"{\n"
    "    m_VisitorJid =  %@;\n"
    "    m_VisitorName = %@;\n"
    "    m_VisitorIP =  %@;\n"
    "    m_VisitorUrl = %@;\n"
    "    m_VisitorSrc = %@;\n"
    "    m_VisitorStauts =  %d;\n"
    
    "}";
    
    return [NSString stringWithFormat:format,
            self.m_VisitorJid,
            self.m_VisitorName,
            self.m_VisitorIP,
            self.m_VisitorUrl,
            self.m_VisitorSrc,
            self.m_VisitorStauts
            ];
}


@end
