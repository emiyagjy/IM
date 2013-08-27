//
//  ShortCutType.h
//  IM
//
//  Created by gujy on 13-8-27.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortCutType : NSObject

@property (nonatomic,strong) NSString *m_ID;   // 编号
@property (nonatomic,strong) NSString *m_Text; // 类型名称
@property (nonatomic,assign) NSUInteger m_OrderID;// 排序编号

// 用于存放快捷语
@property (nonatomic,strong) NSMutableArray *m_ShortcutArray;




@end
