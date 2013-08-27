//
//  UserDAO.m
//  IM
//
//  Created by gujy on 13-8-16.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 对用户进行控制
 */

#import "UserDAO.h"

#import "IMXMPPManager.h"
#import "IMTools.h"


static UserDAO *sharedManager=nil;

@implementation UserDAO

+(UserDAO*)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[self alloc]init];
    });
    return sharedManager;
}


- (void) login:(NSString *) _userid withPwd:(NSString *) _pwd
{
    
    // 检测用户名是否合法
    if ([_userid length]<=0) {
        [IMTools showHUDWithError:MyLocalString(@"MSG_FAIL_LOGIN_02")];
        return;
    }
    
    if([_pwd length]<=0){
        [IMTools showHUDWithError:MyLocalString(@"MSG_FAIL_LOGIN_03")];
        return;
    }
    
    
    // 保存用户名
    [[NSUserDefaults standardUserDefaults]setObject:_userid forKey:kMY_USER_ID];
    [[NSUserDefaults standardUserDefaults]setObject:_pwd forKey:kMY_USER_PASSWORD];
    
    // xmpp 协议连接
    IMXMPPManager *manager= [IMXMPPManager sharedInstance];
    [manager goOnline];
    [IMTools showloadingHUD:MyLocalString(@"MSG_LOADING")  maskType:SVProgressHUDMaskTypeNone];
    

    
    
}

@end
