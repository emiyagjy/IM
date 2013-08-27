//
//  IMBubbleMessageCell.m
//  MyChatViewController
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.myTest. All rights reserved.
//

#import "IMBubbleMessageCell.h"

#import "UIColor+IMMessageView.h"
#import "UIImage+IMMessageView.h"

#define TIMESTAMP_LABEL_HEIGHT 14.5f

@interface IMBubbleMessageCell()

@property (strong, nonatomic) IMBubbleView *bubbleView;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (assign, nonatomic) IMAvatarStyle avatarImageStyle;

- (void)setup;
- (void)configureTimestampLabel;

- (void)configureWithType:(IMBubbleMessageType)type
              bubbleStyle:(IMBubbleMessageStyle)bubbleStyle
              avatarStyle:(IMAvatarStyle)avatarStyle
                timestamp:(BOOL)hasTimestamp;

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress;
- (void)handleMenuWillHideNotification:(NSNotification *)notification;
- (void)handleMenuWillShowNotification:(NSNotification *)notification;

@end


@implementation IMBubbleMessageCell

#pragma mark - Setup
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    // 自定义长按事件
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPress:)];
    [recognizer setMinimumPressDuration:0.4];
    [self addGestureRecognizer:recognizer];
}

- (void)configureTimestampLabel
{
    self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                    4.0f,
                                                                    self.bounds.size.width,
                                                                    TIMESTAMP_LABEL_HEIGHT)];
    self.timestampLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
    self.timestampLabel.textColor = [UIColor messagesTimestampColor];
    self.timestampLabel.shadowColor = [UIColor whiteColor];
    self.timestampLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.timestampLabel.font = [UIFont boldSystemFontOfSize:11.5f];
    
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView bringSubviewToFront:self.timestampLabel];
}

- (void)configureWithType:(IMBubbleMessageType)type
              bubbleStyle:(IMBubbleMessageStyle)bubbleStyle
              avatarStyle:(IMAvatarStyle)avatarStyle
                timestamp:(BOOL)hasTimestamp
{
    CGFloat bubbleY = 0.0f;
    CGFloat bubbleX = 0.0f;
    
    if(hasTimestamp) {
        [self configureTimestampLabel];
        bubbleY = 14.0f;
    }
    
    CGFloat offsetX = 0.0f;
    
    if(avatarStyle != IMAvatarStyleNone) {
        offsetX = 4.0f;
        bubbleX = kJSAvatarSize;
        CGFloat avatarX = 0.5f;
        
        if(type == IMBubbleMessageTypeOutgoing) {
            avatarX = (self.contentView.frame.size.width - kJSAvatarSize);
            offsetX = kJSAvatarSize - 4.0f;
        }
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(avatarX,
                                                                             self.contentView.frame.size.height - kJSAvatarSize,
                                                                             kJSAvatarSize,
                                                                             kJSAvatarSize)];
        
        
        
        self.avatarImageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                                 | UIViewAutoresizingFlexibleLeftMargin
                                                 | UIViewAutoresizingFlexibleRightMargin);
        [self.contentView addSubview:self.avatarImageView];
    }
    
    CGRect frame = CGRectMake(bubbleX - offsetX,
                              bubbleY,
                              self.contentView.frame.size.width - bubbleX,
                              self.contentView.frame.size.height - self.timestampLabel.frame.size.height);

    self.bubbleView = [[IMBubbleView alloc] initWithFrame:frame
                                               bubbleType:type
                                              bubbleStyle:bubbleStyle];

    [self.contentView addSubview:self.bubbleView];
    [self.contentView sendSubviewToBack:self.bubbleView];
    
}

#pragma mark - Initialization
- (id)initWithBubbleType:(IMBubbleMessageType)type
             bubbleStyle:(IMBubbleMessageStyle)bubbleStyle
             avatarStyle:(IMAvatarStyle)avatarStyle
            hasTimestamp:(BOOL)hasTimestamp
         reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
        self.avatarImageStyle = avatarStyle;
        [self configureWithType:type
                    bubbleStyle:bubbleStyle
                    avatarStyle:avatarStyle
                      timestamp:hasTimestamp];
    }
    return self;
}

- (void)dealloc
{
    self.bubbleView = nil;
    self.timestampLabel = nil;
    self.avatarImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters
- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    [self.contentView setBackgroundColor:color];
    [self.bubbleView setBackgroundColor:color];
}

#pragma mark - Message Cell
- (void)setMessage:(NSString *)msg
{
    self.bubbleView.text = msg;
}

- (void)setTimestamp:(NSString *)strDate
{
    self.timestampLabel.text =strDate;
//    [NSDateFormatter localizedStringFromDate:date
//                                                              dateStyle:NSDateFormatterMediumStyle
//                                                              timeStyle:NSDateFormatterShortStyle];
}

- (void)setAvatarImage:(UIImage *)image
{
    UIImage *styledImg = nil;
    switch (self.avatarImageStyle) {
        case IMAvatarStyleCircle:
            styledImg = [image circleImageWithSize:kJSAvatarSize];
            break;
            
        case IMAvatarStyleSquare:
            styledImg = [image squareImageWithSize:kJSAvatarSize];
            break;
            
        case IMAvatarStyleNone:
        default:
            break;
    }
    
    self.avatarImageView.image = styledImg;
}

+ (CGFloat)neededHeightForText:(NSString *)bubbleViewText timestamp:(BOOL)hasTimestamp avatar:(BOOL)hasAvatar
{
    CGFloat timestampHeight = (hasTimestamp) ? TIMESTAMP_LABEL_HEIGHT : 0.0f;
    CGFloat avatarHeight = (hasAvatar) ? kJSAvatarSize : 0.0f;
    return MAX(avatarHeight, [IMBubbleView cellHeightForText:bubbleViewText]) + timestampHeight;
}

#pragma mark - Copying
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(copy:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.bubbleView.text];
    [self resignFirstResponder];
}

#pragma mark - Touch events
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(![self isFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    [menu update];
    [self resignFirstResponder];
}

#pragma mark - Gestures
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan
       || ![self becomeFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    CGRect targetRect = [self convertRect:[self.bubbleView bubbleFrame]
                                 fromView:self.bubbleView];
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Notification
- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    self.bubbleView.selectedToShowCopyMenu = NO;
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    self.bubbleView.selectedToShowCopyMenu = YES;
}
@end
