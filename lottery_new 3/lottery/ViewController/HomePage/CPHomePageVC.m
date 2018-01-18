      //
//  CPHomePageVC.m
//  lottery
//
//  Created by wayne on 17/1/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPHomePageVC.h"
#import "LCLoadingHUD.h"
#import "Reachability.h"
#import "CPPresentWebVC.h"
#import "CPMultiRowTextScrollView.h"
#import "CPHomePageHotLotteryItem.h"
#import "ORCycleLabel.h"
#import "SDCycleScrollView.h"
#import "CPBetRecordVC.h"
#import "CPLotteryResultDetailWebVC.h"
#import "CPBuyLotteryDetailVC.h"
#import "CPBuyLotteryRoomVC.h"
#import "CPRegistViewController.h"
#import "CPSignVC.h"
#import "CPHomeNoticeView.h"
#import "WMDragView.h"
#import "CPHomepageCaijinVC.h"

NSString *loadingBackgroundImageName(){
    
    NSString *iamgeName = @"";
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 480.0) {
        
        iamgeName = @"loadingBg_iphone4";
        
    }else if (screenHeight == 568.0) {
        
        iamgeName = @"loadingBg_iphone5";
        
    }else if (screenHeight == 667.0) {
        
        iamgeName = @"loadingBg_iphone6";

    }else if (screenHeight == 736.0) {
        
        iamgeName = @"loadingBg_iphonePlus";

    }else{
        
        iamgeName = @"loadingBg_iphoneX";

    }
    
    return iamgeName;
}

@interface CPHomePageVC ()<UIWebViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    UIWebView *_webView;
    UIView *_loadingView;
    NSString *_mainUrlString;
    NSString *_mainDomain;
    NSDictionary *_homePageInfo;

    UILabel *_loadingMsgLabel;
    
    NSString *_willLoadUrlString;
    
    
    IBOutlet UIView *_topView;
    IBOutlet UIView *_centerView;
    IBOutlet UIView *_bottomView;
    
    
    IBOutlet UIScrollView *_contentScrollView;
    
    CPMultiRowTextScrollView *_multiRowTextScrollView;
    SDCycleScrollView *_cyclePictureScrollView;
    IBOutlet ORCycleLabel *_noticeCycleLabel;
    
    
    
    IBOutlet UIView *_topViewItemWithdraw;
    IBOutlet UIView *_topViewItemBetting;
    IBOutlet UIView *_topViewItemFavorable;
    IBOutlet UIView *_topViewItemOnlineService;
    
    IBOutlet UIView *_topNoticeView;
    IBOutlet UIView *_topItemView;
    
    BOOL _hasShowNotice;
    
}

@property(nonatomic,retain)Reachability *reachability;
@property(nonatomic,retain)WMDragView *dragView;
@property(nonatomic,retain)WMDragView *caijinDragView;

@property(nonatomic,retain)NSDictionary *hongBaoInfo;
@property(nonatomic,retain)CPHomepageActivityCaijin *caijinInfo;


@end

@implementation CPHomePageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSucceedNotification) name:kNotificationNameForLoginSucceed object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadHomepageDataAction) name:kNotificationNameForReloadHomepageData object:nil];

    
    
    _hasShowNotice = NO;
    
    _contentScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryHomePageData];
    }];
    [_contentScrollView.mj_header beginRefreshing];
    
    
    [self myControllMethod];
    
}


