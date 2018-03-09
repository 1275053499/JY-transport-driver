//
//  AppDelegate.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JYAccountTool.h"
#import "ModelOfUserInfo.h"
#import "JYWuliuTool.h"
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "UrlInterfaces.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "ModelOrder.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "TQLocationConverter.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "YZBackgroundTaskManager.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#define BMKmapKey @"1Rcr3wuzMX7vGyfEnGgpwZzI22WgCbxa"

#import <Bugly/Bugly.h>
#import <AlipaySDK/AlipaySDK.h>


#import <WXApiObject.h>
#import <WXApi.h>
#define WeiXinPayID @"wx1928782094ef0d99"
//#import <IQKeyboardManager.h>
@interface AppDelegate ()<BMKLocationServiceDelegate,JPUSHRegisterDelegate,WXApiDelegate,BMKGeoCodeSearchDelegate>
{
    CLLocationManager *locationManager;
    NSString *currentCity;
    NSString *StrLatitude;
    NSString *Strlongitude;
//    NSTimer *timer;
    BMKMapManager* _mapManager;
//   BMKLocationService *locService;

}
@property (nonatomic,strong)BMKLocationService *locService;

@property (nonatomic, assign) NSTimeInterval nowLocationTime;
@property (nonatomic, assign) NSTimeInterval lastLocationTime;

@property (nonatomic,strong) NSTimer *restartTime;
@property (nonatomic,strong) YZBackgroundTaskManager *bgTask;
@property (nonatomic,assign)BOOL loginSuccess;
@property (nonatomic,assign)BOOL isBackGround;

@property (nonatomic,strong)CLLocation *currentLocation;
@end

@implementation AppDelegate

- (void)backgroundHandler
{
//    UIApplication *app = [UIApplication sharedApplication];
//    self.bgTask  = [app beginBackgroundTaskWithExpirationHandler:^{
//        [app endBackgroundTask:self.bgTask];
//        
//        self.bgTask = UIBackgroundTaskInvalid;
//    }];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
//                                             0),
//                   ^{
//                       NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//                       NSDictionary *dict = [[NSDictionary alloc]init];
//                       [nc postNotificationName:@"LocationTheme" object:self userInfo:dict];
//                   });
    
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [Bugly startWithAppId:@"1003cd8b78"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
  
    //向微信注册wx1928782094ef0d99
    [WXApi registerApp:WeiXinPayID];
    
    _mapManager = [[BMKMapManager alloc]init];
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    BOOL ret = [_mapManager start:BMKmapKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    
    if (IOS_VERSION >= 10.0) // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        //-------------注册远程推送
        //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if (IOS_VERSION >= 8.0)
    {
        // categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                              categories:nil];
    }
#ifdef DEBUG
    BOOL isProduction = NO;// NO为开发环境
#else
    BOOL isProduction = YES;// YES为生产环境
#endif
    //-------------极光推送SDK初始化
    //广告标识符 如果没有使用IDFA直接传nil(避免被拒)
//   NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:@"90663adbffd08df97e15ab99"
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //return YES;
    
    // apn 内容获取：
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        NSLog(@"程序死后推送");
        //程序退出未启动  点击通知跳转页面
    }
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSString *account = [JYAccountTool userName];
    NSString *accountLog = [JYAccountTool userNameForLogistics];

    if (account) {// 之前登录成功
        [JYWuliuTool chooseRootController];
        [self beginLocation_driver];

        
    }else if (accountLog){
        
        [JYWuliuTool chooseRootController];

    }else{ // 之前没有登录成功
         self.window.rootViewController = [[LoginViewController alloc]init];
        
    }
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginLocation_driver) name:@"RobOrderSuccess" object:nil];//抢订单成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginLocation_driver) name:@"loginSuccess" object:nil];//登录成功
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:@"logoutSuccess" object:nil];//退出登录
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginLocation) name:@"loginLocation" object:nil];//退出登录
  
    //注册远程推送 自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    return YES;
}

