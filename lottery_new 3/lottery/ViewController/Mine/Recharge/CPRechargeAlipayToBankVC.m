//
//  CPRechargeAlipayToBankVC.m
//  lottery
//
//  Created by wayne on 2017/9/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeAlipayToBankVC.h"
#import "CPRechargeRecordVC.h"

@interface CPRechargeAlipayToBankVC ()
{
    IBOutlet UILabel *_orderLabel;
    IBOutlet UILabel *_amountLabel;
    IBOutlet UILabel *_alertMsgLabel;
    IBOutlet UILabel *_nameLabel;
    
    IBOutlet UITextView *_bankAccount;
    
    IBOutlet UILabel *_bankName;

    IBOutlet UILabel *_aliasDesLabel;
    IBOutlet UITextField *_aliasTf;
    
    
    
    
}
@end

@implementation CPRechargeAlipayToBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _type == 1?@"微信转银行卡":@"支付宝转银行卡";
    
    _orderLabel.text = [_rechargeInfo DWStringForKey:@"orderNo"];
    _amountLabel.text = [_rechargeInfo DWStringForKey:@"amount"];
    _nameLabel.text = [_rechargeInfo DWStringForKey:@"accountName"];
    _alertMsgLabel.text = [_rechargeInfo DWStringForKey:@"tip"];

    _bankName.text = [_rechargeInfo DWStringForKey:@"bankName"];
    _bankAccount.text = [_rechargeInfo DWStringForKey:@"accountCode"];

    
    if ([[_rechargeInfo DWStringForKey:@"isShow"]intValue] == 1) {
        _aliasDesLabel.hidden = NO;
        _aliasTf.hidden = NO;
        
        if (_type == 1) {
            _aliasTf.placeholder = @"填写您的微信姓名";
            _aliasDesLabel.text = @"存款微信姓名";
        }
        
    }else{
        _aliasDesLabel.hidden = YES;
        _aliasTf.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-

- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 55:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case 66:
        {
            [self querySubmit];
        }break;
            
        default:
            break;
    }
}


#pragma mark-

-(void)querySubmit
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:[_rechargeInfo DWStringForKey:@"orderNo"] forKey:@"orderNo"];
    [paramsDic setObject:[_rechargeInfo DWStringForKey:@"amount"] forKey:@"amount"];
    [paramsDic setObject:[_rechargeInfo DWStringForKey:@"id"] forKey:@"payId"];
    
    if (_aliasTf.text.length>0) {
        [paramsDic setObject:_aliasTf.text forKey:@"inBank"];
    }
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:_type==0?CPSerVerAPINameForAPIUserRalipayBankSubmit:CPSerVerAPINameForAPIUserWechatBankSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   CPRechargeRecordVC *vc = [CPRechargeRecordVC new];
                   vc.hidesBottomBarWhenPushed = YES;
                   [self.navigationController pushViewController:vc animated:YES];
                   [self removeSelfFromNavigationControllerViewControllers];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}



@end
