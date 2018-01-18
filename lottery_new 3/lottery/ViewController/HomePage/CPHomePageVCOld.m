//
//  CPHomePageVC.m
//  lottery
//
//  Created by wayne on 17/1/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LCLoadingHUD.h"
#import "Reachability.h"
#import "CPPresentWebVC.h"


@interface CPHomePageVCOld : UIViewController

@end

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
        
        iamgeName = @"loadingBg_iphonePlus";

    }
    
    return iamgeName;
}

@interface CPHomePageVCOld ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView *_webView;
    UIView *_loadingView;
    NSString *_mainUrlString;
    NSString *_mainDomain;
    NSDictionary *_info;

    UILabel *_loadingMsgLabel;
    
    NSString *_willLoadUrlString;
}

@property(nonatomic,retain)Reachability *reachability;


@end

@implementation CPHomePageVCOld

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self registUserAgent];
    
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    statusView.backgroundColor = kCOLOR_R_G_B_A(233, 43, 49, 1);
    [self.view addSubview:statusView];
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height - 20)];
    _webView.delegate = self;
    _webView.backgroundColor = kCOLOR_R_G_B_A(23, 23, 23, 1);
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    
    /*
    UIView *webTopBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -_webView.height, _webView.width, _webView.height)];
    webTopBgView.backgroundColor = kCOLOR_R_G_B_A(233, 43, 49, 1);
    [_webView.scrollView addSubview:webTopBgView];
    
    UIView *webBottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, _webView.height, _webView.width, _webView.height)];
    webBottomBgView.backgroundColor = kCOLOR_R_G_B_A(23, 23, 23, 1);
    [_webView.scrollView addSubview:webBottomBgView];
     */
    
    _loadingView = [[UIView alloc]initWithFrame:self.view.bounds];
    _loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_loadingView];

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _loadingView.width, _loadingView.height)];
    [imgView setImage:[UIImage imageNamed:loadingBackgroundImageName()]];
    [_loadingView addSubview:imgView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadLoading)];
    [_loadingView addGestureRecognizer:tapGes];
    
    _loadingMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_loadingView.height/2.0 - 50, _loadingView.width, 50)];
    _loadingMsgLabel.textAlignment = NSTextAlignmentCenter;
    _loadingMsgLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
    _loadingMsgLabel.font = [UIFont systemFontOfSize:17.0f];
    _loadingMsgLabel.numberOfLines = 0;
    [_loadingView addSubview:_loadingMsgLabel];
    
    [self reloadLoading];
    
//    kNotificationNameForApplicationWillEnterForeground
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillEnterForeground) name:kNotificationNameForApplicationWillEnterForeground object:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.reachability stopNotifier];
}

-(void)registUserAgent
{
    NSString *agent = @"IOS_Lottery";
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if ([userAgent rangeOfString:agent].length == 0) {
        NSString *hybirdUserAgent = [NSString stringWithFormat:@"%@ %@",userAgent,agent];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":hybirdUserAgent}];
    }
}

#pragma mark- appWillEnterForeground Notification

-(void)appWillEnterForeground
{
    [self relodLoginAction];
}


-(void)relodLoginAction
{
    NSString *paramsString = [[SUMUser shareUser]fetchLoginToken];
    [SUMRequest startWithDomainString:[SUMUser shareUser].domainString
                              apiName:@"/common/appLogin"
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
        
        if (!request.resultIsOk) {
            
            NSString *des = [request.resultInfo DWStringForKey:@"description"];
            if (des.length>0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:des delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
        }
        
    } failure:^(__kindof SUMRequest *request) {
        
    }];
}


#pragma mark- scrollView Delegate


#pragma mark- network status reachability

-(void)addReachabilityNetStatusNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachiabilityChanged) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}

-(void)reachiabilityChanged
{
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) {
        
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeBlue
                                       title:@"当前网络异常，请检查网络状况"
                             linedBackground:AJLinedBackgroundTypeAnimated
                                   hideAfter:2.5f response:^{
                                       
                                       
                                   }];
    }
}

