//
//  IMShortcutBar.m
//  IM
//
//  Created by gujy on 13-8-26.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//


#define Height 30

#import "IMShortcutBar.h"

#import "ShortCut.h"

@implementation IMShortcutBar

@synthesize tableView=_tableView;
@synthesize imShortcutDelegate=_imShortcutDelegate;

@synthesize fastwordArray=_fastwordArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code


        ///
        /// 加载快捷文字列表
        ///
        CGRect tableFrame = CGRectMake(0.0f, 0.0f,frame.size.width,frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
            
    }
    return self;
}




#pragma mark ------- UITableView 协议 -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        if ([_fastwordArray count]>0) {
            return [_fastwordArray count];
        }
 
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// datasouce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSUInteger index=[indexPath row];
    
    if (cell == nil){
        //设置cell 样式
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    
    
    ShortCut *sc=nil;
    if ([_fastwordArray count]>0) {
        sc=[_fastwordArray objectAtIndex:index];
    }
    
    if (sc) {
        [cell.textLabel setText:sc.m_Content];
    }
  
 
   
    return cell;
    
}


// click
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 背景颜色一闪而过
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
     ShortCut *sc=nil;
     NSUInteger index=[indexPath row];
    if ([_fastwordArray count]>0) {
        sc=[_fastwordArray objectAtIndex:index];
    }

    if (sc) {
        if (_imShortcutDelegate&&[_imShortcutDelegate respondsToSelector:@selector(didCellClick:withText:)]) {
            [_imShortcutDelegate didCellClick:self withText:sc.m_Content];
        }
    }
}
@end
