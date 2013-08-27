//
//  GJYTools.h
//  BussiessStreet
//
//  Created by gujy on 13-5-22.
//  Copyright (c) 2013年 Tonglu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "SVProgressHUD.h"
#include <sys/socket.h>


@interface IMTools : NSObject


// 判断网路是否连接正常



// 日期的转换
// 根据毫秒进行转换
+ (NSString *)DataStrVByInterval:(long long) time;
+ (NSString *)Date2StrV:(NSDate *)indate;
+ (NSString *)Date2Str:(NSDate *)indate;
+ (NSString *) DateToTime:(NSString *) string;

+ (NSDateComponents *)DateInfo:(NSDate *)indate;


// 
+ (NSString*) uuid;

// 打开一个地址
+ (void)OpenUrl:(NSString *)inUrl;
// 拨打电话
+ (void) OpenTel:(NSString *)strTelNumber;


// 判断手机号码的合法性
+ (BOOL) isValidateMobile:(NSString *)mobile;

// 判断是否有网络
+ (BOOL) isNetWork;

//// 显示HUD
//+ (void)showHUDWithWindow:(UIWindow *)windows msg:(NSString *)msg;
//+ (void)removeHUD;
//+ (void)showHUDWithSupView:(NSString *)msg superView:(UIView *)supView;
//+ (void)showHUdWithCustomView:(NSString *)msg withWindow:(UIWindow *)windows;


// 显示自定义图片
+ (void)showHUDWithCustomImage:(UIImage *)img withMsg:(NSString *)strMsg;
// 只显示加载
+ (void)showloadingHUD:(NSString *) strMsg maskType:(SVProgressHUDMaskType)maskType;

// 异常
+ (void)showHUDWithError:(NSString *) strError;
// 成功 一般不会用到
+ (void)showHUDWithSuccess:(NSString *) strSuccess;

// 显示提示框
+ (void)MsgBox:(NSString *)msg;

// 服务器地址
+ (void)saveServer:(NSString *)server;

+ (NSString *)loadServer;


// xml中返回字符串的拼接
+ (NSString *)concat:(NSString *)str1 withString:(NSString *)str2;

// 字符串转换
+ (NSString *)encodeBase64Str:(NSString*)input;
+ (NSString *)decodeBase64Str:(NSString*)input;
+ (NSString *)encodeBase64:(NSData *)input;
+ (NSData *)decodeBase64:(NSString*)input;


// 在按钮上添加数量
+ (void)addBadgeForButton:(UIButton *)button;


@end
