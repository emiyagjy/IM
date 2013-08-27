//
//  VisitorDAO.h
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Visitor.h"

@interface VisitorDAO : NSObject


// 保存数据列表
@property (nonatomic,strong) NSMutableArray *listData;

+ (VisitorDAO *) sharedManager;


// 保存访客数据
- (int) create:(Visitor*) model;

// 移除访客数据
- (int) deleteWithName:(NSString *) strName;

// 查询所有数据方法
- (NSMutableArray*) findAll;

// 查询访客ip地址
- (NSString *) findVisitorIPWithName:(NSString *)strName;




@end
