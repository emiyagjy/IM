//
//  BaseViewController.m
//  IM
//
//  Created by gujy on 13-8-15.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    
    // 初始化重新设置view的大小
    [self.view setFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
	 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
