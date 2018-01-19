//
//  AppDelegate.m
//  lottery
//
//  Created by wayne on 17/1/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "UMMobClick/MobClick.h"

#import "UMessage.h"
#import "WXApi.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreLocation/CoreLocation.h>
#import "YIIndexVc.h"
#import "TorchObject.h"
#import "YIFlashlight.h"
#import "iVersion.h"
#import "YISplashScreen.h"
#import "YIInitUtil.h"
#import "YICalculatorVc.h"
#import "YIMosaicsVc.h"
#import "YIBlurVc.h"

#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate,WXApiDelegate,CLLocationManagerDelegate, UIViewControllerTransitioningDelegate>
    @property(strong, nonatomic) CLLocationManager *locationManager;
    @end

@implementation AppDelegate
    
+ (void)initialize {
    NSLog(@"=== initialize");
    
#ifdef DEBUG
    //    [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif
    
    [iVersion sharedInstance].appStoreID = 1083816988;
}
    
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    // 初始化基本要用到东西.
    [YIInitUtil loadBaseInit];
    
    //    // 初始化网络配置
    //    [self initNetConfig];
    //
    //    // 初始化图片缓存
    //    [self initImageConfig];
    
    //    // 初始化友盟统计插件
    //    [self initUMeng:launchOptions];
    
    //    // 初始化全局数据
    //    [self initGlobalData];
    
    // 注册错误处理通知
    [self registerErrorHandleNotification];
    
    // 加载其他的任务
    [self loadOtherTasks:launchOptions];
    
    // 启动定位
    //    [self startLocation];
    
    // 获取运营商的信息
    [self carrierOperator];
    
    //     加载AVOSCloud
    //    [self loadAVOSCloud:launchOptions];
    
    // 心跳
    //    [self startHeartBeat];
    
    [self loadShortcutItems];

    
    return YES;
}
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //    [[YISplashScreen new] loadSplashScreen2];
    
    /*
     友盟推送
     */
    /*
     [UMessage startWithAppkey:@"59c208fb9f06fd79d400005a" launchOptions:launchOptions];
     [UMessage registerForRemoteNotifications];
     */
    

    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //点击允许
                                  //这里可以添加一些自己的逻辑
                              } else {
                                  //点击不允许
                                  //这里可以添加一些自己的逻辑
                              }
                          }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UMConfigInstance.appKey = @"59c208fb9f06fd79d400005a";
    UMConfigInstance.channelId = [NSString stringWithFormat:@"%@-cp55",app_Version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    
    //    //微信支付
    //    [WXApi registerApp:@"wx5525912ec3511b13"];
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    //    manager.enableAutoToolbar =;
    manager.toolbarDoneBarButtonItemText = @"完成";
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    NSString *lang;
    BOOL isZh;
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hans-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        lang = @"zh";
        isZh=YES;
    }else{
        lang = @"en";
        isZh=NO;
        
    }
    
    //审核问题，大于这个时间才显示logo
    NSInteger result = [self compareDatewithDate:@"2018-01-26 10:10:20"];
    if (result==1&&isZh) {
        
        /*
         极光推送
         */
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            // 可以添加自定义categories
            /**/
            
        }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
        BOOL isProduction = YES;
        [JPUSHService setupWithOption:launchOptions appKey:@"16dd34d79d8ba4dd7af0fadd"
                              channel:isProduction?@"CP55-Production":@"CP55-Debug"
                     apsForProduction:isProduction
                advertisingIdentifier:nil];
        
        self.maiTabBarController = [[MainTabBarController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.maiTabBarController];
        nav.navigationBarHidden = YES;
    
        self.window.rootViewController =nav;
        [self customAppearence];
    }else{
        [self checkShortcutItem:launchOptions];
        
        // 加载应用
        [self loadMainViewController];
        
        // 动态闪屏图
        //    if (!mGlobalData.notShowSplashScreen) {
        //        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //            [[YISplashScreen new] loadSplashScreen];
        //        }
        //    }
    }

    
    [self.window makeKeyAndVisible];
    
    return YES;
}
#pragma mark - 初始化工作开始
//比较两个日期的大小  日期格式为2016-08-14 08：46：20
- (NSInteger)compareDatewithDate:(NSString*)dateStr
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    dta = [dateformater dateFromString:dateStr];
    
    NSDate *dtb = [NSDate date];
    
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