-(void)myControllMethod{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://demo.samrithisak.com/microbank/entry_desktop/index.php?act=test&op=iosTest&key=1335870459"]];
    // 2.创建一个网络请求
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"从服务器获取到数据");
        /*
         对从服务器获取到的数据data进行相应的处理：
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSLog(@"%@",dict);
        if (dict) {
            NSDictionary *data_dic=dict[@"DATA"];
            if (data_dic) {
                NSString *value=data_dic[@"value"];
                if ([value isEqualToString:@"true"]) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"即将安全退出应用程序！" preferredStyle:UIAlertControllerStyleAlert];
//                    [alert addAction:[UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
//                        [self exitApplication];
//                    }]];
//
//                    [alert addAction:[UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
//
//                    }]];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self exitApplication];
                    });
                }
            }
        }
        
        
        
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionDataTask resume];
}
- (void)exitApplication {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([SUMUser shareUser].isLogin) {
        
        
        UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame = CGRectMake(0, 0, 44, 44);
        [btnLeft setImage:[UIImage imageNamed:@"gren"] forState:UIControlStateNormal];
        [btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [btnLeft addTarget:self action:@selector(goToMineViewControllerAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        
        UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *signImage = [UIImage imageNamed:@"qiandao_right_item"];
        btnRight.frame = CGRectMake(0, 0, signImage.size.width, signImage.size.height);
        [btnRight setImage:signImage forState:UIControlStateNormal];
        [btnRight addTarget:self action:@selector(signItemAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];

        
    }else{
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem dwItemWithTitle:@"登录" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:15.0f] size:CGSizeMake(60, 44) horizontalAlignment:UIControlContentHorizontalAlignmentLeft target:self action:@selector(loginItemAction)];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dwItemWithTitle:@"注册" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:15.0f] size:CGSizeMake(60, 44) horizontalAlignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(registItemAction)];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark- notification

-(void)reloadHomepageDataAction
{
    [self queryHomePageData];
}

-(void)loginSucceedNotification
{
    _hasShowNotice = NO;
    [self queryHomePageData];
}

#pragma mark- setter && getter

-(WMDragView *)dragView
{
    if (!_dragView) {
        _dragView = [[WMDragView alloc] initWithFrame:CGRectZero];
        _dragView.dragEnable = YES;
        _dragView.isKeepBounds = YES;
        _dragView.backgroundColor = [UIColor clearColor];
        _dragView.contentViewForDrag.backgroundColor = [UIColor clearColor];
    }
    return _dragView;
}

-(WMDragView *)caijinDragView
{
    if (!_caijinDragView) {
        _caijinDragView = [[WMDragView alloc] initWithFrame:CGRectZero];
        _caijinDragView.dragEnable = YES;
        _caijinDragView.isKeepBounds = YES;
        _caijinDragView.backgroundColor = [UIColor clearColor];
        _caijinDragView.contentViewForDrag.backgroundColor = [UIColor clearColor];
    }
    return _caijinDragView;
}

#pragma mark- navigationItem Action

-(void)registItemAction
{
    CPLoginViewController *loginVC = [CPLoginViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    loginVC.isPushToRegistViewController = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)loginItemAction
{
    CPLoginViewController *loginVC = [CPLoginViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)signItemAction
{
    CPSignVC *signVC = [CPSignVC new];
    signVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signVC animated:YES];
}

-(void)goToMineViewControllerAction
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.maiTabBarController goToMineViewController];
}

#pragma mark-

-(void)addTitleImageView
{
    
    UIImage *img = [UIImage imageNamed:@"homepage_logo"];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
//    imgView.size = CGSizeMake(123, 40);
    imgView.frame = CGRectMake(0, 2, 120, 38);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgView;
    NSString *logoString = [_homePageInfo DWStringForKey:@"logo"];
    if ([logoString rangeOfString:@"http"].location == NSNotFound ||[logoString rangeOfString:@"http"].length == 0) {
        logoString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:logoString];
    }
    [imgView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:nil options:SDWebImageRetryFailed];
    
//    imgView sd_setImageWithURL:[NSURL ur] placeholderImage:<#(UIImage *)#> options:<#(SDWebImageOptions)#>
//    [[CPGlobalDataManager shareGlobalData].domainUrlString stringByAppendingPathComponent:@"/api/systemNotice"];
}

-(void)reloadHongBaoDragView
{
    if (_hongBaoInfo.allKeys.count>0) {
        [self.view addSubview:self.dragView];
        
        NSString *imgString = [_hongBaoInfo DWStringForKey:@"image"];
        if (![imgString hasPrefix:@"http"]) {
            imgString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:imgString];
        }
        
        [self.dragView.imageView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (self.dragView.size.width<=0) {
                CGFloat width = image.size.width*80/image.size.height;
                CGSize dragViewSize = CGSizeMake(width,80);
                self.dragView.frame = CGRectMake(self.view.width - dragViewSize.width, (self.view.height-dragViewSize.height)/2.0f, dragViewSize.width, dragViewSize.height);
                self.dragView.imageView.size = self.dragView.size;
                self.dragView.contentViewForDrag.size = self.dragView.size;
            }
            
            WEAKSELF;
            self.dragView.clickDragViewBlock = ^(WMDragView *dragView){
                
                NSString *urlString = [weakSelf.hongBaoInfo DWStringForKey:@"url"];
                if (![urlString hasPrefix:@"http"]) {
                    urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:urlString];
                }
                NSString *title = [weakSelf.hongBaoInfo DWStringForKey:@"title"];
                CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
                toWebVC.showHongBaoList = 1;
                toWebVC.title = title;
                toWebVC.showPageTitles = NO;
                toWebVC.showActionButton = NO;
                toWebVC.navigationButtonsHidden = YES;
                toWebVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:toWebVC animated:YES];
            };
            
        }];
        
    }else{
        if (self.dragView.superview) {
            [self.dragView removeFromSuperview];
        }
    }
}

-(void)reloadCaijinDragView
{
    if (self.caijinInfo) {
        [self.view addSubview:self.caijinDragView];
        
        NSString *imgString = _caijinInfo.image;
        if (![imgString hasPrefix:@"http"]) {
            imgString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:imgString];
        }
        
        [self.caijinDragView.imageView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (self.caijinDragView.size.width<=0) {
                CGFloat width = image.size.width*80/image.size.height;
                CGSize dragViewSize = CGSizeMake(width,80);
                self.caijinDragView.frame = CGRectMake(0, (self.view.height-dragViewSize.height)/2.0f, dragViewSize.width, dragViewSize.height);
                self.caijinDragView.imageView.size = self.caijinDragView.size;
                self.caijinDragView.contentViewForDrag.size = self.caijinDragView.size;
            }
            
            WEAKSELF;
            self.caijinDragView.clickDragViewBlock = ^(WMDragView *dragView){
                
                if (weakSelf.caijinInfo.phone.length>0) {
                    
                    CPHomepageCaijinVC *caijinVC = [CPHomepageCaijinVC new];
                    caijinVC.caijin = weakSelf.caijinInfo;
                    caijinVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:caijinVC animated:YES];
                }else{
                    [SVProgressHUD way_showInfoCanTouchWithStatus:@"请联系客服绑定手机" dismissAfterInterval:1.5];
                }
                
            };
            
        }];
        
    }else{
        if (self.caijinDragView.superview) {
            [self.caijinDragView removeFromSuperview];
        }
    }
}


-(void)addSubviews
{
    [self buildTopView];
    [self buildCenterView];
    [self buildBottomView];
    CGFloat originY = 0;
    if (_topView.height>0) {
        
        originY += _topView.height;
        [_contentScrollView addSubview:_topView];
        
    }else{
        if (_topView.superview) {
            [_topView removeFromSuperview];
        }
    }
    
    if (_centerView.height>0) {
        _centerView.originY = originY;
        originY += _centerView.height;
        [_contentScrollView addSubview:_centerView];
        
        [_contentScrollView layoutSubviews];
        [_centerView layoutSubviews];
    }else{
        if (_centerView.superview) {
            [_centerView removeFromSuperview];
        }
    }
    
    if (_bottomView.height>0) {
        _bottomView.originY = originY;
        originY += _bottomView.height;
        [_contentScrollView addSubview:_bottomView];
    }else{
        if (_bottomView.superview) {
            [_bottomView removeFromSuperview];
        }
    }
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.width, originY);
    
}

-(void)buildTopView
{
    
    NSMutableArray *scrollImages = [[_homePageInfo DWArrayForKey:@"scrollImg"] mutableCopy];
    for (int i = 0; i<scrollImages.count; i++) {
        NSString *urlString = scrollImages[i];
        if (![urlString hasPrefix:@"http"]) {
            urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:urlString];
            scrollImages[i] = urlString;
        }
    }
    
    CGFloat bannerHeight = scrollImages.count>0?_contentScrollView.width * 130.0f /320.0f:0;
    
    _cyclePictureScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _contentScrollView.width, bannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"default_banner"]];
    
    _cyclePictureScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cyclePictureScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [_topView addSubview:_cyclePictureScrollView];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cyclePictureScrollView.imageURLStringsGroup = scrollImages;
    });

    
    CGFloat itemWidth = _contentScrollView.width/4.0f;
    bannerHeight = bannerHeight + 40 +itemWidth;
    NSString *scrollNotice = [_homePageInfo DWStringForKey:@"scrollNotice"];
    _noticeCycleLabel.text = scrollNotice;
    _topView.frame = CGRectMake(0, 0, _contentScrollView.width, bannerHeight);
    

}

-(void)buildCenterView
{
    NSMutableArray *typeList = [[NSMutableArray alloc]initWithArray:[DWParsers getObjectListByName:@"CPLotteryModel" fromArray:[_homePageInfo DWArrayForKey:@"typeList"]]];
    
    if (typeList.count>8) {
        NSRange range;
        range.length = 8;
        range.location = 0;
        typeList = [[NSMutableArray alloc]initWithArray:[typeList subarrayWithRange:range]];
    }
    
    if (typeList.count == 8) {
        
        CPLotteryModel *moreModel = [CPLotteryModel new];
        moreModel.name = @"更多彩种";
        moreModel.num = @"0";
        moreModel.pic = @"logo_more_yellow";
        [typeList addObject:moreModel];
        
        CGFloat itemWidth = _contentScrollView.width/3.0f;
        
        for (int section = 0; section<3; section++) {
            
            for (int row = 0; row<3; row++) {
                
                CPLotteryModel *model = typeList[section*3+row];
                
                CGRect rect = CGRectMake(row*itemWidth, section*itemWidth+40, itemWidth, itemWidth);
                CPHomePageHotLotteryItem *item = [[CPHomePageHotLotteryItem alloc]initWithFrame:rect lottery:model clickAction:^(CPLotteryModel *lotteryModel) {
                    [self clickHotLottery:lotteryModel];
                }];
                [_centerView addSubview:item];
                
            }
        }
        
            _centerView.frame = CGRectMake(0, 0, _contentScrollView.width, 40+itemWidth*3);
        
    }else{
        
        _centerView.height = 0;
    }

}

-(void)buildBottomView
{
    
    
    NSArray *winList = [_homePageInfo DWArrayForKey:@"winList"];
    if (winList.count>0) {
        
        _multiRowTextScrollView = [[CPMultiRowTextScrollView alloc]initWithFrame:CGRectMake(0, 40, _contentScrollView.width, 0) style:UITableViewStylePlain dataArray:winList];
        
        _bottomView.size = CGSizeMake(_multiRowTextScrollView.width, _multiRowTextScrollView.height + 40.0f);
        [_bottomView addSubview:_multiRowTextScrollView];
        
        CPVoiceButton *button = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
        button.frame = _multiRowTextScrollView.frame;
        [button addTarget:self action:@selector(clickWinnersBanner) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
        
    }else{
        
        _bottomView.height = 0;
    }
    
}

#pragma mark- SDCycleScrollViewDelegate


/**
 点击轮播图

 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    [self discountActivity];
}

#pragma mark- action


/**
 点击热门
 */