//所有人 前台收到通知   点击通知
//iOS7 ~ iOS9  前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    NSLog(@"iOS7推送消息呢===%@",userInfo);
    // 取得 APNs 标准信息内容，如果没需要可以不取
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 取得自定义字段内容，userInf就是后台返回的JSON数据，是一个字典
    [JPUSHService handleRemoteNotification:userInfo];
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];

    
}
//自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
     NSDictionary * userInfo = [notification userInfo];
     NSLog(@"自定义消息============%@",userInfo);
//    NSString *content = [userInfo valueForKey:@"content"];
     NSString *title = [userInfo valueForKey:@"title"];
     NSString *content_type = [userInfo valueForKey:@"content_type"];
    //通知刷新接单广场
     if ([content_type isEqualToString:@"getNew"]) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"GetNewOrder" object:nil];
     }else if ([content_type isEqualToString:@"sureDriver"]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"sureDriver" object:nil]; //用户确认  刷新司机订单
     }else if ([title isEqualToString:@"logisticsOrder"] && [content_type isEqualToString:@"cancellationProvider"]) {
         
         //用户取消物流公司估价
         [[NSNotificationCenter defaultCenter] postNotificationName:@"cancellationProvider" object:nil];
     
     }else if ([title isEqualToString:@"logisticsOrder"] && [content_type isEqualToString:@"confirmationProvider"]) {
         
         //确认
         [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmationProvider" object:nil];
         
     }
   
    
}
//将苹果服务器返回的deviceToken,上传到极光推送服务器。

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}
//注册远程通知失败，比如没有联网的状态下。
-(void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//处于前台，iOS10之后  在以下方法中获取通知内容:iOS10 after （UNUserNotificationCenterDelegate中的代理方法）jpush封装了以下的方法
#pragma mark - iOS10: 收到推送消息调用(iOS10是通过Delegate实现的回调)
#pragma mark- JPUSHRegisterDelegate
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 当程序在前台时, 收到推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // 指定系统如何提醒用户，有Badge、Sound、Alert三种类型可以设置
    // 如果不需提醒可传UNNotificationPresentationOptionNone
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    
}

//当用户点击了通知的某个操作，需要进行相应处理，如跳转到某个界面
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
       NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    // 让系统知道你已处理完通知。
    completionHandler();  
}
#endif
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



-(void)logoutSuccess{
   
    _loginSuccess = NO;
    self.bgTask = [YZBackgroundTaskManager sharedBackgroundTaskManager];
    [self.bgTask endAllBackgroundTasks];
    [locationManager stopUpdatingLocation];
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    _locService = nil;
    locationManager.delegate = nil;
    locationManager = nil;
    self.bgTask = nil;
    
}

-(void)beginLocation_driver
{
    
    _loginSuccess = YES;
    NSString *phoneNumber = userPhone;
    BOOL isHaveOrder =  [[NSUserDefaults standardUserDefaults]boolForKey:@"RobOrderSuccess"];
    [self locatemap];
    if (isHaveOrder) {
        
         [self locatemap];
        
    }else{
        
        NSString *baseStr = base_url;
        NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getOrderByTrucker"];
        [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"status":@"2",@"page":@"1"} success:^(id responseObj) {
            
            
         NSMutableArray *dataArr = [ModelOrder mj_objectArrayWithKeyValuesArray:responseObj];
            for (ModelOrder *model in dataArr) {
             
                if ([model.basicStatus isEqualToString:@"1"]||[model.basicStatus isEqualToString:@"2"]) {
                    
                     [self locatemap];
                    
                }else{
                
                    
                }
                
                
            }
            
//            [self.statusFrames addObjectsFromArray:statusFrameArray];

        } failure:^(NSError *error) {
        }];
    
        
    
    }

}

