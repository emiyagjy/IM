//
//  IMDismissTextView.h
//  MyChatViewController
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.myTest. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IMDismissiveTextViewDelegate <NSObject>

@optional
- (void)keyboardDidShow;
- (void)keyboardDidScrollToPoint:(CGPoint)pt;
- (void)keyboardWillBeDismissed;
- (void)keyboardWillSnapBackToPoint:(CGPoint)pt;

@end



@interface IMDismissiveTextView : UITextView

@property (weak, nonatomic) id<IMDismissiveTextViewDelegate> keyboardDelegate;
@property (strong, nonatomic) UIPanGestureRecognizer *dismissivePanGestureRecognizer;

@end
