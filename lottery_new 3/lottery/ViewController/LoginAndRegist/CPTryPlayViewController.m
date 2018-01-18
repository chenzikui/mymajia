//
//  CPTryPlayViewController.m
//  lottery
//
//  Created by wayne on 2017/8/4.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPTryPlayViewController.h"
#import "CPLookForPasswordVC.h"


@interface CPTryPlayViewController ()
{
    IBOutlet UITextField *_tfName;
    IBOutlet UITextField *_tfPassword;
    
}
@end

@implementation CPTryPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"试玩";
    _tfName.userInteractionEnabled = NO;
    [self queryTryPlayLoginUserName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)loadKefuWebView
{
    CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:[[NSString alloc]initWithString:[CPGlobalDataManager shareGlobalData].kefuUrlString]];
    toWebVC.title = @"客服";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            //客服
            if ([CPGlobalDataManager shareGlobalData].kefuUrlString) {
                [self loadKefuWebView];
            }else{
                [self queryKefuUrlString];
            }
            
        }break;
        case 102:
        {
            //忘记密码
            CPLookForPasswordVC *registVC = [CPLookForPasswordVC new];
            [self.navigationController pushViewController:registVC animated:YES];
        }break;
        case 103:
        {
            //登录
            if (_tfName.text.length == 0) {
                [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入账号" dismissAfterInterval:2 onView:self.view centerOffset:UIOffsetMake(0, -32-28)];
                return;
            }
            if (_tfPassword.text.length == 0) {
                [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入密码" dismissAfterInterval:2 onView:self.navigationController.view];
                return;
            }
            [self.view endEditing:YES];
            [self queryLoginWithUserName:_tfName.text password:_tfPassword.text];
            

        }break;
            
        default:
            break;
    }
}

-(void)queryKefuUrlString
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIKefu
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSString *urlString = [request.resultInfo DWStringForKey:@"data"];
                   [CPGlobalDataManager shareGlobalData].kefuUrlString = urlString;
                   [self loadKefuWebView];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
               [self.navigationController popViewControllerAnimated:YES];
               
           }];
    
}

-(void)queryTryPlayLoginUserName
{
    
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIFreeUserCode
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSString *userName = [request.resultInfo DWStringForKey:@"data"];
                   _tfName.text = userName;
                   
               }else{
                   alertMsg = request.requestDescription;
                   [self.navigationController popViewControllerAnimated:YES];
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];

}
-(void)queryLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSDictionary *paramsDic = @{@"userName":userName,@"password":password,@"token":[SUMUser shareUser].token,@"deviceType":@"2"};

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIFreeUserSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {

               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSString *token = [request.resultInfo DWStringForKey:@"token"];
                   [[SUMUser shareUser]addToken:token];
                   [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                   alertMsg = @"登录成功";
                   [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForLoginSucceed object:nil];

               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

@end