-(void)locatemap
{
    _isBackGround = NO;
    [self startLocationService];
    
//        timer = [NSTimer scheduledTimerWithTimeInterval:20.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//
//            [locationManager startUpdatingLocation];
//            
//            
//            
//        }];
    
}
- (void)loginLocation{
    
    locationManager = [[CLLocationManager alloc]init];
    CGFloat YZLMiOS8Later = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (YZLMiOS8Later >= 8 ){
       
        [locationManager requestAlwaysAuthorization];
    }
}
- (void)startLocationService{
    
    self.nowLocationTime = [[NSDate date] timeIntervalSince1970];
    //当前时间和最后一次时间相差大于8秒 将重新开启定位 否则返回最近一次定位坐标
    if (self.nowLocationTime - self.lastLocationTime > 6) {
        if (![self checkCLAuthorizationStatus]) {
            return;
        }
        
        locationManager = [[CLLocationManager alloc]init];
        _locService = [[BMKLocationService alloc]init];
        CGFloat YZLMiOS8Later = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (YZLMiOS8Later >= 8 ){
            [locationManager requestAlwaysAuthorization];
        }
        if (YZLMiOS8Later >= 9) {
            _locService.allowsBackgroundLocationUpdates = YES;
        }
      
        _locService.delegate = self;
        _locService.distanceFilter = 5.0f;
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
        _locService.pausesLocationUpdatesAutomatically = NO;
        //启动LocationService
        [_locService startUserLocationService];

    }
}
//检测是否打开定位
- (BOOL)checkCLAuthorizationStatus{
    if ([CLLocationManager locationServicesEnabled] == NO){
        NSLog(@"你目前有这个设备的所有位置服务禁用");
        return NO;
    }else{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            NSLog(@"请开启定位服务");
            return NO;
        }
        return YES;
    }
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    if (!_loginSuccess) {
        return;
    }
    self.lastLocationTime = [[NSDate date] timeIntervalSince1970];
//    CLLocation *currentLocation = [locations lastObject];
    _currentLocation  = userLocation.location;
    NSLog(@"======ggg===%f%f",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
   
    [self sendGeoCodeSearch:CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude)];
   

    if (_isBackGround == YES) {
        if (self.restartTime) {
            return;
        }
        self.bgTask = [YZBackgroundTaskManager sharedBackgroundTaskManager];
        [self.bgTask beginNewBackgroundTask];
        
        //如果1分钟没有调用代理将重启定位服务
        self.restartTime = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                          selector:@selector(restartLocationUpdates)
                                                          userInfo:nil
                                                           repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.restartTime forMode:NSRunLoopCommonModes];

    }

    
}
- (void)restartLocationUpdates{
    NSLog(@"重启定位服务");
    if (self.restartTime) {
        [self.restartTime invalidate];
        self.restartTime = nil;
    }
    [self startLocationService];
}

//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}




- (void)applicationWillResignActive:(UIApplication *)application {
   
    NSLog(@"即将进入后台");
//  [self backgroundHandler];

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    NSLog(@"进入后台");
//    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:30 handler:^{
//        [self backgroundHandler];
//        
//    }];
//    if (backgroundAccepted)
//    {
//        NSLog(@"backgroundingaccepted");
//
//    }
//    [self backgroundHandler];
    
    if (_loginSuccess == YES) {
        [self startLocationService];
        _isBackGround = YES;
        //如果是需要进行后台定位将设置后台任务
        self.bgTask = [YZBackgroundTaskManager sharedBackgroundTaskManager];
        [self.bgTask beginNewBackgroundTask];
        

        }
    }
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
    //  即将进入前台  取消小红点

    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
    
    
     _isBackGround = NO;
     NSLog(@"进入前台--");
    if (_loginSuccess == YES) {
        // 进入前台
        self.bgTask = [YZBackgroundTaskManager sharedBackgroundTaskManager];
        [self.bgTask endAllBackgroundTasks];
        [self startLocationService];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
 
  
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)dealloc{
    
    [self.restartTime invalidate];
    self.restartTime = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark ======== 支付宝支付 =========
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
           
        }];
    }
    if ([url.scheme isEqualToString:WeiXinPayID]) {
        return   [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {

                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALPaySuccess" object:nil];
                
            }else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
                
//                [MBProgressHUD showInfoMessage:@"用户取消支付"];
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"alPayUserCancel" object:nil];
                
                
            }else{
                
//                [MBProgressHUD showError:@"支付失败"];
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"alPayPayError" object:nil];
                
            }

            
        }];
    }else if ([url.scheme isEqualToString:WeiXinPayID]){
       return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}