#pragma mark-

-(void)loadWebView
{
    NSURL *url = [NSURL URLWithString:_mainUrlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    DLog(@"%@",_mainDomain);
    [_webView loadRequest:request];
}

-(void)showLoadingErrorAlert:(NSString *)msg
{
    _loadingMsgLabel.text = msg?msg:@"网络异常！点击刷新";
}

-(void)reloadLoading
{
    _loadingMsgLabel.text = @"";
    [LCLoadingHUD showLoading:@"加载数据" inView:self.view];
    if ([SUMUser shareUser].isLogin) {
        
        [self queryLoginAgain];
        
    }else{
        [self queryDomainInfo];
    }
}

#pragma mark- network

-(void)queryDomainInfo
{
    NSDictionary *paramsDic = @{@"deviceType":@"2"};
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [SUMRequest startWithApiName:@"/api/getDomain"
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodPOST
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
        
        if (request.resultIsOk) {
            
            DLog(@"%@",request.resultInfo);
            _mainUrlString = [request.resultInfo DWStringForKey:@"data"];
            [[SUMUser shareUser]addMainDomainString:[request.resultInfo DWStringForKey:@"data"]];

            [self loadWebView];
            
        }else{
            
            [LCLoadingHUD hideInView:self.view];
            [self showLoadingErrorAlert:nil];
        }
        
        
        
    } failure:^(__kindof SUMRequest *request) {
        
        [LCLoadingHUD hideInView:self.view];
        [self showLoadingErrorAlert:nil];
    }];
}


-(void)queryLoginAgain
{
//    /common/appLogin?data
    
    NSString *paramsString = [[SUMUser shareUser]fetchLoginToken];
    [SUMRequest startWithDomainString:[SUMUser shareUser].domainString
                              apiName:@"/common/appLogin"
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
        
        if (!request.resultIsOk) {
            
            NSString *des = [request.resultInfo DWStringForKey:@"description"];
            if (des.length>0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:des delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
        }
        [self queryDomainInfo];
        
    } failure:^(__kindof SUMRequest *request) {
        [self queryDomainInfo];
    }];
}

#pragma mark- webViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *urlString = url.absoluteString;
    
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (response.statusCode == 404 || response.statusCode == 500 ) {
        
        [WSProgressHUD showErrorWithStatus:@"页面异常，请稍候再试！"];
        DLog(@"oh fuck, error !");
        return NO;
    }
    _willLoadUrlString = urlString;
//    NSLog(@"%@",_willLoadUrlString);

    NSRange range = [urlString rangeOfString:@"#_TITLE_#"];
    if (range.length == 0) {
        range =  [urlString rangeOfString:@"#_TITLE_%23"];
    }
//    range = [urlString rangeOfString:@"kefu"];
    if (range.length>0) {
        NSString *title = [[urlString substringFromIndex:range.location+range.length] URLDecodedString];
        [self goPresentWebViewControllerWithUrlString:urlString title:title];
        [webView goBack];
        return NO;
    }
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    if (_loadingView.superview) {
        [LCLoadingHUD hideInView:self.view];
        [self showLoadingErrorAlert:nil];
    }

}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_loadingView.superview) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [_loadingView removeFromSuperview];
                [LCLoadingHUD hideInView:self.view];
                [self addReachabilityNetStatusNotification];
        });
    }
    DLog(@"oh fuck finished load");
    DLog(@"UserAgent = %@", [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
}

#pragma mark-

-(void)goPresentWebViewControllerWithUrlString:(NSString *)urlString
                                         title:(NSString *)title
{
    CPPresentWebVC *toWebVC = [[CPPresentWebVC alloc]initWithURLString:urlString];
    toWebVC.title = title;
    toWebVC.showPageTitles = NO;
    toWebVC.doneButtonTitle = @"返回";
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:toWebVC];
    nav.navigationBar.barTintColor = [UIColor redColor];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
    
}

@end
