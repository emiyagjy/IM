//
//  IMLoginViewController.m
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "IMLoginViewController.h"


//
#import "IMLoginView.h"

// 业务逻辑层
#import "UserBL.h"





@interface IMLoginViewController ()<IMLoginViewDelegate>


@property (nonatomic,strong) IMLoginView *loginView;

@end

@implementation IMLoginViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加登陆界面
    _loginView=[[IMLoginView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:_loginView];
    // 添加委托
    [_loginView setLoginDelegate:self];
    

    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Methods

// 调用业务逻辑
- (void) login:(NSString *) userId withPwd:(NSString *)userPassword
{
    // 检测用户名和密码是否合法
    UserBL *bl=[[UserBL alloc] init];
    [bl loginUser:userId withPwd:userPassword];
    
}





#pragma mark ------- IMlogView 协议  -------
- (void)  didloginClick:(NSString *)strUserId withPwd:(NSString *) strPwd
{
    // 调用登陆方法
    [self login:strUserId withPwd:strPwd];
}




- (void)viewDidUnload {
    
    [super viewDidUnload];
    
}
@end
