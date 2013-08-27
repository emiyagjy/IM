//
//  IMShortcutBar.h
//  IM
//
//  Created by gujy on 13-8-26.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMShortcutBarDelegate;

@interface IMShortcutBar : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)  id<IMShortcutBarDelegate> imShortcutDelegate;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *fastwordArray;


@end

@protocol IMShortcutBarDelegate <NSObject>


- (void) didCellClick:(IMShortcutBar *)shortBar withText:(NSString *) strText;

@end

