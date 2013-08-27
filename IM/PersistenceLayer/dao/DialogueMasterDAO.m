//
//  IMDBDialogueMasterDAO.m
//  IM
//
//  Created by gujy on 13-8-21.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
 对主聊天数据进行控制
 */


#import "DialogueMasterDAO.h"

static DialogueMasterDAO *sharedManager=nil;

@implementation DialogueMasterDAO

@synthesize listData=_listData;
@synthesize dbDialogueMaster=_dbDialogueMaster;



+(DialogueMasterDAO*)sharedManager{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedManager=[[DialogueMasterDAO alloc] init];
    });
    
    return sharedManager;
}



- (id) init
{
    self=[super init];
    if (self) {
        _listData=[[NSMutableArray alloc] initWithCapacity:0];
        _dbDialogueMaster=[[IMDBDialogueMaster alloc] init];
        [_dbDialogueMaster createTable];
    }
    
    return self;
}

// 保存聊天记录
- (int) create:(DialogueMaster*) model
{
  
    // 判断是否存在相同的JID
    if ([self checkDataWithJID:model.m_JID]) {
        // 存在
        return 1;
        
    }else{
        
        [_dbDialogueMaster setDialogue:model];
        [_dbDialogueMaster insertTable];
    }
    return 0;
}

//查询所有聊天记录
- (NSMutableArray*) findAll
{
    FMResultSet *resultSet=[_dbDialogueMaster findData];
    // 移除再添加
    [_listData removeAllObjects];
    while ([resultSet next]) {
        DialogueMaster *model=[[DialogueMaster alloc] init];
        model.m_ID = [resultSet intForColumn:@"ID"];
        model.m_JID= [resultSet stringForColumn:@"JID"];
        model.m_IP=[resultSet stringForColumn:@"IP"];
        model.m_Date=[resultSet dateForColumn:@"DATE"];
        model.m_Status=[resultSet intForColumn:@"STATUS"];
        [_listData addObject:model];
    }
    return _listData;
}

// 根据jid,读取聊天ID
- (NSUInteger) findID:(NSString *) strJID
{
    for (DialogueMaster *model in _listData) {
        if([model.m_JID isEqualToString:strJID])
        {
            return model.m_ID;
        }
    }
    
    return 0;
}


// 移除聊天记录
- (int) deleteWithName:(NSString *) strName
{
    
}


// 根据JID判断有无重复记录
-(BOOL) checkDataWithJID:(NSString *)strJID
{
    NSString *strCondition=[NSString stringWithFormat:@"JID=\"%@\"",strJID];
   return [_dbDialogueMaster checkData:strCondition];
}






@end
