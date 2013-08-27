//
//  IMBubbleMessageCell.h
//  MyChatViewController
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.myTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMBubbleView.h"
typedef enum {
    IMAvatarStyleCircle = 0,
    IMAvatarStyleSquare,
    IMAvatarStyleNone
} IMAvatarStyle;

@interface IMBubbleMessageCell : UITableViewCell

#pragma mark - Initialization
- (id)initWithBubbleType:(IMBubbleMessageType)type
             bubbleStyle:(IMBubbleMessageStyle)bubbleStyle
             avatarStyle:(IMAvatarStyle)avatarStyle
            hasTimestamp:(BOOL)hasTimestamp
         reuseIdentifier:(NSString *)reuseIdentifier;

#pragma mark - Message cell
- (void)setMessage:(NSString *)msg;
- (void)setTimestamp:(NSDate *)date;
- (void)setAvatarImage:(UIImage *)image;

+ (CGFloat)neededHeightForText:(NSString *)bubbleViewText
                     timestamp:(BOOL)hasTimestamp
                        avatar:(BOOL)hasAvatar;


@end
