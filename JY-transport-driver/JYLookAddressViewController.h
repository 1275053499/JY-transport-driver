//
//  JYLookAddressViewController.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/21.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@protocol MapViewControllerDelegate <NSObject>

/**
 @代理回调方法
 @param address 格式化详细地址
 @param poi 兴趣点(附近建筑)
 @param location 位置经纬度
 **/
- (void)didSelectAddress:(NSString*)address poi:(NSString*)poi location:(CLLocationCoordinate2D)location;

//城市名称回调
- (void)selectProvinceInMapView:(NSString *)province city:(NSString *)city district:(NSString *)district;
@end



@interface JYLookAddressViewController : UIViewController
/**  代理  **/
@property(nonatomic,weak) id<MapViewControllerDelegate> delegate;


@end
