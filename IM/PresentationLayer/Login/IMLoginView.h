//
//  IMLoginView.h
//  IM
//
//  Created by gujy on 13-8-16.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <UIKit/UIKit.h>


#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

// 背景色
#define COLOR_FOR_BgView [UIColor colorWithRed:151.0f/255.0f green:0.0f/255.0f blue:8.0f/255.0f alpha:1.0f]

// 头部的大小
#define kHeadViewHeight 170

// 中间内容页大小
#define kContenHeight 152

// 文本视图里屏幕的间距
// logininputView  离屏幕上边以及左边的距离
#define kPaddingLeft_logInputView 15.0f
#define klogInputViewHeight 90
#define klogInputViewWidth  290

#define kBtnLoginPaddingInputView 20
 
@class IMLogInputView;

@protocol IMLoginViewDelegate;

@interface IMLoginView : UIScrollView
{
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
}




// 委托
@property (nonatomic,weak) id<IMLoginViewDelegate> loginDelegate;


@end


@protocol IMLoginViewDelegate<NSObject>

@optional
- (void)  didloginClick:(NSString *)strUserId withPwd:(NSString *) strPwd;

@end

