//
//  UserDAO.h
//  IM
//
//  Created by gujy on 13-8-16.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDAO : NSObject

+ (UserDAO *) sharedManager;


- (void) login:(NSString *) _userid withPwd:(NSString *) _pwd;




@end
