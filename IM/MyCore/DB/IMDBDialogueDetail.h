//
//  IMDBDialogueDetail.h
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "IMDbBase.h"
#import "DialogueDetail.h"

@interface IMDBDialogueDetail : IMDbBase

@property (nonatomic,strong) DialogueDetail *dialogue;


// 根据聊天列表主ID 获取表数据
- (FMResultSet *) findDataWithID:(NSUInteger) parentID;

// 获取所有 未查看聊天明细的数量
- (NSUInteger) findQuantityWithNolooking;

@end
