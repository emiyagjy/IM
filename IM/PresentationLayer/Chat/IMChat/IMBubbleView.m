//
//  IMBubbleView.m
//  MyChatViewController
//
//  Created by gujy on 13-8-20.
//  Copyright (c) 2013年 com.myTest. All rights reserved.
//

#import "IMBubbleView.h"

#import "UIImage+IMMessageView.h"

CGFloat const kJSAvatarSize = 50.0f;

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f

@interface IMBubbleView()

- (void)setup;

+ (UIImage *)bubbleImageTypeIncomingWithStyle:(IMBubbleMessageStyle)aStyle;
+ (UIImage *)bubbleImageTypeOutgoingWithStyle:(IMBubbleMessageStyle)aStyle;

@end

@implementation IMBubbleView

@synthesize type;
@synthesize style;
@synthesize text;
@synthesize selectedToShowCopyMenu;

#pragma mark - Setup
- (void)setup
{
    self.backgroundColor = [UIColor yellowColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)rect
         bubbleType:(IMBubbleMessageType)bubleType
        bubbleStyle:(IMBubbleMessageStyle)bubbleStyle
{
    self = [super initWithFrame:rect];
    if(self) {
        [self setup];
        self.type = bubleType;
        self.style = bubbleStyle;
    }
    return self;
}

- (void)dealloc
{
    self.text = nil;
}

#pragma mark - Setters
- (void)setType:(IMBubbleMessageType)newType
{
    type = newType;
    [self setNeedsDisplay];
}

- (void)setStyle:(IMBubbleMessageStyle)newStyle
{
    style = newStyle;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)newText
{
    text = newText;
    [self setNeedsDisplay];
}

- (void)setSelectedToShowCopyMenu:(BOOL)isSelected
{
    selectedToShowCopyMenu = isSelected;
    [self setNeedsDisplay];
}

#pragma mark - Drawing
- (CGRect)bubbleFrame
{
    CGSize bubbleSize = [IMBubbleView bubbleSizeForText:self.text];
    return CGRectMake((self.type == IMBubbleMessageTypeOutgoing ? self.frame.size.width - bubbleSize.width : 0.0f),
                      kMarginTop,
                      bubbleSize.width,
                      bubbleSize.height);
}

- (UIImage *)bubbleImage
{
    return [IMBubbleView bubbleImageForType:self.type style:self.style];
}

- (UIImage *)bubbleImageHighlighted
{
    switch (self.style) {
        case IMBubbleMessageStyleDefault:
        case IMBubbleMessageStyleDefaultGreen:
            return (self.type == IMBubbleMessageTypeIncoming) ? [UIImage bubbleDefaultIncomingSelected] : [UIImage bubbleDefaultOutgoingSelected];
            
        case IMBubbleMessageStyleSquare:
            return (self.type == IMBubbleMessageTypeIncoming) ? [UIImage bubbleSquareIncomingSelected] : [UIImage bubbleSquareOutgoingSelected];
            
        default:
            return nil;
    }
}

- (void)drawRect:(CGRect)frame
{
    [super drawRect:frame];
    
	UIImage *image = (self.selectedToShowCopyMenu) ? [self bubbleImageHighlighted] : [self bubbleImage];
    
    CGRect bubbleFrame = [self bubbleFrame];
	[image drawInRect:bubbleFrame];
	
	CGSize textSize = [IMBubbleView textSizeForText:self.text];
	
    CGFloat textX = image.leftCapWidth - 3.0f + (self.type == IMBubbleMessageTypeOutgoing ? bubbleFrame.origin.x : 0.0f);
    
    CGRect textFrame = CGRectMake(textX,
                                  kPaddingTop + kMarginTop,
                                  textSize.width,
                                  textSize.height);
    
	[self.text drawInRect:textFrame
                 withFont:[IMBubbleView font]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentLeft];
}

#pragma mark - Bubble view
+ (UIImage *)bubbleImageForType:(IMBubbleMessageType)aType style:(IMBubbleMessageStyle)aStyle
{
    switch (aType) {
        case IMBubbleMessageTypeIncoming:
            return [self bubbleImageTypeIncomingWithStyle:aStyle];
            
        case IMBubbleMessageTypeOutgoing:
            return [self bubbleImageTypeOutgoingWithStyle:aStyle];
            
        default:
            return nil;
    }
}

+ (UIImage *)bubbleImageTypeIncomingWithStyle:(IMBubbleMessageStyle)aStyle
{
    switch (aStyle) {
        case IMBubbleMessageStyleDefault:
            return [UIImage bubbleDefaultIncoming];
            
        case IMBubbleMessageStyleSquare:
            return [UIImage bubbleSquareIncoming];
            
        case IMBubbleMessageStyleDefaultGreen:
            return [UIImage bubbleDefaultIncomingGreen];
            
        default:
            return nil;
    }
}

+ (UIImage *)bubbleImageTypeOutgoingWithStyle:(IMBubbleMessageStyle)aStyle
{
    switch (aStyle) {
        case IMBubbleMessageStyleDefault:
            return [UIImage bubbleDefaultOutgoing];
            
        case IMBubbleMessageStyleSquare:
            return [UIImage bubbleSquareOutgoing];
            
        case IMBubbleMessageStyleDefaultGreen:
            return [UIImage bubbleDefaultOutgoingGreen];
            
        default:
            return nil;
    }
}

+ (UIFont *)font
{
    return [UIFont systemFontOfSize:16.0f];
}

+ (CGSize)textSizeForText:(NSString *)txt
{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width * 0.75f;
    CGFloat height = 20;// MAX([IMBubbleView numberOfLinesForMessage:txt],
                        // [txt numberOfLines]) * [JSMessageInputView textViewLineHeight];
    
    return [txt sizeWithFont:[IMBubbleView font]
           constrainedToSize:CGSizeMake(width - kJSAvatarSize, height + kJSAvatarSize)
               lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)bubbleSizeForText:(NSString *)txt
{
	CGSize textSize = [IMBubbleView textSizeForText:txt];
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGFloat)cellHeightForText:(NSString *)txt
{
    return [IMBubbleView bubbleSizeForText:txt].height + kMarginTop + kMarginBottom;
}

+ (int)maxCharactersPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (int)numberOfLinesForMessage:(NSString *)txt
{
    return (txt.length / [IMBubbleView maxCharactersPerLine]) + 1;
}

@end
