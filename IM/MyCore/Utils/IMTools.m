/////
//  GJYTools.m
//  BussiessStreet
//
//  Created by gujy on 13-5-22.
//  Copyright (c) 2013年 Tonglu. All rights reserved.
//

#import "IMTools.h"
//#import "CustomBadge.h"
#import "GTMBase64.h"
#include <sys/socket.h>
#import "SVProgressHUD.h"


#define kHUDErrorDuring 1.0f
#define kHUDSuccessDuring  1.0f

#define kHUDHideDuring  2.0f
#define MsgBox(msg) [self MsgBox:msg]

@implementation IMTools

//static MBProgressHUD *HUD;


// 根据毫秒进行转换
+(NSString *) DataStrVByInterval:(long long) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    
    NSDate *date=[IMTools getDateTimeFromMilliSeconds:time];
    
    return [dateFormatter stringFromDate:date];
}

// 把long long 转换成NSTimeInterval
+ (NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds
{
    //将NSDate类型的时间转换为NSTimeInterval类型
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSLog(@"seconds=%f",seconds);
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}


//程序中使用的，将日期显示成  2011年4月4日 星期一
+ (NSString *) Date2StrV:(NSDate *)indate{
    
    // arc
	//NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    //setLocale 方法将其转为中文的日期表达
    // no arc
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

// 程序中使用的,将日期显示成 星期一 20:20分
+ (NSString *) DateToTime:(NSString *) string
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateFormatter.dateFormat =@"yyyy-MM-dd HH:mm:ss Z";
    NSDate* inputDate = [dateFormatter dateFromString:string];
    
    LOG(@"date = %@", inputDate);
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"EEEE HH:mm"];
    NSString *strTime = [outputFormatter stringFromDate:inputDate];

    return strTime;
}



//程序中使用的，提交日期的格式
+ (NSString *) Date2Str:(NSDate *)indate{
	// arc
	//NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    // no arc
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyyMMdd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

//获得日期的具体信息，本程序是为获得星期，注意！返回星期是 int 型，但是和中国传统星期有差异
+ (NSDateComponents *) DateInfo:(NSDate *)indate{
    
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	//NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSDateComponents *comps=nil;
    comps = [[NSDateComponents alloc] init];
    
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
	comps = [calendar components:unitFlags fromDate:indate];
	
	return comps;
    
    //	week = [comps weekday];
    //	month = [comps month];
    //	day = [comps day];
    //	hour = [comps hour];
    //	min = [comps minute];
    //	sec = [comps second];
    
}


+ (NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;
 
}


// 打开一个网址
+ (void) OpenUrl:(NSString *)inUrl{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:inUrl]];
}

// 拨打电话
+ (void) OpenTel:(NSString *)strTelNumber
{
    
    NSString *strTel=[NSString stringWithFormat:@"telprompt:%@",strTelNumber];
    NSURL *phoneURL = [NSURL URLWithString:strTel];
    [[UIApplication sharedApplication] openURL:phoneURL];
//    UIWebView *phoneCallWebView;
//    if ( !phoneCallWebView ) {
//        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
//    }
//    
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
}


// 判断手机号码的合法性
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    BOOL result=NO;
//    //手机号以13， 15，18开头，八个 \d 数字字符
//   // NSString *phoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
//    NSString *phoneRegex = @"^((13[0-9])|(147)(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneDicate  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    //    NSLog(@"phoneTest is %@",phoneTest);
//    
//    result=[phoneDicate evaluateWithObject:mobile];
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[1278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES))
    {
        result= YES;
    }
    else
    {
        result= NO;
    }
    
    
    return result;
}



+ (BOOL) isNetWork;
{
    BOOL isExistenceNetwork = NO;
    Reachability *r = [Reachability reachabilityWithHostName:@"http://man.87510.cn/"];
    
   // LOG(@"[r currentReachabilityStatus] IS %d",[r currentReachabilityStatus]);
    [r currentReachabilityStatus];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork=NO;
//            LOG(@"没有网络");
//            break;
//        case  ReachableViaWWAN:
//            isExistenceNetwork=YES;
//            LOG(@"正在使用3G网络");
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork=YES;
//            LOG(@"正在使用wifi网络");
//            break;
//    }
    
    
    return isExistenceNetwork;

}

//MBProgressHUD 的使用方式，只对外两个方法，可以随时使用(但会有警告！)，其中窗口的 alpha 值 可以在源程序里修改。
//+ (void)showHUDWithWindow:(UIWindow *)windows msg:(NSString *)msg  {
//    //UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    if (!windows) {
//        windows = [UIApplication sharedApplication].keyWindow;
//    }
//	HUD = [[MBProgressHUD alloc] initWithWindow:windows];
//	[windows addSubview:HUD];
//	//HUD.labelText = msg;
//	[HUD show:YES];
//}
//
//
//
//
//+ (void)removeHUD{
//	
//	[HUD hide:YES];
//	[HUD removeFromSuperViewOnHide];
//}
//
//
//+ (void) showHUDWithSupView:(NSString *)msg superView:(UIView *)supView
//{
//    HUD= [[MBProgressHUD alloc] initWithView:supView];
//    [supView addSubview:HUD];
//    [supView bringSubviewToFront:HUD];
//    // HUD.labelText =msg;
//    
//  //[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
//    [HUD show:YES];
//
//}