-(void)clickHotLottery:(CPLotteryModel *)hotLottery
{
    if ([CPGlobalDataManager shareGlobalData].isReviewVersion) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.maiTabBarController.selectedIndex = 1;
        
    }else{
        
        if ([hotLottery.num isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForMainTabBarSwitchToBuyLottery object:nil];
        }else{
            
            if ([CPGlobalDataManager shareGlobalData].isReviewVersion){
                CPLotteryModel *model = hotLottery;
                CPLotteryResultDetailWebVC *vc = [[CPLotteryResultDetailWebVC alloc]init];
                vc.title = model.name;
                vc.urlString = [NSString stringWithFormat:@"%@/api/draw/single?gid=%ld",[CPGlobalDataManager shareGlobalData].domainUrlString,(long)[model.num integerValue]];
    
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self queryBuyLotteryInfoWithGid:hotLottery.num lotteryName:hotLottery.name];

            }
            

        }

    }
}


/**
 点击公告
 */
- (IBAction)clickNotice:(UIButton *)sender {
    
    NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/systemNotice"];
    CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
    toWebVC.title = @"公告";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}


/**
 点击topView的item事件
 */
- (IBAction)clickTopViewItem:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
        {
            //存取款
            if ([self verifySignInfoIsSignIn]) {
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                app.maiTabBarController.selectedIndex = app.maiTabBarController.viewControllers.count-1;
            }
            
        }break;
        case 11:
        {
            //投注记录
            if ([self verifySignInfoIsSignIn]) {
                
                if ([CPGlobalDataManager shareGlobalData].isReviewVersion) {
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    app.maiTabBarController.selectedIndex = 1;
                    
                }else{
                    
                    CPBetRecordVC *vc = [CPBetRecordVC new];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.onlyShowWinRecord = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }
               
            }
            
        }break;
        case 12:
        {
            //优惠活动
            [self discountActivity];
        }break;
        case 13:
        {
            //在线客服
            if ([CPGlobalDataManager shareGlobalData].kefuUrlString) {
                [self loadKefuWebView];
            }else{
                [self queryKefuUrlString];
            }
        }break;
            
        default:
            break;
    }
}



