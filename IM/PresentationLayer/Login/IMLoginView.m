//
//  IMLoginView.m
//  IM
//
//  Created by gujy on 13-8-16.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//


/** 组成部分
 1.头部视图存放im logo
 2.内容视图存放文本视图 和按钮
 3.
 */


#import "IMLoginView.h"
#import "IMLogInputView.h"

@interface IMLoginView()<UITextFieldDelegate>


@property (nonatomic,strong) IMLogInputView *logInputView;
@property (nonatomic,strong) UIButton *btnLogin;

@property (nonatomic,strong) UIView *myHeadView;
@property (nonatomic,strong) UIView *myContentView;




// 实例化视图
- (void) initializeView;

@end

@implementation IMLoginView
@synthesize myHeadView=_myHeadView;
@synthesize myContentView=_myContentView;
@synthesize logInputView=_logInputView;
@synthesize btnLogin=_btnLogin;

@synthesize loginDelegate=_loginDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 实例化背景颜色
        [self setBackgroundColor:COLOR_FOR_BgView];
        
        // 实例化视图
        [self initializeView];
        
        // 创建消息机制
        [self setupNotification];
        
        
        
    }
    return self;
}

// 实例化视图
- (void) initializeView
{
    
    // 头部视图
    _myHeadView=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,kHeadViewHeight)];
    [self addSubview:_myHeadView];
    
    // 头部图片
    UIImage *imgLogo=[UIImage imageNamed:@"imgIMLogo.png"];
    UIImageView *imgVLogo=[[UIImageView alloc] initWithImage:imgLogo];
    imgVLogo.frame=_myHeadView.frame;
    [_myHeadView addSubview:imgVLogo];
    
    
    // 中间视图
    CGFloat contentViewY=kHeadViewHeight;
    _myContentView=[[UIView alloc] initWithFrame:CGRectMake(0,contentViewY,self.frame.size.width, kContenHeight)];
    [self addSubview:_myContentView];
    
    // 文本视图
    CGFloat logInputViewX=kPaddingLeft_logInputView;
    _logInputView=[[IMLogInputView alloc] initWithFrame:CGRectMake(logInputViewX,0,klogInputViewWidth,klogInputViewHeight)];
    [_myContentView addSubview:_logInputView];
    
    
    ///////// UITextFiled /////////
    // 设置文本框Placeholder
    [_logInputView.txtAccount setPlaceholder:MyLocalString(@"TEXT_ACCOUNT")];
    [_logInputView.txtPwd setPlaceholder:MyLocalString(@"TEXT_PASSWORD")];
    
    // 设置文本框委托
    [_logInputView.txtAccount setDelegate:self];
    [_logInputView.txtPwd setDelegate:self];
    
    // 默认输入框
    NSString *userLoginId=@"";
    NSString *userLoginPwd=@"";
    [_logInputView.txtAccount setText:@"c897"];
    [_logInputView.txtPwd setText:@"111111"];
    
    
    // 登陆按钮按钮
    UIImage  *imgBtnlogin=[UIImage imageNamed:@"btnLogin.png"];
    CGFloat btnLoginX=logInputViewX;
    CGFloat btnLoginY=klogInputViewHeight+kBtnLoginPaddingInputView;
    CGFloat imgBtnloginWidth=imgBtnlogin.size.width;
    CGFloat imgBtnloginHeight=imgBtnlogin.size.height;
    _btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLogin setFrame:CGRectMake(btnLoginX,btnLoginY,imgBtnloginWidth, imgBtnloginHeight)];
    [_btnLogin setBackgroundImage:imgBtnlogin forState:UIControlStateNormal];
    [_myContentView addSubview:_btnLogin];
    // 添加登陆界面中按钮的事件
    [_btnLogin addTarget:self action:@selector(btnLoginHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

#pragma mark  -----  Methods  -----

// 登陆
- (void) loginUser
{
    NSString *strUserid=_logInputView.txtAccount.text;
    NSString *strUserPwd=_logInputView.txtPwd.text;
    
    if ([_loginDelegate respondsToSelector:@selector(didloginClick:withPwd:)]) {
        [_loginDelegate performSelector:@selector(didloginClick:withPwd:) withObject:strUserid withObject:strUserPwd];
    }
}


// 添加键盘消息机制
- (void) setupNotification
{
    _priorInsetSaved = NO;
    if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) ) {
        self.contentSize = self.frame.size;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGSize contentSize = _originalContentSize;
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);
    [super setContentSize:contentSize];
    
    if ( _keyboardVisible ) {
        self.contentInset = [self contentInsetForKeyboard];
    }
}

