//
//  IMBaseChatViewController.h
//  IM
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMBubbleMessageCell.h"
#import "IMMessageInputView.h"
#import "UIButton+IMMessagesView.h"


#import "IMShortcutBar.h"

typedef enum {
    IMMessagesViewTimestampPolicyAll = 0,
    IMMessagesViewTimestampPolicyAlternating,
    IMMessagesViewTimestampPolicyEveryThree,
    IMMessagesViewTimestampPolicyEveryFive,
    IMMessagesViewTimestampPolicyCustom
} IMMessagesViewTimestampPolicy;


typedef enum {
    IMMessagesViewAvatarPolicyIncomingOnly = 0,
    IMMessagesViewAvatarPolicyBoth,
    IMMessagesViewAvatarPolicyNone
} IMMessagesViewAvatarPolicy;






@protocol IMMessagesViewDelegate <NSObject>
@required
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text;
- (void)fastPressed:(UIButton *)sender;


- (IMBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath;
- (IMBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (IMMessagesViewTimestampPolicy)timestampPolicy;
- (IMMessagesViewAvatarPolicy)avatarPolicy;
- (IMAvatarStyle)avatarStyle;

@optional
- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@protocol IMMessagesViewDataSource <NSObject>
@required
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)avatarImageForIncomingMessage;
- (UIImage *)avatarImageForOutgoingMessage;
@end


@interface IMBaseChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    // 控制inputView是否移动
    BOOL IsInputViewMove;
    
    // 控制快捷栏是否移动
    BOOL IsShortCutMove;
}


@property (weak, nonatomic) id<IMMessagesViewDelegate> delegate;
@property (weak, nonatomic) id<IMMessagesViewDataSource> dataSource;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) IMMessageInputView *inputToolBarView;
@property (nonatomic,assign) CGFloat previousTextViewContentHeight;

// 快捷栏
@property (nonatomic,strong) IMShortcutBar *imShortcutBar;

//
//@property (nonatomic,strong) NSDictionary *keyboardDictionay;



@property (strong, nonatomic) NSMutableArray *messagesArray;


#pragma mark - Initialization
- (UIButton *)sendButton;

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender;
- (void)fastButtonPressed:(UIButton *)sender;

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)finishSend;
- (void)setBackgroundColor:(UIColor *)color;
- (void)scrollToBottomAnimated:(BOOL)animated;

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification;
- (void)handleWillHideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;



@end