- (void)handleOpenURl:(NSURL *)url
{
    
    if ([url.host isEqualToString:@"safepay"] ) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            [self handleAlipayResult:resultDic];
        }];
    }
}

#pragma mark - 支付宝支付处理结果
- (void)handleAlipayResult:(NSDictionary *)resultDic
{
    
    if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
        
        
        //        [MBProgressHUD showSuccess:@"支付成功" toView:view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALPaySuccess" object:nil];
        
        
    }else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
        
        [MBProgressHUD showInfoMessage:@"用户取消支付"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXUserCancel" object:nil];
        
        
    }else{
        [MBProgressHUD showErrorMessage:@"支付失败"];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPayError" object:nil];
        
    }
}



#pragma mark =============== 微信支付回调 ===============
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}
// 微信支付
- (void)onResp:(BaseResp *)resp {
    
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    switch (resp.errCode) {
        case WXSuccess:
            
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPaySuccess" object:nil];
            
            break;
        case WXErrCodeUserCancel:
            strMsg = @"支付结果：用户取消！";
            NSLog(@"用户取消，retcode = %d", resp.errCode);
            
            break;
            default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            
            break;
    }
}



- (void)sendGeoCodeSearch:(CLLocationCoordinate2D )location{
    
    BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = location;
    BOOL flag = [geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
        
    }
    else{
        NSLog(@"反geo检索发送失败");
    }
}
//
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{

   if (_loginSuccess == NO) {
      return;
   }
    if (result.address != nil)
    {
//        NSLog(@"我的车队成功－－－－－－reGeocode:%@",result.address);
//        NSLog(@"我的车队成功成功获取逆地理编码功成功获取逆地理编码reGeocode:%@",result.businessCircle);
//        NSLog(@"我的车队成功成功获取逆地理编码功成功获取逆地理编码reGeocode:%@",result.addressDetail);
//        NSLog(@"我的车队成功成功获取逆地理编码功成功获取逆地理编码reGeocode:%@",result.sematicDescription);
        NSString *addressDet = result.address;
        NSString *name = addressDet;
        if (result.poiList.count > 0) {

            BMKPoiInfo *info = result.poiList[0];
//            SLog(@"我的车队成功成功获取逆地理编码功成功获取逆地理编码reGeocode:%@",info.name);
            NSLog(@"我的车队成功成功获取逆地理编码功成功获取逆地理编码reGeocode:%@",info.address);
            addressDet = [result.address stringByAppendingString:info.name];
            name = info.name;
        
        
       
        }
        NSString *phoneNumber = userPhone;

        NSDictionary *dic = @{@"latitude" : @(_currentLocation.coordinate.latitude),
                              @"longitude": @(_currentLocation.coordinate.longitude),
                              @"phone": phoneNumber,
                              @"address":addressDet,
                              @"name":name};
        NSString *str2 = [self dictionaryToJson:dic];
        
        NSString *baseStr = base_url;
        NSString *urlStr = [baseStr stringByAppendingString:@"app/coordinates/insertCoord"];
        [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"coordinates" : str2} success:^(id responseObj) {
            
            NSLog(@"＝＝＝＝＝＝＝＝＝司机时时上传坐标成功%@＝＝＝＝＝＝＝＝＝＝",str2);
            
            
        } failure:^(NSError *error) {
            
            
        }];

    }


}

@end
