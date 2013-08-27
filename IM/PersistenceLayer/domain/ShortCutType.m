//
//  ShortCutType.m
//  IM
//
//  Created by gujy on 13-8-27.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 快捷用语类型
 */

#import "ShortCutType.h"

@implementation ShortCutType

@synthesize m_ID=_m_ID;
@synthesize m_OrderID=_m_OrderID;
@synthesize m_Text=_m_Text;
// 存放快捷用语
@synthesize m_ShortcutArray=_m_ShortcutArray;


- (id) init
{
    self=[super init];
    if (self) {
        _m_ShortcutArray=[[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSString *)description {
    
    NSString *format = @"{\n"
    "    m_ID =  %@;\n"
    "    m_OrderID =  %d;\n"
    "    m_Text = %@;\n"
    "    m_ShortcutArray =  %@;\n"

    "}";
    
    return [NSString stringWithFormat:format,
            self.m_ID,
            self.m_OrderID,
            self.m_Text,
            self.m_ShortcutArray
            ];
}



@end
