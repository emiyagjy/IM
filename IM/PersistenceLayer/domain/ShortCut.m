//
//  ShortCut.m
//  IM
//
//  Created by gujy on 13-8-27.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 快捷用语
 */


#import "ShortCut.h"

@implementation ShortCut
@synthesize m_ID=_m_ID;
@synthesize m_Content=_m_Content;
@synthesize m_OrderID=_m_OrderID;


- (NSString *)description {
    
    NSString *format = @"{\n"
    "    m_ID =  %@;\n"
    "    m_OrderID =  %d;\n"
    "    m_Content = %@;\n"

    "}";
    
    return [NSString stringWithFormat:format,
            self.m_ID,
            self.m_OrderID,
            self.m_Content
            ];
}


@end
