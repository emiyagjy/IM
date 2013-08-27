//
// UIImage+IMMessageView.h
// 
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.myTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(IMMessagesView)

#pragma mark - Avatar styles 头像样式
- (UIImage *)circleImageWithSize:(CGFloat)size;
- (UIImage *)squareImageWithSize:(CGFloat)size;

- (UIImage *)imageAsCircle:(BOOL)clipToCircle
               withDiamter:(CGFloat)diameter
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              shadowOffSet:(CGSize)shadowOffset;

#pragma mark - Input bar
+ (UIImage *)inputBar;
+ (UIImage *)inputField;

#pragma mark - Bubble cap insets
- (UIImage *)makeStretchableDefaultIncoming;
- (UIImage *)makeStretchableDefaultOutgoing;

- (UIImage *)makeStretchableSquareIncoming;
- (UIImage *)makeStretchableSquareOutgoing;

#pragma mark - Incoming message bubbles
+ (UIImage *)bubbleDefaultIncoming;
+ (UIImage *)bubbleDefaultIncomingSelected;

+ (UIImage *)bubbleDefaultIncomingGreen;

+ (UIImage *)bubbleSquareIncoming;
+ (UIImage *)bubbleSquareIncomingSelected;

#pragma mark - Outgoing message bubbles
+ (UIImage *)bubbleDefaultOutgoing;
+ (UIImage *)bubbleDefaultOutgoingSelected;

+ (UIImage *)bubbleDefaultOutgoingGreen;

+ (UIImage *)bubbleSquareOutgoing;
+ (UIImage *)bubbleSquareOutgoingSelected;

@end
