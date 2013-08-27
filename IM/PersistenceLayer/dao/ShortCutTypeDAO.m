//
//  ShortCutTypeDAO.m
//  IM
//
//  Created by gujy on 13-8-27.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//


/**
 对快捷文字进行控制
 */


#import "ShortCutTypeDAO.h"

static ShortCutTypeDAO *sharedManager=nil;

@implementation ShortCutTypeDAO
@synthesize listData=_listData;

+(ShortCutTypeDAO*)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[ShortCutTypeDAO alloc]init];
        
    });
    
    return sharedManager;
}

- (id) init
{
    self=[super init];
    if (self) {
        _listData=[[NSMutableArray alloc] initWithCapacity:0];
 
    }
    
    return self;
}

// 保存聊天明细数据 类型
- (int) createType:(ShortCutType*) model;
{
    [self.listData addObject:model];
    return 0;
}

// 保存聊天明细数据 类型里的内容
- (int) createItem:(ShortCut*) model
{
    [self.listData addObject:model];
    return 0;
}



// 查询所有数据方法
- (NSMutableArray*) findAll
{
    return self.listData;
}

@end
