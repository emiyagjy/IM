//
//  IMBaseChatViewController.m
//  IM
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#define kAnimationDuring 0.25f
#define INPUT_HEIGHT 40.0f

#import "IMBaseChatViewController.h"

#import "NSString+IMMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+IMMessageView.h"


@interface IMBaseChatViewController ()<IMDismissiveTextViewDelegate,IMShortcutBarDelegate>

@end

@implementation IMBaseChatViewController
@synthesize tableView=_tableView;
@synthesize inputToolBarView=_inputToolBarView;
@synthesize previousTextViewContentHeight=_previousTextViewContentHeight;

@synthesize messagesArray=_messagesArray;
@synthesize imShortcutBar=_imShortcutBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    ///
    /// UITableView
    ///
    CGSize size = self.view.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f, 0.0f, size.width, size.height - INPUT_HEIGHT);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.view addSubview:self.tableView];
    
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
    
    
    //创建一个点击手势对象，该对象可以调用handelTap：方法  点击用来隐藏底部显示的东西
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
    [self.tableView addGestureRecognizer:tapGes];
    
    ///
    /// inputView
    ///
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[IMMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    
    // TODO: refactor
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    [self.inputToolBarView.textView setScrollEnabled:NO];
    self.inputToolBarView.textView.keyboardDelegate = self;
    [self.view addSubview:self.inputToolBarView];
    
    ///
    /// send button
    ///
    UIButton *sendButton = [self sendButton];
    sendButton.enabled = NO;
    sendButton.frame = CGRectMake(self.inputToolBarView.frame.size.width - 65.0f, 8.0f, 59.0f, 26.0f);
    [sendButton addTarget:self
                   action:@selector(sendPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setSendButton:sendButton];
    
    ///
    /// fast button
    ///
    UIButton *fastButton=[self fastButton];
    fastButton.frame=CGRectMake(3,2,40.0,INPUT_HEIGHT-4);
    [self.inputToolBarView setFastButton:fastButton];
    [fastButton addTarget:self
                   action:@selector(fastButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setFastButton:fastButton];
    
    ///
    /// ShortcutBar
    ///
    _imShortcutBar=[[IMShortcutBar alloc] init];
    // 默认隐藏在底部 y坐标为 frame.height + 键盘的高度
    CGFloat shortY=self.view.frame.size.height;
    [_imShortcutBar setFrame:CGRectMake(0,shortY,SCREEN_WIDTH,IPHONE_KEYBOARD_PROTRAIT)];
    [self.view addSubview:_imShortcutBar];
    [_imShortcutBar setImShortcutDelegate:self];
    
    
    // 发送的消息
    _messagesArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (UIButton *)fastButton
{
    return [UIButton defualtFastButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    IsInputViewMove=YES;
    [self scrollToBottomAnimated:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.inputToolBarView resignFirstResponder];
    
    // 隐藏自定义快捷栏
    [self MyShortcutViewWillshowhide:NO isChangeInputView:YES];
    
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.inputToolBarView = nil;
}


#pragma mark ------ Private Methods ------

// 控制快捷栏的显示和隐藏
// 并且控制inputView是否改变
- (void) MyShortcutViewWillshowhide:(BOOL) isShow isChangeInputView:(BOOL) isChangeInputView
{
    //
    // [self.inputToolBarView.textView resignFirstResponder];
    //  CGRect inputFrame=self.inputToolBarView.frame;
    //  CGFloat inputY=inputFrame.origin.y;
    //
    //  LOG(@"inputY is %f",inputY);
    
    CGFloat y;
    if (isShow) { // 显示快捷栏
        // 计算纵坐标
        y=SCREEN_HEIGHT-IPHONE_KEYBOARD_PROTRAIT;
        //当点击+按钮显示快捷栏时,
        // 1.inputView不动
        // 2.隐藏键盘
        IsInputViewMove=NO;
        [self.inputToolBarView.textView resignFirstResponder];
        
    }else{  // 隐藏快捷栏
        y=SCREEN_HEIGHT;
    }
    
    CGRect shortCutRect=CGRectMake(0,y,SCREEN_WIDTH,IPHONE_KEYBOARD_PROTRAIT);
    CGFloat newY =[self.view convertRect:shortCutRect fromView:nil].origin.y;
    shortCutRect.origin.y=newY;

    // 改变快捷栏和inoputview的坐标
    [UIView animateWithDuration:kAnimationDuring
                     animations:^{
                        // 改变快捷栏坐标
                        [_imShortcutBar setFrame:shortCutRect];
                     }
                     completion:^(BOOL finished) {
                        
                     }];
    
    // 改变inputView坐标
    if (isChangeInputView) {
         [self MyInputViewShow:newY];
    }
   

}

// 改变inputView坐标
- (void) MyInputViewShow:(CGFloat) newY
{
    [UIView animateWithDuration:kAnimationDuring
                     animations:^{
                         
                         /// 如果inputView的坐标不在底部的话
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = newY - inputViewFrame.size.height;
                         
                         LOG(@"inputViewFrameY is %f",inputViewFrameY);
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                         
                     }
                     completion:^(BOOL finished) {
                         IsInputViewMove=YES;
                     }];
    

}




#pragma mark ------ Public Methods ------



-(void)handelTap:(id)sender{
    
    [self.inputToolBarView.textView resignFirstResponder];
    
    // 隐藏自定义快捷栏
    [self MyShortcutViewWillshowhide:NO isChangeInputView:YES];
    
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
    [self.delegate sendPressed:sender
                      withText:[self.inputToolBarView.textView.text trimWhitespace]];
}

#pragma mark - Actions
- (void)fastButtonPressed:(UIButton *)sender
{
    // 显示自定义快捷栏
    [self MyShortcutViewWillshowhide:YES isChangeInputView:YES];
    
    // [self.delegate fastPressed:sender];
    
    //    [self.delegate sendPressed:sender
    //                      withText:[self.inputToolBarView.textView.text trimWhitespace]];
}



#pragma mark - IMShortcutBarDelegate

- (void) didCellClick:(IMShortcutBar *)shortBar withText:(NSString *) strText
{
    [_inputToolBarView.textView setText:strText];
    //[self textViewDidChange:self.inputToolBarView.textView];
    
    self.inputToolBarView.sendButton.enabled = ([_inputToolBarView.textView.text trimWhitespace].length > 0);
    
}

 

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMBubbleMessageType type =[self.delegate messageTypeForRowAtIndexPath:indexPath];
    IMBubbleMessageStyle bubbleStyle =[self.delegate messageStyleForRowAtIndexPath:indexPath];
    IMAvatarStyle avatarStyle =[self.delegate avatarStyle];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasAvatar];
    
    IMBubbleMessageCell *cell = (IMBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(!cell)
        cell = [[IMBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                   avatarStyle:(hasAvatar) ? avatarStyle : IMAvatarStyleNone
                                                  hasTimestamp:hasTimestamp
                                               reuseIdentifier:CellID];
    
    if(hasTimestamp)
        [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
    
    if(hasAvatar) {
        switch (type) {
            case IMBubbleMessageTypeIncoming:
                [cell setAvatarImage:[self.dataSource avatarImageForIncomingMessage]];
                break;
                
            case IMBubbleMessageTypeOutgoing:
                [cell setAvatarImage:[self.dataSource avatarImageForOutgoingMessage]];
                break;
        }
    }
    
 
    [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
    [cell setBackgroundColor:tableView.backgroundColor];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [IMBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
                                          timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                             avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    
    
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy]) {
        case IMMessagesViewTimestampPolicyAll:
            return YES;
            
        case IMMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case IMMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case IMMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case IMMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy]) {
        case IMMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == IMBubbleMessageTypeIncoming;
            
        case IMMessagesViewAvatarPolicyBoth:
            return YES;
            
        case IMMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

- (void)finishSend
{
    [self.inputToolBarView.textView setText:nil];
    [self textViewDidChange:self.inputToolBarView.textView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}


- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
    
    // 隐藏自定义快捷栏 inputView 不变
    [self MyShortcutViewWillshowhide:NO isChangeInputView:NO];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [IMMessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    LOG(@"self.previousTextViewContentHeight is %f",self.previousTextViewContentHeight);
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    LOG(@"changeInHeight IS %f",changeInHeight);
    
    if(changeInHeight != 0.0f) {
        if(!isShrinking)
            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                         }
                         completion:^(BOOL finished) {
                             if(isShrinking)
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    //
    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}


#pragma mark - 显示快键输入文字


#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (IsInputViewMove) {

        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:[UIView animationOptionsForCurve:curve]
                         animations:^{
                             
                             // 改变inputView坐标
                             CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                             // for ipad modal form presentations
                             CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;

                             if(inputViewFrameY > messageViewFrameBottom)
                                 inputViewFrameY = messageViewFrameBottom;
                             
                             self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                      inputViewFrameY,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height);
                             
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                         }
                         completion:^(BOOL finished) {
                             IsInputViewMove=YES;
                         }];
        
        
    }
    
}





#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
//   CGRect inputViewFrame = self.inputToolBarView.frame;
//   CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
//   inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
//   self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
//    CGRect inputViewFrame = self.inputToolBarView.frame;
//    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
//    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
{
//    CGRect inputViewFrame = self.inputToolBarView.frame;
//    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
//    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
//    self.inputToolBarView.frame = inputViewFrame;
}




@end