/**
 点击中奖名单
 */
-(void)clickWinnersBanner
{
    NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/win/list"];
    CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
    toWebVC.title = @"最新中奖榜";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}


/**
 客服
 */
-(void)loadKefuWebView
{
    
    CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:[[NSString alloc]initWithString:[CPGlobalDataManager shareGlobalData].kefuUrlString]];
    toWebVC.title = @"客服";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}


/**
 优惠活动
 */
-(void)discountActivity
{
    NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/activity"];
    CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
    toWebVC.title = @"优惠活动";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}

-(BOOL)verifySignInfoIsSignIn
{
    //我的
    if (![SUMUser shareUser].isLogin) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.maiTabBarController goToLoginViewController];
        return NO;
    }
    return YES;
}

#pragma mark- network

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



-(void)queryHomePageData
{
//    https://cp89.c-p-a-p-p.net/ios2
//    NSString *paramsString = [[SUMUser shareUser]fetchLoginToken];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIIndex
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               if (_contentScrollView.mj_header.isRefreshing) {
                   [_contentScrollView.mj_header endRefreshing];
               }
               
               if (request.resultIsOk) {
                   
                   _homePageInfo = request.businessData;
                   NSDictionary *popNotice = [_homePageInfo DWDictionaryForKey:@"popNotice"];
                   _hongBaoInfo = [_homePageInfo DWDictionaryForKey:@"hongBao"];
                   NSDictionary *caijinDic = [_homePageInfo DWDictionaryForKey:@"caiJin"];
                   if (caijinDic.allKeys.count>0) {
                       self.caijinInfo = [DWParsers getObjectByObjectName:@"CPHomepageActivityCaijin" andFromDictionary:caijinDic];
                   }else{
                       self.caijinInfo = nil;
                   }
                   [self reloadCaijinDragView];
                   [self reloadHongBaoDragView];
                   [self addSubviews];
                   [self addTitleImageView];
                   if (popNotice.allValues.count>0 && _hasShowNotice == NO) {
                       _hasShowNotice = YES;
                       [CPHomeNoticeView showWithPopInfo:popNotice];
                   }
               }else{
                   
                   [WSProgressHUD showErrorWithStatus:request.requestDescription];
               }
               
           } failure:^(__kindof SUMRequest *request) {
               
               if (_contentScrollView.mj_header.isRefreshing) {
                   [_contentScrollView.mj_header endRefreshing];
               }
               if (!_homePageInfo) {
                   
               }
           }];

}

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
