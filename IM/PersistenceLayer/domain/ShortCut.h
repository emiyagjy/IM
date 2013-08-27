//
//  ShortCut.h
//  IM
//
//  Created by gujy on 13-8-27.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortCut : NSObject


@property (nonatomic,strong) NSString *m_ID;  // 编号
@property (nonatomic,strong) NSString *m_Content; // 快捷内容
@property (nonatomic,assign) NSUInteger m_OrderID; // 排序编号



@end
