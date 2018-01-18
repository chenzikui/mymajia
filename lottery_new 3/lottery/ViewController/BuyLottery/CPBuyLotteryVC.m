//
//  CPBuyLotteryVC.m
//  lottery
//
//  Created by wayne on 17/1/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBuyLotteryVC.h"
#import "CPVoiceButton.h"
#import "CPBuyLotteryTableCell.h"
#import "CPBuyLotteryCollectionCell.h"
#import "CPBuyLotteryDetailVC.h"
#import "CPBuyLotteryRoomVC.h"

@interface CPBuyLotteryVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    IBOutlet UIScrollView *_mainScrollView;
    IBOutlet UIView *_headerView;
    
    IBOutlet UIView *_allLotteryItem;
    IBOutlet UIView *_highLotteryItem;
    IBOutlet UIView *_lowLotteryItem;
    
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UITableView *_tableView;
    
    NSArray *_lotteryInfos;
    
    NSArray *_allLotteryInfos;
    NSArray *_highLotteryInfos;
    NSArray *_lowLotteryInfos;
    
    IBOutlet CPVoiceButton *_allLotteryButton;
    IBOutlet CPVoiceButton *_highLotteryButton;
    IBOutlet CPVoiceButton *_lowLotteryButton;
    
    CPVoiceButton *_switchDataViewButton;

    
    NSTimer *_openDateTimer;
    
    BOOL _isQueryInfoIng;

}

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UICollectionView *collectionView;

@property(nonatomic,retain)NSArray *currentLotterys;


@end

@implementation CPBuyLotteryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryBuyLotteryInfo) name:kNotificationNameForBuyLotteryReloadList object:nil];

    
    [_allLotteryButton setBackgroundImage:[UIImage imageNamed:@"goucai_navs_02"] forState:UIControlStateSelected];
    [_highLotteryButton setBackgroundImage:[UIImage imageNamed:@"goucai_navs_03"] forState:UIControlStateSelected];
    [_lowLotteryButton setBackgroundImage:[UIImage imageNamed:@"goucai_navs_04"] forState:UIControlStateSelected];

    
    [_tableView registerNib:[UINib nibWithNibName:@"CPBuyLotteryTableCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPBuyLotteryTableCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"CPBuyLotteryCollectionCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CPBuyLotteryCollectionCell class])];
    self.lotteryKind = CPBuyLotteryKindAll;
    self.showKind = CPBuyLotteryShowKindTable;
    
    _mainScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryBuyLotteryInfo];
    }];
    
    [_mainScrollView.mj_header beginRefreshing];
    
    _switchDataViewButton = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    _switchDataViewButton.frame = CGRectMake(0, 0, 65, 30);
    [_switchDataViewButton setBackgroundImage:[UIImage imageNamed:@"goucai_qiehua_03"] forState:UIControlStateNormal];
    [_switchDataViewButton setBackgroundImage:[UIImage imageNamed:@"goucai_qiehua_07"] forState:UIControlStateSelected];
    [_switchDataViewButton addTarget:self action:@selector(switchShowDataView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_switchDataViewButton];
    
    [[CPTimeManager shareTimeManager]reloadBeiJingTime];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_openDateTimer) {
        _openDateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadOpenDate) userInfo:nil repeats:YES];
    }
    if (!_tableView.mj_header.isRefreshing) {
        [self queryBuyLotteryInfo];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_openDateTimer.isValid) {
        [_openDateTimer invalidate];
        _openDateTimer = nil;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_openDateTimer invalidate];
    _openDateTimer = nil;

}

-(void)reloadOpenDate
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForBuyLotteryCountTime object:nil];
    
}

#pragma mark- network

-(void)queryBuyLotteryInfo
{
 
    @synchronized (self) {
        if (_isQueryInfoIng) {
            return;
        }else{
            _isQueryInfoIng = YES;
        }
    }
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIHall
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               _isQueryInfoIng = NO;
               
               if (_mainScrollView.mj_header.isRefreshing) {
                   [_mainScrollView.mj_header endRefreshing];
               }
               
               if (request.resultIsOk) {
                   
                   _allLotteryInfos = [DWParsers getObjectListByName:@"CPLotteryModel" fromArray: [request.businessData DWArrayForKey:@"all"]];
                   _highLotteryInfos = [DWParsers getObjectListByName:@"CPLotteryModel" fromArray: [request.businessData DWArrayForKey:@"gpc"]];
                   _lowLotteryInfos = [DWParsers getObjectListByName:@"CPLotteryModel" fromArray: [request.businessData DWArrayForKey:@"dpc"]];;
                   
                   [self reloadDataView];
                   
               }else{
                   
                   [WSProgressHUD showErrorWithStatus:request.requestDescription];
               }
               
           } failure:^(__kindof SUMRequest *request) {
               
               _isQueryInfoIng = NO;

               if (_mainScrollView.mj_header.isRefreshing) {
                   [_mainScrollView.mj_header endRefreshing];
               }
           }];
}

#pragma mark- extension

