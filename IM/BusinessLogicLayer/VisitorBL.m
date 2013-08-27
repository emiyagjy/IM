//
//  VisitorBL.m
//  IM
//
//  Created by gujy on 13-8-14.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

/**
  对访客类业务处理
 */

#import "XMPPIQ.h"
#import "VisitorBL.h"
#import "VisitorDAO.h"
#import "Visitor.h"



@implementation VisitorBL


// 根据iq保存所有访客列表 并读取
-(NSMutableArray*) getAllVisitorData:(XMPPIQ *)iq
{
    /**
      解析xml
     */
    // query
    NSXMLElement *query = [iq elementForName:@"query" xmlns:kXMPPGetVistor];
    // item
    NSArray *itemArray=[query elementsForName:@"item"];
    
    // 把NSXMLElement 传入到类中进行读取
    VisitorDAO *dao = [VisitorDAO sharedManager];
    
    [dao.listData removeAllObjects];
    
    for (NSXMLElement *it in itemArray) {
        
        Visitor *visitor=[[Visitor alloc] init];
        visitor.m_VisitorName=[it attributeStringValueForName:@"name"];
        visitor.m_VisitorIP=[it attributeStringValueForName:@"ip"];
        visitor.m_VisitorJid=[it attributeStringValueForName:@"jid"];
        
        //  读取的状态不是很准确
        visitor.m_VisitorStauts=IMVistorOnline;
        //[it attributeIntValueForName:@"status"];

        
        LOG(@"visitor is %@",[visitor description]);
        
        //if (visitor.m_VisitorStauts!=0) {
             [dao create:visitor];
        //}
        
        
    }
    
    return  [dao findAll];

}

-(NSMutableArray*) removeVisitorWithName:(NSString *) strName
{
    VisitorDAO *dao = [VisitorDAO sharedManager];
    [dao deleteWithName:strName];
    return  [dao findAll];
}


// 查询访客ip地址
-(NSString *) findVisitorIpWithName:(NSString *)strName
{
    VisitorDAO *dao = [VisitorDAO sharedManager];
    return  [dao findVisitorIPWithName:strName];
}



@end
