//
//  IMBubbleView.h
//  MyChatViewController
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.myTest. All rights reserved.
//

#import <UIKit/UIKit.h>


extern CGFloat const kJSAvatarSize;

typedef enum {
    IMBubbleMessageTypeIncoming = 0,
    IMBubbleMessageTypeOutgoing
} IMBubbleMessageType;


typedef enum {
    IMBubbleMessageStyleDefault = 0,
    IMBubbleMessageStyleSquare,
    IMBubbleMessageStyleDefaultGreen
} IMBubbleMessageStyle;

@interface IMBubbleView : UIView

@property (assign, nonatomic) IMBubbleMessageType type;
@property (assign, nonatomic) IMBubbleMessageStyle style;
@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL selectedToShowCopyMenu;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)rect
         bubbleType:(IMBubbleMessageType)bubleType
        bubbleStyle:(IMBubbleMessageStyle)bubbleStyle;

#pragma mark - Drawing
- (CGRect)bubbleFrame;
- (UIImage *)bubbleImage;
- (UIImage *)bubbleImageHighlighted;

#pragma mark - Bubble view
+ (UIImage *)bubbleImageForType:(IMBubbleMessageType)aType
                          style:(IMBubbleMessageStyle)aStyle;

+ (UIFont *)font;

+ (CGSize)textSizeForText:(NSString *)txt;
+ (CGSize)bubbleSizeForText:(NSString *)txt;
+ (CGFloat)cellHeightForText:(NSString *)txt;

+ (int)maxCharactersPerLine;
+ (int)numberOfLinesForMessage:(NSString *)txt;


@end
