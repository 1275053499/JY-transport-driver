//
//  AppDelegate.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.


#import <UIKit/UIKit.h>
#import "GuideViewController.h"
#import "CustomTabBarViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GuideViewController *guideViewController;
@property (strong, nonatomic) CustomTabBarViewController *tabBarController;

//@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier bgTask;
-(void)beginLocation_driver;


@end

