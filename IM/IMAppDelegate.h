//
//  IMAppDelegate.h
//  IM
//
//  Created by gujy on 13-8-13.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <UIKit/UIKit.h>



@class IMMasterViewController;

@interface IMAppDelegate : UIResponder <UIApplicationDelegate>


// 保存所有界面
@property (strong,nonatomic) IMMasterViewController *masterVC;


@property (strong, nonatomic) UIWindow *window;

@end