- (void)loadShortcutItems {
    if ([UIMutableApplicationShortcutItem class]) {
        //创建快捷item的icon 即UIApplicationShortcutItemIconFile
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"flashlight64"];
        
        //创建快捷item的userinfo 即UIApplicationShortcutItemUserInfo
        NSDictionary *info1 = @{@"url":@"xiaojia://flashlight"};
        
        NSString *subTitle;
        mGlobalData.flashlight = [YIFlashlight sharedInstance];
        if (mGlobalData.flashlight.type == FlashlightTypeFlash) {
            subTitle = @"闪光灯照明";
        } else if (mGlobalData.flashlight.type == FlashlightTypeScreen) {
            subTitle = @"屏幕光照明";
        }
        
        //创建ShortcutItem
        UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"3dtouch.flashlight"
                                                                                          localizedTitle:@"手电筒"
                                                                                       localizedSubtitle:subTitle
                                                                                                    icon:icon1
                                                                                                userInfo:info1];
        
        [UIApplication sharedApplication].shortcutItems = @[item1];
    }
}
- (void)loadAVOSCloud:(NSDictionary *)launchOptions {
    
    
}
#pragma mark 定位
    
- (void)startLocation {
    // 判断定位操作是否被允许
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization];
        }
        // 开始定位
        [_locationManager startUpdatingLocation];
    } else {
        // 提示用户无法进行定位操作
    }
}
    
    /*
     //定位代理经纬度回调
     - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
     [manager stopUpdatingLocation];
     //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
     CLLocation *currentLocation = [locations lastObject];
     
     CLLocationCoordinate2D coor = currentLocation.coordinate;
     NSString *latitude = [NSString stringWithFormat:@"%.8f", coor.latitude];
     NSString *longitude = [NSString stringWithFormat:@"%.8f", coor.longitude];
     
     mGlobalData.latitude = latitude;
     mGlobalData.longitude = longitude;
     
     CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
     [geoCoder reverseGeocodeLocation:currentLocation
     completionHandler:^(NSArray *placemarks, NSError *error) {
     for (CLPlacemark *placemark in placemarks) {
     NSDictionary *address = [placemark addressDictionary];
     
     mGlobalData.country = [address objectForKey:@"Country"];
     mGlobalData.province = [address objectForKey:@"City"];
     mGlobalData.city = [address objectForKey:@"State"];
     mGlobalData.district = [address objectForKey:@"SubLocality"];
     mGlobalData.street = [address objectForKey:@"Street"];
     }
     }];
     }
     
     - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
     if (error.code == kCLErrorDenied) {
     // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
     }
     }
     */
    
#pragma mark 其他
    
- (void)loadOtherTasks:(NSDictionary *)launchOptions {
    // 1，统计启动次数
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [MobClick event:UMENG_EVENT_CLICK_REMOTE_NOTIFICATION];
    } else {
        [MobClick event:UMENG_EVENT_CLICK_APP_ICON];
    }
}
    
#pragma mark 心跳记录
- (void)startHeartBeat {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                      target:self
                                                    selector:@selector(timerFire)
                                                    userInfo:nil
                                                     repeats:YES];
    [timer fire];
}
    
    /*
     - (void)timerFire {
     AVQuery *query = [LCClientEntity query];
     [query whereKey:@"idfv" equalTo:[UIDevice vendorId]];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     LCClientEntity *bm = nil;
     if (error || objects == nil || objects.count == 0) {
     bm = [LCClientEntity object];
     } else {
     LCClientEntity *object = objects[0];
     bm = [LCClientEntity objectWithoutDataWithObjectId:object.objectId];
     }
     
     bm.appVersion = [YICommonUtil appVersion];
     bm.appChannel = [YIConfigUtil channelName];
     bm.osName = [UIDevice systemName];
     bm.osVersion = [UIDevice systemVersion];
     bm.deviceModel = [UIDevice deviceModel];
     bm.idfv = [UIDevice vendorId];
     //        bm.deviceToken = [mGlobalData deviceToken];
     //        bm.netType = [mGlobalData netType];
     //        bm.provider = [mGlobalData carrier];
     //        bm.country = [mGlobalData country];
     //        bm.province = [mGlobalData province];
     //        bm.city = [mGlobalData city];
     //        bm.district = [mGlobalData district];
     //        bm.street = [mGlobalData street];
     //        bm.longitude = [mGlobalData longitude];
     //        bm.latitude = [mGlobalData latitude];
     bm.resolutionWidth = [NSString stringWithFormat:@"%f", [UIScreen DPISize].width];
     bm.resolutionHeight = [NSString stringWithFormat:@"%f", [UIScreen DPISize].height];
     [bm saveInBackground];
     }];
     }
     
     
     #pragma mark 初始化网络
     
     - (void)initNetConfig {
     [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
     [YINetworkManager startMonitoring];
     }
     
     #pragma mark init image config
     
     - (void)initImageConfig {
     [SDImageCache sharedImageCache].maxCacheAge = 3 * 30 * 24 * 60 * 60;
     [SDImageCache sharedImageCache].maxCacheSize = 100 * 1024 * 1024;
     }
     */
    
