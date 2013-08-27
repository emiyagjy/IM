//
//  IMChatViewController.m
//  IM
//
//  Created by gujy on 13-8-15.
//  Copyright (c) 2013年 com.tonglukuaijian.IM. All rights reserved.
//

#import "IMChatViewController.h"

#import "IMTools.h"

#import "Visitor.h"
#import "DialogueDetail.h"

#import "DialogueDetailBL.h"
#import "DialogueMasterBL.h"
#import "ShortCutTypeBL.h"



#define INPUT_HEIGHT 40.0f

@interface IMChatViewController ()

@property (nonatomic,strong) DialogueMasterBL *dialogueMBL;
@property (nonatomic,strong) DialogueDetailBL *dialogueDBL;
@property (nonatomic,strong) ShortCutTypeBL *shortCutTypeBL;

// 聊天列表ID
@property (nonatomic,assign) NSUInteger dialogueMasterID;

//  设置明星哦聊天信息
- (void) setUploadMessage;

@end

@implementation IMChatViewController
@synthesize visitor=_visitor;

@synthesize messageArray=_messageArray;
@synthesize fastWordArray=_fastWordArray;


@synthesize dialogueMBL=_dialogueMBL;
@synthesize dialogueDBL=_dialogueDBL;
@synthesize shortCutTypeBL=_shortCutTypeBL;

@synthesize dialogueMasterID=_dialogueMasterID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// 设置明细聊天信息
- (void) setUploadMessage
{
    if (_visitor) {
        
        // 读取聊天所有列表
        [_dialogueMBL findAllDialogue];
        // 读取主聊天的id, 保存子明细时需要用到,(在sql查询时用来寻找明细聊天记录)
        NSString *strJID=[NSString stringWithFormat:@"%@%@",_visitor.m_VisitorName,@"@10.200.2.6/web"]; // 以后不用写这个了
        
          _dialogueMasterID=[_dialogueMBL findIDWithJID:strJID]; //_visitor.m_VisitorJid
        LOG(@"dialogueMasterID IS %d",_dialogueMasterID);
        if (_dialogueMasterID!=0) {
             _messageArray= [_dialogueDBL findAllDialogueWithID:_dialogueMasterID];
        }else{
            _messageArray=nil;
        }
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
       
    }
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    
    /// 实例化主聊天业务层
    if (!_dialogueMBL) {
        _dialogueMBL=[[DialogueMasterBL alloc] init];
    }
    
    
    /// 实例化聊天明细业务层
    if (!_dialogueDBL) {
        _dialogueDBL=[[DialogueDetailBL alloc] init];
    }
    
    // 设置亏快捷文字
    [self.imShortcutBar setFastwordArray:_fastWordArray];

    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUploadMessage];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


// 更新访客状态
- (void) updateVisitroStatus:(NSUInteger) status
{
    _visitor.m_VisitorStauts=status;
}

// 读取快捷用语
- (void) getFastWordData:(XMPPIQ *)iq
{
    [_shortCutTypeBL getAllShortCutDataWithType:iq];
}


// 发送信息
- (void) Send:(NSString *) strText
{

    if (_visitor.m_VisitorStauts==IMVistorOnline) { // 访客上线
        NSString *toJID=[NSString stringWithFormat:@"%@%@",_visitor.m_VisitorName,@"@10.200.2.6/web"]; // 以后不用写这个了
        
        // 发送消息
        if (_dialogueDBL) {
            // 发送 消息的xml
            [_dialogueDBL sendDialogueWithMessage:strText to:toJID];
            
            // 当无网络时，不保存  //
            
            // 实例化保存聊天明细列表
            DialogueDetail *dialogueDetail=[[DialogueDetail alloc] init];
            
            [dialogueDetail setM_Date:[NSDate date]];
            
            if (_dialogueMasterID!=0) {
                
                [dialogueDetail setM_parentID:_dialogueMasterID];
                
            }else{ // 发送时无聊天记录，新建主聊天记录
                
                // 实例化主聊天列表
                DialogueMaster *dialogueMaster=[[DialogueMaster alloc] init];
                [dialogueMaster setM_Date:[NSDate date]];
                [dialogueMaster setM_IP:_visitor.m_VisitorIP];
                [dialogueMaster setM_JID:toJID];
                [dialogueMaster setM_Status:IMDialogueMasterOnline];
                // 保存主聊天内容
                [_dialogueMBL createDialogue:dialogueMaster];
                
                // 重新根据JID读取ID
                NSString *strJID=[NSString stringWithFormat:@"%@%@",_visitor.m_VisitorName,@"@10.200.2.6/web"]; // 以后不用写这个了
                _dialogueMasterID=[_dialogueMBL findIDWithJID:strJID];
                [dialogueDetail setM_parentID:_dialogueMasterID];
            }
            
            [dialogueDetail setM_Message:strText];
            [dialogueDetail setM_Status:IMDialogueDetailSend];
            
            // 保存对话内容（聊天明细）
           [_dialogueDBL createDialogue:dialogueDetail];
            _messageArray=[_dialogueDBL findAllDialogueWithID:_dialogueMasterID];
            
            // 重新加载tableView
            [super finishSend];
            
        }
    }else{
        
        [IMTools MsgBox:MyLocalString(@"MSG_VISITOR_OFFLINE")];
   
    }
    
}

//  显示快捷文字 弹出框
- (void) showFastWordView
{
    
    
}

//// 发送消息成功
//- (void) SendMsgSuccess
//{
//  
//}



// 收到信息
- (void) finishReceive:(NSArray*) dialogueArray
{
    _messageArray=dialogueArray;
    LOG(@"messages IS %@",_messageArray);

    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
      
}

 

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArray.count;
}


#pragma mark - Messages view delegate

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    //
    [self Send:text];
}


- (void)fastPressed:(UIButton *)sender
{
    
}



 

- (IMBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    DialogueDetail *dialogueDetial=[_messageArray objectAtIndex:indexPath.row];
    
    if (dialogueDetial.m_Status==IMDialogueDetialReceive) {
        return IMBubbleMessageTypeIncoming;
    }else{
    
        return IMBubbleMessageTypeOutgoing;
    }
 
    
}

- (IMBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return JSBubbleMessageStyleSquare;
    
    return IMBubbleMessageStyleDefault;
}

- (IMMessagesViewTimestampPolicy)timestampPolicy
{
    return IMMessagesViewTimestampPolicyEveryThree;
    
}

- (IMMessagesViewAvatarPolicy)avatarPolicy
{
    return IMMessagesViewAvatarPolicyBoth;
}

- (IMAvatarStyle)avatarStyle
{
    return IMAvatarStyleNone;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DialogueDetail *dialogueDetial=[_messageArray objectAtIndex:indexPath.row];
    return dialogueDetial.m_Message;

}

- (NSString *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DialogueDetail *dialogueDetial=[_messageArray objectAtIndex:indexPath.row];
    return dialogueDetial.m_Date;
    //return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"demo-avatar-woz"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}



@end