-(void)reloadDataView
{
    if (self.showKind == CPBuyLotteryShowKindTable) {
        [_tableView reloadData];
    }else{
        [_collectionView reloadData];
    }
}


#pragma mark- action

-(void)switchShowDataView
{
    self.showKind = _showKind == CPBuyLotteryShowKindTable?CPBuyLotteryShowKindCollection:CPBuyLotteryShowKindTable;
}

- (IBAction)headerViewItemAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
        {
            //全部
            self.lotteryKind = CPBuyLotteryKindAll;
            
        }break;
        case 11:
        {
            //高频
            self.lotteryKind = CPBuyLotteryKindHighFrequency;
            
        }break;
        case 12:
        {
            //低频
            self.lotteryKind = CPBuyLotteryKindLowFrequency;
            
        }break;
            
        default:
            break;
    }
    
    [self reloadDataView];
    
}


#pragma mark- getter

-(NSArray *)currentLotterys
{
    switch (self.lotteryKind) {
        case CPBuyLotteryKindAll:
        {
            return _allLotteryInfos;
        }break;
        case CPBuyLotteryKindHighFrequency:
        {
            return _highLotteryInfos;
        }break;
        case CPBuyLotteryKindLowFrequency:
        {
            return _lowLotteryInfos;
        }break;
        default:
            break;
    }
    return [NSArray new];
}

#pragma mark- setter

-(void)setShowKind:(CPBuyLotteryShowKind)showKind
{
    _showKind = showKind;
    if (_showKind == CPBuyLotteryShowKindTable) {
        
        _tableView.hidden = NO;
        _collectionView.hidden = YES;
        _switchDataViewButton.selected = NO;
        
    }else{
        
        _tableView.hidden = YES;
        _collectionView.hidden = NO;
        _switchDataViewButton.selected = YES;

    }
    
    [self reloadDataView];
}


-(void)setLotteryKind:(CPBuyLotteryKind)lotteryKind
{
    _lotteryKind = lotteryKind;
    switch (_lotteryKind) {
        case CPBuyLotteryKindAll:
        {
            _allLotteryItem.backgroundColor = kCOLOR_R_G_B_A(202, 31, 37, 1);
            _highLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            _lowLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);

            _allLotteryButton.selected = YES;
            _highLotteryButton.selected = NO;
            _lowLotteryButton.selected = NO;
            
        }break;
        case CPBuyLotteryKindHighFrequency:
        {
            _highLotteryItem.backgroundColor = kCOLOR_R_G_B_A(202, 31, 37, 1);
            _allLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            _lowLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            
            _allLotteryButton.selected = NO;
            _highLotteryButton.selected = YES;
            _lowLotteryButton.selected = NO;
        }break;
        case CPBuyLotteryKindLowFrequency:
        {
            _lowLotteryItem.backgroundColor = kCOLOR_R_G_B_A(202, 31, 37, 1);
            _highLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            _allLotteryItem.backgroundColor = kCOLOR_R_G_B_A(23, 23, 25, 1);
            
            _allLotteryButton.selected = NO;
            _highLotteryButton.selected = NO;
            _lowLotteryButton.selected = YES;
        }break;
            
        default:
            break;
    }
}

#pragma mark- tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CPLotteryModel *model = self.currentLotterys[indexPath.row];
    return [CPBuyLotteryTableCell cellHeightByLotteryModel:model cellWidth:kScreenSize.width];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentLotterys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPBuyLotteryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPBuyLotteryTableCell class])];
    CPLotteryModel *model = self.currentLotterys[indexPath.row];
    cell.lotteryModel = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CPGlobalDataManager playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPLotteryModel *model = self.currentLotterys[indexPath.row];
    if ([model.status intValue] == -1) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"该彩种维护中，请选择其他彩种下注！"];
        return;
    }
    [self queryBuyLotteryInfoWithGid:model.num lotteryName:model.name];
}

#pragma mark- collectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currentLotterys.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPBuyLotteryCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CPBuyLotteryCollectionCell class]) forIndexPath:indexPath];
    CPLotteryModel *model = self.currentLotterys[indexPath.row];
    cell.lotteryModel = model;
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake((_collectionView.width)/3.0f, (_collectionView.width)/3.0f);
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [CPGlobalDataManager playButtonClickVoice];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CPLotteryModel *model = self.currentLotterys[indexPath.row];
    if ([model.status intValue] == -1) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"该彩种维护中，请选择其他彩种下注！"];
        return;
    }
    [self queryBuyLotteryInfoWithGid:model.num lotteryName:model.name];
}

#pragma mark- network

-(void)queryBuyLotteryInfoWithGid:(NSString *)gid
                      lotteryName:(NSString *)lotteryName
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];

    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:gid forKey:@"gid"];

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
                       vc.lotteryName = lotteryName;
                       vc.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:vc animated:YES];
                   }else{
                       
                       CPBuyLotteryRoomVC *vc = [CPBuyLotteryRoomVC new];
                       vc.lotteryName = lotteryName;
                       vc.roomList = [request.businessData DWArrayForKey:@"roomList"];
                       vc.gid = gid;
                       vc.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:vc animated:YES];
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