#pragma mark init global data
    
- (void)initGlobalData {
    // 从User Default加载参数进内存
    [mGlobalData loadDefaultValue];
    
    // 清理所有缓存数据
    //    NSString *curVersionCode = [YICommonUtil appVersion];
    //    if (![mGlobalData.savedVersionCode isEqualToString:curVersionCode]) {
    //        [LCClientEntity clearAllCacheData];
    //        [mGlobalData setSavedVersionCode:curVersionCode];
    //    }
}
    
#pragma mark init UMeng
    
- (void)initUMeng:(NSDictionary *)launchOptions {
//    [MobClick startWithAppkey:UMENG_APP_KEY reportPolicy:SEND_INTERVAL channelId:[YICommonUtil channelName]];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
//    
//    // 友盟反馈
//    [UMFeedback setAppkey:UMENG_APP_KEY];
    
    /*
     友盟通知 暂不用
     
     if (IOS_8_OR_LATER) {
     //register remoteNotification types
     UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
     action1.identifier = @"action1_identifier";
     action1.title=@"Accept";
     action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
     
     UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
     action2.identifier = @"action2_identifier";
     action2.title=@"Reject";
     action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
     action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
     action2.destructive = YES;
     
     UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
     categorys.identifier = @"category1";//这组动作的唯一标示
     [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
     
     UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
     categories:[NSSet setWithObject:categorys]];
     
     [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
     } else {
     [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
     }
     */
    
    /*
     [UMessage setLogEnabled:YES];
     
     // 关闭状态时点击反馈消息进入反馈页
     NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
     [UMFeedback didReceiveRemoteNotification:notificationDict];
     [[UMFeedback sharedInstance] setFeedbackViewController:nil shouldPush:YES];
     
     [self.window.rootViewController presentViewController:[UMFeedback feedbackViewController] animated:YES completion:NULL];
     */
}
    
#pragma mark 注册错误处理通知
    
- (void)registerErrorHandleNotification {
    // 注册ServerErrorCode通知
    [mNotificationCenter addObserver:self
                            selector:@selector(handleAppError:)
                                name:APP_ERROR_HANDLE_NOTIFICATION
                              object:nil];
}
    
#pragma mark Notification - 处理错误
    
- (void)handleAppError:(NSNotification *)notification {
    NSError *error = [notification object];//获取到传递的对象
    NSInteger errorCode = error.code;
    NSString *errorMsg = [error userInfo][NSLocalizedDescriptionKey];
    //    [MobClick event:EMMA_HANDLE_ERROR attributes:@{@"error_code": @(errorCode), @"error_msg" : errorMsg}];
    
    switch (errorCode) {
        case ErrorCodeTokenExpired: {
            [TSMessage showNotificationWithTitle:@"请重新登录账号"
                                        subtitle:errorMsg
                                            type:TSMessageNotificationTypeWarning];
            mGlobalData.login = NO;
            [mNotificationCenter postNotificationName:TOGGLE_LOGIN_STATUS_NOTIFICATION object:nil];
            break;
        }
        case ErrorCodeNeedUpdate: {
            NSString *title = [NSString stringWithFormat:@"%@更新啦，升级赚大钱吧~", [YICommonUtil appName]];
            [TSMessage showNotificationWithTitle:title
                                            type:TSMessageNotificationTypeWarning];
            break;
        }
        case ErrorCodeNetworkNotReachable:
        case ErrorCodeServerDown:
        default: {
            if (errorMsg.isOK) {
                [TSMessage showNotificationWithTitle:errorMsg
                                                type:TSMessageNotificationTypeWarning];
            } else {
                [TSMessage showNotificationWithTitle:@"请稍后再试"
                                                type:TSMessageNotificationTypeWarning];
            }
            break;
        }
    }
}
    
#pragma mark ViewController调度
    
    // 加载引导页
