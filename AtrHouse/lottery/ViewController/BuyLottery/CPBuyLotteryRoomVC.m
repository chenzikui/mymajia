//
//  CPBuyLotteryRoomVC.m
//  lottery
//
//  Created by wayne on 2017/9/20.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBuyLotteryRoomVC.h"
#import "CPBuyLotteryDetailVC.h"

@interface CPBuyLotteryRoomVC ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
}

@end

@implementation CPBuyLotteryRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.lotteryName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *markReused = @"markReused";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markReused];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:markReused];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *info = _roomList[indexPath.row];
    NSString *imageUrlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[info DWStringForKey:@"image"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil options:SDWebImageRetryFailed];
    cell.textLabel.text = [info DWStringForKey:@"name"];
    cell.detailTextLabel.text = [info DWStringForKey:@"remark"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CPGlobalDataManager playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = _roomList[indexPath.row];
    [self queryBuyLotteryInfoWithRoomId:[info DWStringForKey:@"id"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _roomList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark- network

-(void)queryBuyLotteryInfoWithRoomId:(NSString *)roomId
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:roomId forKey:@"roomId"];
    [paramsDic setObject:_gid forKey:@"gid"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIBuy
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               if (request.resultIsOk) {
                   NSLog(@"%@",request.businessData);
                   NSString *page = [request.businessData DWStringForKey:@"page"];
                   if ([page isEqualToString:@"buy"]) {
                       //购买
                       CPBuyLotteryDetailVC *vc = [CPBuyLotteryDetailVC new];
                       vc.playInfo = request.businessData;
                       vc.lotteryName = _lotteryName;
                       vc.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:vc animated:YES];
                       
                   }else{
                       
                   }
                   [SVProgressHUD way_dismissThenShowInfoWithStatus:nil];
               }else{
                   
                   [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
                   
               }
               
           } failure:^(__kindof SUMRequest *request) {
               [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
               
           }];
    
}




@end