//+ (void)showHUdWithCustomView:(NSString *)msg withWindow:(UIWindow *)windows
//{
//    if (!windows) {
//        windows = [UIApplication sharedApplication].keyWindow;
//    }
//	HUD = [[MBProgressHUD alloc] initWithWindow:windows];
//    
//	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
//	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
//	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_star_fill.png"]]  ;
//	
//    // Set custom view mode
//    HUD.mode = MBProgressHUDModeCustomView;
//	
//    //HUD.delegate = self;
//    HUD.labelText =msg;
//    [windows addSubview:HUD];
//    [HUD show:YES];
//	[HUD hide:YES afterDelay:kHUDHideDuring];
//}


+ (void) showHUDWithCustomImage:(UIImage *)img withMsg:(NSString *)strMsg
{
    if (img) {
        [SVProgressHUD showMegWithCusImage:img withMsg:strMsg duration:kHUDSuccessDuring];
    }
}


// 只显示加载
+ (void)showloadingHUD:(NSString *) strMsg maskType:(SVProgressHUDMaskType)maskType
{
    if (strMsg) {
        [SVProgressHUD showWithStatus:strMsg maskType:maskType];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
}


// 异常
+ (void)showHUDWithError:(NSString *) strError
{
    [SVProgressHUD showErrorWithStatus:strError duration:kHUDErrorDuring];
}

// 成功 一般不会用到
+ (void)showHUDWithSuccess:(NSString *) strSuccess
{
    if (strSuccess) {
        [SVProgressHUD showSuccessWithStatus:strSuccess duration:kHUDSuccessDuring];
    }else{
        [SVProgressHUD dismiss];
    }

}



//提示窗口
+ (void)MsgBox:(NSString *)msg{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	//[alert release];
}




// 服务器地址
+ (void)saveServer:(NSString *)ServerIP {
    [[NSUserDefaults standardUserDefaults] setObject:ServerIP forKey:@"ProdServerIP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)loadServer; {
    //return [[NSUserDefaults standardUserDefaults] stringForKey:@"ProdServerIP"];
    return @"192.168.1.12";
    
}


/*****************************************************************************************
 * concat strings
 *
 ****************************************************************************************/
+ (NSString *)concat:(NSString *)str1 withString:(NSString *)str2 {
    if (str1) {
        if (str2) {
            return [NSString stringWithFormat:@"%@%@", str1, str2];
        } else {
            return [NSString stringWithString:str1];
        }
    } else {
        if (str2) {
            return [NSString stringWithString:str2];
        } else {
            return nil;
        }
        
    }
}


// 字符串转换
/*****************************************************************************************
 * encode for BASE64
 *
 ****************************************************************************************/
+ (NSString*)encodeBase64Str:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    
    //arc
    // NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    // no arc
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

/*****************************************************************************************
 * decode for BASE64
 *
 ****************************************************************************************/
+ (NSString*)decodeBase64Str:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 decodeData:data];
    // arc
    // NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    // no arc
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

/*****************************************************************************************
 * encode for BASE64
 *
 ****************************************************************************************/
+ (NSString *)encodeBase64:(NSData *)input {
    //转换到base64
    NSData *data = [GTMBase64 decodeData:input];
    // arc
    //NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    // no arc
     NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


/*****************************************************************************************
 * decode for BASE64
 *
 ****************************************************************************************/
+ (NSData *)decodeBase64:(NSString*)input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 decodeData:data];
    return data;
}


+ (void)addBadgeForButton:(UIButton *)button{
    // remove badge
    //    [[button viewWithTag:99] removeFromSuperview];
    //
    //    // 计算未看推送信息的数量
    //    NSUInteger count=[MenuData instance].getPushDataNumberForNoReading;
    //    /* 在程序外增加badge的数量 */
    //    [UIApplication sharedApplication].applicationIconBadgeNumber=count;
    //
    //    if (count == 0) {
    //        return;
    //    }
    //
    //    // set badge
    //    CGRect bounds = button.bounds;
    //
    //    CGFloat badgeScale;
    //    CGFloat badgeX;
    //    CGFloat badgeY;
    //    if ([MenuData instance].currDevice==GGiPad) {
    //        badgeScale=1.0;
    //        badgeX=CGRectGetWidth(bounds)-20;
    //        badgeY=0;
    //
    //    }else{
    //        badgeScale=0.6;
    //        badgeX=CGRectGetWidth(bounds)-10;
    //        badgeY=3;
    //    }
    //
    //    CustomBadge *customBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", count]
    //                                                  withStringColor:[UIColor whiteColor]
    //                                                   withInsetColor:[UIColor redColor]
    //                                                   withBadgeFrame:YES
    //                                              withBadgeFrameColor:[UIColor whiteColor]
    //                                                        withScale:badgeScale
    //                                                      withShining:YES];
    //
    //    CGPoint center = CGPointMake(badgeX,badgeY);
    //    customBadge.center = center;
    //    customBadge.tag = 99;
    //    [button addSubview:customBadge];
    
    
}






@end