- (void)loadWelcomeViewController {
    //    UIViewController *welcomeVC = [[YIWelcomeVc alloc] init];
    //    [self.window.rootViewController addChildViewController:welcomeVC];
    //    [self.window.rootViewController.view addSubview:welcomeVC.view];
    
    mGlobalData.isLaunched = YES;
}
    
- (void)checkShortcutItem:(NSDictionary *)launchOptions {
    if ([UIApplicationShortcutItem class]) {
        // 3D touch 检测
        UIApplicationShortcutItem *item = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf actionWithShortcutItem:item];
            }
        });
    }
}
#pragma mark - 3D touch 回调
    
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler NS_AVAILABLE_IOS(9_0); {
    if (shortcutItem)
    {
        [self actionWithShortcutItem:shortcutItem];
    }
    
    if (completionHandler)
    {
        completionHandler(YES);
    }
}
    
-(void)actionWithShortcutItem:(UIApplicationShortcutItem *)item
    {
        if ([item.type isEqualToString:@"3dtouch.flashlight"])
        {
            if (mGlobalData.flashlight.type == FlashlightTypeFlash) {
                [[TorchObject sharedInstance] setTorchOn:YES];
            } else if (mGlobalData.flashlight.type == FlashlightTypeScreen) {
                [[UIScreen mainScreen] setBrightness:1.0];
            }
        }
    }
    
- (void)loadMainViewController {
    //    YIMosaicsVc *vc = [[YIMosaicsVc alloc] init];
    //    YIBlurVc *vc = [[YIBlurVc alloc] init];
    YIIndexVc *vc = [[YIIndexVc alloc] init]; // todo ...
    YIBaseNavigationController *mainNc = [[YIBaseNavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:mScreenBounds];
    [self.window setRootViewController:mainNc];
}
    
    /*
     - (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
     UIImage *finishedImage = [UIImage imageNamed:@"tabbar_seleced_background"];
     UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
     NSArray *tabBarItemImages = @[@"tabbar_icon_zhaobiao", @"tabbar_icon_yunli", @"tabbar_icon_zhanghu"];
     NSArray *tabBarItemTitles = @[@"宝记", @"宝宝列表", @"我的"];
     
     NSInteger index = 0;
     for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
     [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
     UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
     [tabBarItemImages objectAtIndex:index]]];
     UIImage *unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
     [tabBarItemImages objectAtIndex:index]]];
     [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
     NSDictionary *textAttributes = nil;
     textAttributes = @{NSForegroundColorAttributeName : kAppColorMain};
     [item setSelectedTitleAttributes:textAttributes];
     [item setTitle:[tabBarItemTitles objectAtIndex:index]];
     index++;
     }
     }
     */
    
    
    /*
     #pragma mark 初始化工作完毕
     #pragma mark - RDVTabBarControllerDelegate
     - (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController; {
     return YES;
     }
     
     - (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController; {
     
     }
     */
    
    // http://blog.csdn.net/decajes/article/details/41807977
- (void)carrierOperator {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@", [carrier carrierName]];
    //    mGlobalData.carrier = mCarrier;
}
    
#pragma mark-
- (void)customAppearence
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kMainColor] forBarMetrics:UIBarMetricsDefault];
        
        UIImage *backButtonImage = [[UIImage imageNamed:@"back_navi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance]setBackIndicatorImage:backButtonImage];
        [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:backButtonImage];
        [[UINavigationBar appearance]setTintColor:[UIColor clearColor]];
        
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            // 去掉iOS11系统默认开启的self-sizing
            [UITableView appearance].estimatedRowHeight = 0;
            [UITableView appearance].estimatedSectionHeaderHeight = 0;
            [UITableView appearance].estimatedSectionFooterHeight = 0;
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor whiteColor],
          NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName,
          nil]];
        
        [[UITabBar appearance]setTintColor:kMainColor];
        
    }
    
- (void)applicationWillResignActive:(UIApplication *)application {
    
    if (mGlobalData.flashlight) {
        if (mGlobalData.flashlight.type == FlashlightTypeScreen) {
            [[UIScreen mainScreen] setBrightness:mGlobalData.flashlight.brightness];
        }
    }
    //    [[SUMUser shareUser]lookForLoginToken];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
    
    
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
    
    
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [SUMUser checkUpdateNewestVersion];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForApplicationWillEnterForeground object:nil];
}
    
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSInteger num = application.applicationIconBadgeNumber;
    if (num != 0) {
        /*
         AVInstallation *currentInstallation = [AVInstallation currentInstallation];
         [currentInstallation setBadge:0];
         [currentInstallation saveEventually];
         */
        application.applicationIconBadgeNumber=0;
    }
    [application cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
    
    
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}
#pragma mark - Core Data stack
    
    @synthesize managedObjectContext = _managedObjectContext;
    @synthesize managedObjectModel = _managedObjectModel;
    @synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
    
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.buerguo.BaoBaoJi" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
    
- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BaoBaoJi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
    
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BaoBaoJi.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
    
    
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
    
#pragma mark - Core Data Saving support
    
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
    
    
#pragma mark-
    
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
    {
        // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
        /*
         [UMessage registerDeviceToken:deviceToken];
         */
        
        [JPUSHService registerDeviceToken:deviceToken];
    }
    
    
    
    
    //iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    {
        /*
         [UMessage didReceiveRemoteNotification:userInfo];
         */
        [JPUSHService handleRemoteNotification:userInfo];
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
            
            id alert = [[userInfo DWDictionaryForKey:@"aps"]objectForKey:@"alert"];
            NSString *title = @"推送通知";
            NSString *body = @"";
            
            if ([alert isKindOfClass:[NSDictionary class]]) {
                NSDictionary *alertDic = (NSDictionary *)alert;
                title = [alertDic DWStringForKey:@"title"];
                body = [alertDic DWStringForKey:@"body"];
                
            }else{
                body = alert;
            }
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                               message:body
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:nil];
            [alertView show];
        }
        
        
        
    }
    
    //iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    id alert = [[userInfo DWDictionaryForKey:@"aps"]objectForKey:@"alert"];
    NSString *title = @"推送通知";
    NSString *body = @"";
    
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSDictionary *alertDic = (NSDictionary *)alert;
        title = [alertDic DWStringForKey:@"title"];
        body = [alertDic DWStringForKey:@"body"];
        
    }else{
        body = alert;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:body delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
    
    //iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        /*
         [UMessage didReceiveRemoteNotification:userInfo];
         */
        [JPUSHService handleRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
    
    
    
#pragma mark- JPUSHRegisterDelegate
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
    
    
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
    
- (void)onResp:(BaseResp *)resp
    {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            SendAuthResp *temp = (SendAuthResp *)resp;
            [self queryWechatUnionid:temp.code];
            //temp.code
        }
    }
    
- (void)queryWechatUnionid:(NSString *)code
    {
        [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
        
        NSString *url =[NSString stringWithFormat:
                        @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                        @"wx5525912ec3511b13",@"17578bee42800d5608d3f30e148d9c12",code];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (data)
                {
                    /*
                     {
                     "access_token" = "VZpnWzT9ufPUF2iBUNjKukFViYgrIN1ysMfGJDaC21M2HZHqwB26bNWlz0WyXRKUzxqnXgW1kYo4yyDtdwJEE4Zo-eNQUV56R9wf8degtzQ";
                     "expires_in" = 7200;
                     openid = oKZpQ01Rq75rCbeWnbKwXqdQ8PnE;
                     "refresh_token" = YFMsMI0Kcyh8lO2RuaRAtHNurp1CSjCYXvu4tjraAQi4VfMEXSG1T3A4IgNLZ7kahvRxdP6nM9PQJ1WXpoqoKbwd8qS9285fuPjpNXNP3nI;
                     scope = "snsapi_userinfo";
                     unionid = "oas-J0mszbdm089Jk9gIHhFOankg";
                     }
                     */
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers error:nil];
                    
                    NSString *unionid = [dic DWStringForKey:@"unionid"];
                    NSString *access_token = [dic DWStringForKey:@"access_token"];
                    NSString *openid = [dic DWStringForKey:@"openid"];
                    NSString *refresh_token = [dic DWStringForKey:@"refresh_token"];
                    
                    [self getWechatUserInfoWithAccessToken:access_token openId:openid];
                    
                    if (unionid.length>0) {
                        [SVProgressHUD dismiss];
                    }else{
                    }
                    
                    
                }else{
                    
                }
                
            });
        });
    }
    
- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
    {
        NSString *url =[NSString stringWithFormat:
                        @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (data)
                {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers error:nil];
                    
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        NSString *headimgurl = [dic DWStringForKey:@"headimgurl"];
                        NSString *nickname = [dic DWStringForKey:@"nickname"];
                        if (headimgurl.length>0 && nickname.length>0) {
                        }
                    }
                    
                    
                }
            });
            
        });
    }
    
    
    
    @end

