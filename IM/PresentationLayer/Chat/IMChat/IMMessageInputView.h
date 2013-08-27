//
//  IMMessageInputView.h
//  MyChatViewController
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.myTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMDismissiveTextView.h"


@interface IMMessageInputView : UIImageView

@property (strong, nonatomic) IMDismissiveTextView *textView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *fastButton;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
           delegate:(id<UITextViewDelegate>)delegate;

#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

+ (CGFloat)textViewLineHeight;
+ (CGFloat)maxLines;
+ (CGFloat)maxHeight;


@end
