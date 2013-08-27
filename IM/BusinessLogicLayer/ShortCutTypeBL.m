//
//  ShortCutTypeBL.m
//  IM
//
//  Created by gujy on 13-8-27.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "ShortCutTypeBL.h"
#import "ShortCut.h"
#import "ShortCutType.h"
#import "ShortCutTypeDAO.h"

@implementation ShortCutTypeBL


// 根据iq读取所有快捷用语的列表
// 根据类型区分
-(NSMutableArray*) getAllShortCutDataWithType:(XMPPIQ *)iq
{
    /**
     解析xml
     */
    // query
    NSXMLElement *query = [iq elementForName:@"query" xmlns:kXMPPGetFastWord];
    // 类型
    NSArray *typeArray=[query elementsForName:@"type"];
    
    // 把NSXMLElement 传入到类中进行读取
    ShortCutTypeDAO *dao = [ShortCutTypeDAO sharedManager];
    
    [dao.listData removeAllObjects];
    
    for (NSXMLElement *tyElement in typeArray) {
        // 读取类型
        ShortCutType *type=[[ShortCutType alloc] init];
        type.m_ID=[tyElement attributeStringValueForName:@"typeid"];
        type.m_Text=[tyElement attributeStringValueForName:@"typetext"];
        type.m_OrderID=[tyElement attributeIntegerValueForName:@"order"];
        
        // 读取类型下明细数据
        
        NSArray *itemArray=[tyElement elementsForName:@"item"];
        
        for (NSXMLElement *item in itemArray) {
            ShortCut *sc=[[ShortCut alloc] init];
            sc.m_ID=[item attributeStringValueForName:@"id"];
            sc.m_Content=[item attributeStringValueForName:@"content"];
            sc.m_OrderID=[item attributeIntegerValueForName:@"order"];
            // 添加到type 的数组中
            [type.m_ShortcutArray addObject:sc];
        }
        
        [dao createType:type];
    }
    
    return [dao findAll];
}

// 根据iq读取所有快捷用语的列表
// 不根据类型区分
-(NSMutableArray*) getAllShortCutDataWithNoType:(XMPPIQ *)iq
{
    /**
     解析xml
     */
    // query
    NSXMLElement *query = [iq elementForName:@"query" xmlns:kXMPPGetFastWord];
    // 类型
    NSArray *typeArray=[query elementsForName:@"type"];
    
    // 把NSXMLElement 传入到类中进行读取
    ShortCutTypeDAO *dao = [ShortCutTypeDAO sharedManager];
    
    [dao.listData removeAllObjects];
    
    for (NSXMLElement *tyElement in typeArray) {
//        // 读取类型
//        ShortCutType *type=[[ShortCutType alloc] init];
//        type.m_ID=[tyElement attributeStringValueForName:@"typeid"];
//        type.m_Text=[tyElement attributeStringValueForName:@"typetext"];
//        type.m_OrderID=[tyElement attributeIntegerValueForName:@"order"];
        
        // 读取类型下明细数据
        NSArray *itemArray=[tyElement elementsForName:@"item"];
        
        for (NSXMLElement *item in itemArray) {
            ShortCut *sc=[[ShortCut alloc] init];
            sc.m_ID=[item attributeStringValueForName:@"id"];
            sc.m_Content=[item attributeStringValueForName:@"content"];
            sc.m_OrderID=[item attributeIntegerValueForName:@"order"];
            // 添加到type 的数组中
            [dao createItem:sc];

        }

    }
    return [dao findAll];
    
}




@end
