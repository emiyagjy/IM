//
//  ShortCutTypeDAO.h
//  IM
//
//  Created by gujy on 13-8-27.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShortCutType.h"
#import "ShortCut.h"

@interface ShortCutTypeDAO : NSObject

// 保存数据列表
@property (nonatomic,strong) NSMutableArray *listData;

+ (ShortCutTypeDAO *) sharedManager;


// 保存聊天明细数据 类型
- (int) createType:(ShortCutType*) model;

// 保存聊天明细数据 类型里的内容
- (int) createItem:(ShortCut*) model;


// 查询所有数据方法
- (NSMutableArray*) findAll;

@end
