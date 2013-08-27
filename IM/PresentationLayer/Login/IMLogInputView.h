//
//  IMLogInputView.h
//  IM
//
//  Created by gujy on 13-8-16.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

// 项目内页留言弹出框的背景色
#define COLOR_FOR_InputViewBorder [UIColor colorWithRed:152.0f/255.0f green:154.0f/255.0f blue:153.0f/255.0f alpha:1.0f];


// 小图标的大小
#define kiconHeight 22
#define kiconWidth 22
// 小图标的位置
#define kiconPaddingLeft 5

// 输入文本框的大小
#define ktextfieldWidth 245
#define ktextfieldHeight 22
// 输入文本框的位置
#define ktextFieldleft 40





@interface IMLogInputView : UIView


@property (nonatomic,strong) UITextField *txtAccount;
@property (nonatomic,strong) UITextField *txtPwd;

@end
