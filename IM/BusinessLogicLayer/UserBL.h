//
//  UserBL.h
//  IM
//
//  Created by gujy on 13-8-16.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBL : NSObject

// 用户登陆
- (void) loginUser:(NSString *) _userId withPwd:(NSString *) _userPwd;

@end