// 设置contentsie

-(void)setContentSize:(CGSize)contentSize {
    _originalContentSize = contentSize;
    
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);
    [super setContentSize:contentSize];
    
    if ( _keyboardVisible ) {
        self.contentInset = [self contentInsetForKeyboard];
    }
}


// 键盘

- (UIEdgeInsets)contentInsetForKeyboard {
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = [self keyboardRect];
    
    //216-[(244+216)-480 ]
    newInset.bottom = keyboardRect.size.height - ((keyboardRect.origin.y+keyboardRect.size.height) - (self.frame.origin.y+self.frame.size.height));
    
    // 还要减去底部的高度
    CGFloat height=self.frame.size.height-(kHeadViewHeight+kContenHeight);
    newInset.bottom-=height;
    
    return newInset;
}

- (CGRect)keyboardRect {
    CGRect keyboardRect = [self convertRect:_keyboardRect fromView:nil];
    if ( keyboardRect.origin.y == 0 ) {
        CGRect screenBounds = [self convertRect:[UIScreen mainScreen].bounds fromView:nil];
        keyboardRect.origin = CGPointMake(0, screenBounds.size.height - keyboardRect.size.height);
    }
    return keyboardRect;
}

-(CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space {
    
    // Convert the rect to get the view's distance from the top of the scrollView.
    CGRect rect = [view convertRect:view.frame toView:self];
    
    // Set starting offset to that point
    CGFloat offset = rect.origin.y;
    
    
    if ( self.contentSize.height - offset < space ) {
        // Scroll to the bottom
        offset = self.contentSize.height - space;
    } else {
        if ( view.frame.size.height < space ) {
            // Center vertically if there's room
            offset -= floor((space-view.frame.size.height)/2.0);
        }
        if ( offset + space > self.contentSize.height ) {
            // Clamp to content size
            offset = self.contentSize.height - space;
        }
    }
    LOG(@"offset is %f",offset);
    
    if (offset < 0) offset = 0;
    
    return offset;
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

#pragma mark  -----  Evens  -----

- (void) btnLoginHandler:(id) sender
{
    [self loginUser];
}

// 消息机制事件
// 键盘显示
- (void)keyboardWillShow:(NSNotification*)notification {
    
    _keyboardRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardVisible = YES;
    
    // 寻找是否是第一次响应
    // get first responder textfield
    UIView *firstResponder = [self findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        // No child view is the first responder - nothing to do here
        return;
    }else{
        // convert textfield left bottom point to scroll view coordinate
        // CGPoint point = [firstResponder convertPoint:CGPointMake(0, firstResponder.frame.size.height) toView:self];
        // 计算textfield左下角和键盘上面20像素 之间是不是差值
        
        [self animateKeyboard:notification up:YES];

    }


}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    
     [self animateKeyboard:notification up:NO];
    _keyboardRect = CGRectZero;
    _keyboardVisible = NO;
    self.scrollEnabled = NO;
}




- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_logInputView.txtPwd resignFirstResponder];
    [_logInputView.txtAccount resignFirstResponder];
}

#pragma  mark  ---------  输入文本框协议  ---------

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    // [self animateTextField:textField up:YES];
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    //  [self animateTextField:textField up:NO];
//}

- (void) animateKeyboard:(NSNotification*)notification up:(BOOL) up
{
    CGFloat height= kHeadViewHeight+kContenHeight;
    CGFloat scrollY = height - (_keyboardRect.origin.y - 20);

    if (scrollY > 0) {
        
        CGFloat moveY;
        if (up) {
            moveY=scrollY;
        }else{
            moveY=scrollY*(-1);
        }
        
        
        [UIView animateWithDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            //移动textfield到键盘上面20个像素
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + moveY);
        }];
    }
    self.scrollEnabled = NO;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _logInputView.txtAccount) {
        [_logInputView.txtPwd becomeFirstResponder];
    }
    
    if (textField==_logInputView.txtPwd) {
        [_logInputView.txtPwd resignFirstResponder];
    }
    
    return YES;
}

- (void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) dealloc
{
    [self tearDown];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
