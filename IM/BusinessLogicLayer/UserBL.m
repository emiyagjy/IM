//
//  UserBL.m
//  IM
//
//  Created by gujy on 13-8-16.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 对用户类业务处理
 */

#import "UserBL.h"
#import "UserDAO.h"


@implementation UserBL


// 用户登陆
- (void) loginUser:(NSString *) _userId withPwd:(NSString *) _userPwd
{
    UserDAO *dao = [UserDAO sharedManager];
    [dao login:_userId withPwd:_userPwd];
}

@end
