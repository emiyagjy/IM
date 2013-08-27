//
//  IMLogInputView.m
//  IM
//
//  Created by gujy on 13-8-16.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/** 组成部分
 1.自身样式
 2.userView
 3.pwdView
 */

#import "IMLogInputView.h"

@interface IMLogInputView()


@property (nonatomic,strong) UIView *inputBgView;



// 实例化账号输入的密码输入的 视图
- (void) initializeUserViewAndPwdView;


@end

@implementation IMLogInputView


@synthesize inputBgView=_inputBgView;
@synthesize txtAccount=_txtAccount;
@synthesize txtPwd=_txtPwd;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /// 背景颜色
        [self setBackgroundColor:[UIColor whiteColor]];
        
        /// 边框样式
        UIColor *borderColor=COLOR_FOR_InputViewBorder;
        self.layer.borderWidth  =0.5;
        self.layer.cornerRadius =5;
        self.layer.borderColor = [borderColor CGColor];
        
        /// 中间线条颜色
        CGFloat lineY=frame.size.height*0.5;
        CGFloat lineHeight=0.5;
        UILabel *lblLine=[[UILabel alloc] initWithFrame:CGRectMake(0, lineY,frame.size.width,lineHeight)];
        [lblLine setBackgroundColor:borderColor];
        [self addSubview:lblLine];
        
        
        // 实例化账号输入的密码输入的 视图
        [self initializeUserViewAndPwdView];
        
 
        
    }
    return self;
}

// 实例化账号输入的密码输入的 视图
- (void) initializeUserViewAndPwdView
{
    ////// 账号
    CGFloat accontViewHeight=self.frame.size.height*0.5;
    UIView *accontView=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,accontViewHeight)];
    [accontView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:accontView];
    
    // 账号的图标
    CGFloat accontIconX=kiconPaddingLeft;
    CGFloat accontIconY=accontViewHeight *0.5-kiconHeight*0.5;
    UIImage *imgAccount=[UIImage imageNamed:@"accont.png"];
    UIImageView *accontImageView=[[UIImageView alloc] initWithFrame:CGRectMake(accontIconX, accontIconY,kiconWidth, kiconHeight)];
    [accontImageView setImage:imgAccount];
    [accontView addSubview:accontImageView];

    // 账号的文本输入框
    CGFloat txtUserX=ktextFieldleft;
    CGFloat txtUserY=accontIconY;
    _txtAccount=[[UITextField alloc] initWithFrame:CGRectMake(txtUserX,txtUserY,ktextfieldWidth, ktextfieldHeight)];
    [_txtAccount setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_txtAccount setReturnKeyType:UIReturnKeyNext];
    [accontView addSubview:_txtAccount];
    
    
    ///// 密码
    CGFloat pwdViewY=self.frame.size.height*0.5;
    CGFloat pwdViewHeight=self.frame.size.height*0.5;
    UIView *pwdView=[[UIView alloc] initWithFrame:CGRectMake(0,pwdViewY,self.frame.size.width,pwdViewHeight)];
    [pwdView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:pwdView];
    
    // 密码的图标
    CGFloat pwdIconX=kiconPaddingLeft;
    CGFloat pwdIconY=pwdViewHeight *0.5-kiconHeight*0.5;
    
    UIImage *imgPwd=[UIImage imageNamed:@"key.png"];
    UIImageView *pwdImageView=[[UIImageView alloc] initWithFrame:CGRectMake(pwdIconX, pwdIconY,kiconWidth, kiconHeight)];
    [pwdImageView setImage:imgPwd];
    [pwdView addSubview:pwdImageView];
    
    // 密码的文本输入框
    CGFloat txtPwdX=ktextFieldleft;
    CGFloat txtPwdY=pwdIconY;
    _txtPwd=[[UITextField alloc] initWithFrame:CGRectMake(txtPwdX,txtPwdY,ktextfieldWidth, ktextfieldHeight)];
    _txtPwd.secureTextEntry = YES; //密码
    [_txtPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_txtPwd setReturnKeyType:UIReturnKeyDone];
    [pwdView addSubview:_txtPwd];

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
