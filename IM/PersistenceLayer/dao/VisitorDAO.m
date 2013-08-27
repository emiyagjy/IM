//
//  VisitorDAO.m
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 对访客类进行控制
 */

#import "VisitorDAO.h"

static VisitorDAO *sharedManager=nil;

@implementation VisitorDAO

@synthesize listData=_listData;


+(VisitorDAO*)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[self alloc]init];
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



// 保存访客数据
- (int) create:(Visitor*)model
{
    [self.listData addObject:model];
    return 0;
}

// 移除访客数据
- (int) deleteWithName:(NSString *) strName
{
    for (Visitor *m in self.listData) {
        if ([m.m_VisitorName isEqualToString:strName]) {
            [self.listData removeObject:m];
            break;
        }
    }
    return 0;
}


// 查询所有数据方法
- (NSMutableArray*) findAll
{
    return self.listData;
}

// 查询访客ip地址
- (NSString *) findVisitorIPWithName:(NSString *)strName
{
    for (Visitor *m in self.listData) {
        NSString *strjid=[NSString stringWithFormat:@"%@%@",m.m_VisitorName,@"@10.200.2.6/web"];
        
        if ([strjid isEqualToString:strName]) {
            return m.m_VisitorIP;
        }
    }
    return nil;
}



@end
