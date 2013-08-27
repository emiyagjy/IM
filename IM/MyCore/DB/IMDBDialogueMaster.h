//
//  IMDBDialogueMaster.h
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "IMDbBase.h"
#import "DialogueMaster.h"

@interface IMDBDialogueMaster : IMDbBase

@property (nonatomic,strong) DialogueMaster *dialogue;

// 根据条件判断数据是佛重复
- (BOOL) checkData:(NSString *)strCondition;

@end
