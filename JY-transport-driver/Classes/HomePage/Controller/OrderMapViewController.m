//
//  OrderMapViewController.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderMapViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XGAnnotation.h"
#import "XGAnnotationView.h"
#import "ScottAlertController.h"
#import "UIImage+ScottExtension.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "OrderMapRequestManager.h"
#import "OrderMapAddressTableViewCell.h"
#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.85
#define MAX_DEGREES_ARC 360
@interface OrderMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,OrderMapRequestDataDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, weak) UIButton *centerButton;
@property(nonatomic,weak)UIButton *zoomin;
@property(nonatomic,weak)UIButton *zoomout;
@property(nonatomic,strong)NSMutableArray *arrivePlaceAddressArray;
@property(nonatomic,strong)NSMutableArray *locationArr;
@property(nonatomic,strong)NSMutableArray *arrivePlaceLatitudeArray;
@property(nonatomic,strong)NSMutableArray *arrivePlaceLongitudeArray;


@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)CLLocation *userLocation;

@end

@implementation OrderMapViewController
{
    BMKMapView                          *_map;
    CLLocationManager              *_manager;
    UISegmentedControl             *_segment;
    UIButton                       *_backBtn;
    UIButton                     *_aerialBtn;
    NSMutableArray         *_polyLineMutable;
    NSMutableArray            *_routeDetails;
    
}
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.locationArr = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnAction)];

    //地理位置数组
    self.arrivePlaceAddressArray = [NSMutableArray array];
    NSArray *arr= [self.OrderModel.district componentsSeparatedByString:@","];
    [self.arrivePlaceAddressArray addObjectsFromArray:arr];
    [self.arrivePlaceAddressArray removeLastObject];
    
    // 地理坐标数组
    self.arrivePlaceLatitudeArray = [NSMutableArray array];
    NSArray *endLatitude= [self.OrderModel.endLatitude componentsSeparatedByString:@","];
    [self.arrivePlaceLatitudeArray addObjectsFromArray:endLatitude];
    [self.arrivePlaceLatitudeArray removeLastObject];
    
    
    self.arrivePlaceLongitudeArray = [NSMutableArray array];
    NSArray *endLongtitude= [self.OrderModel.endLongitude componentsSeparatedByString:@","];
    [self.arrivePlaceLongitudeArray addObjectsFromArray:endLongtitude];
    [self.arrivePlaceLongitudeArray removeLastObject];

    
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    _polyLineMutable = [NSMutableArray array];
    _routeDetails = [NSMutableArray array];
    // 添加地图
    [self addMapView];
    // 设置地图的模式
    // [self addMapViewModel];
    // 设置返回按钮
    [self addBackBtn];
    // 设置航拍模式
    [self addAerialBtn];
    // 设置地图的缩放模式
    [self addMapScale];
    // 绘制线路图
    // [self addDrawControl];
    
    // 服务按钮
    [self creatCenterButton];
    //添加开始和结束两个按钮
    [self addStartAndEndAnnotation];
    
    //[self EndFuwu];
    [self creatTopAddressView];
    [self changeTitleNameAndBtnName];
}
- (void)changeTitleNameAndBtnName{
    
    if ([self.OrderModel.basicStatus isEqualToString:@"1"]) {
        self.navigationItem.title=@"等待装货";
        [self.centerButton setTitle:@"到达起点" forState:(UIControlStateNormal)];
    }else if ([self.OrderModel.basicStatus isEqualToString:@"7"]){
        self.navigationItem.title=@"装货中";
        [self.centerButton setTitle:@"开始服务" forState:(UIControlStateNormal)];

    }else if ([self.OrderModel.basicStatus isEqualToString:@"2"]){
      
        self.navigationItem.title=@"运输中";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithTitle:@"开始导航" target:self action:@selector(beginNavigation)];
        
        
        [self.centerButton setTitle:@"到达终点" forState:(UIControlStateNormal)];

    }else if ([self.OrderModel.basicStatus isEqualToString:@"8"]){
        self.navigationItem.title=@"卸货中";
        [self.centerButton setTitle:@"结束服务" forState:(UIControlStateNormal)];

    }else{
        self.navigationItem.title=@"";
        
    }
}
- (void)creatTopAddressView{
    
    OrderMapAddressTableViewCell *addressView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderMapAddressTableViewCell class]) owner:nil options:0][0];
    addressView.backgroundColor = [UIColor whiteColor];
    addressView.frame = CGRectMake(0, 0, ScreenWidth, 109);
    addressView.model = self.OrderModel;
    [self.view addSubview:addressView];
}
//添加开始和结束两个按钮
-(void)addStartAndEndAnnotation
{
    
    
    XGAnnotation *startAnnotation = [[XGAnnotation alloc] init];
    CLLocationCoordinate2D startAnnotationcoor =  CLLocationCoordinate2DMake([self.OrderModel.latitude doubleValue], [self.OrderModel.longitude doubleValue]);
    startAnnotation.coordinate = startAnnotationcoor;
    startAnnotation.title = @"起点";
    startAnnotation.subtitle = self.OrderModel.city;
    startAnnotation.icon = @"start";
    [_map addAnnotation:startAnnotation];
    
    XGAnnotation *endAnnotation = [[XGAnnotation alloc] init];
    
    CLLocationCoordinate2D coor =  CLLocationCoordinate2DMake([self.arrivePlaceLatitudeArray.lastObject doubleValue], [self.arrivePlaceLongitudeArray.lastObject doubleValue]);
    endAnnotation.coordinate = coor;
    endAnnotation.title = @"终点";
    endAnnotation.icon = @"end";
    endAnnotation.subtitle = self.arrivePlaceAddressArray.lastObject;
    [_map addAnnotation:endAnnotation];
    //    [annotationArr addObject:startAnnotation];
    //    [annotationArr addObject:endAnnotation];
    //    [_map showAnnotations:annotationArr animated:YES];

    if (self.arrivePlaceAddressArray.count>1) {
        
        for (int i = 0; i < self.arrivePlaceAddressArray.count-1; i ++) {
    
            XGAnnotation *centerAnnotation = [[XGAnnotation alloc] init];
            centerAnnotation.title = @"临时装货点";
            centerAnnotation.icon = [NSString  stringWithFormat:@"linshi%d",i+1];
            centerAnnotation.subtitle = self.arrivePlaceAddressArray[i];
            centerAnnotation.coordinate = CLLocationCoordinate2DMake([self.arrivePlaceLatitudeArray[i] doubleValue], [self.arrivePlaceLongitudeArray[i] doubleValue]);
            [_map addAnnotation:centerAnnotation];
            
            
        }
        
    }
    
     [self zoomMapViewToFitAnnotations:_map animated:YES];
    
    
    
    //
    //    NSMutableArray *centerPointArr = [NSMutableArray array];
    //    for (NSString *arrStr in self.arrivePlaceAddressArray) {
    //
    //
    //        [self.geocoder geocodeAddressString:arrStr completionHandler:^(NSArray *placemarks, NSError *error) {
    //            if (error) return;
    //
    //            CLPlacemark *placemark = [placemarks firstObject];
    //            XGAnnotation *centerAnnotation = [[XGAnnotation alloc] init];
    //            centerAnnotation.coordinate = placemark.location.coordinate;
    //            centerAnnotation.title = @"临时装货点";
    //            centerAnnotation.icon = @"car";
    //            centerAnnotation.subtitle = arrStr;
    //
    //            [self.locationArr addObject:centerAnnotation];
    //
    //        }];
    //
    //    }
    //
    //    [_map addAnnotations:self.locationArr];
    

    
}


- (void) onVolumeChanged: (int)volume{}




#pragma mark - 开始绘制路线
-(void)addDrawControl
{
    
    if (nil != _polyLineMutable) {
        [_map removeOverlays:_polyLineMutable];
        [_polyLineMutable removeAllObjects];
    }
    
    // 使用自定义地图进行导航  将起点和终点发送给服务器,由服务器返回导航结果
    // 1、创建导航请求对象
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 2、设置起点和终点
    request.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *soureceMark = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake([self.OrderModel.latitude doubleValue], [self.OrderModel.longitude doubleValue])];
    request.source = [[MKMapItem alloc]initWithPlacemark:soureceMark];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.OrderModel.district completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count == 0 || error) {
            return ;
        }
        CLPlacemark *clPm = placemarks.lastObject;
        MKPlacemark *pm = [[MKPlacemark alloc] initWithPlacemark:clPm];
        request.destination = [[MKMapItem alloc] initWithPlacemark:pm];
        //3.创建导航对象
        MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
        //4.计算导航路线 传递数据给服务器
        [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            for (MKRoute *route in response.routes) {
                
                for (MKRouteStep *step in route.steps) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[step.instructions,@(step.distance)] forKeys:@[@"details",@"distance"]];
                    [_routeDetails addObject:dict];
                }
                [_map addOverlay:route.polyline];
                [_polyLineMutable addObject:route.polyline];
            }
        }];
    }];
}
#pragma mark - MKMapViewDelegate
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.lineWidth = 3;
    render.strokeColor = [UIColor purpleColor];
    
    return render;
}

#pragma mark - 添加航拍按钮_backBtn
-(void)addAerialBtn{
    UIButton *aerialBtn = [[UIButton alloc] initWithFrame:CGRectMake(_backBtn.frame.origin.x, _backBtn.frame.origin.y - 35, 30, 30)];
    aerialBtn.backgroundColor = [UIColor clearColor];
    [aerialBtn setImage:[UIImage imageNamed:@"aerial"] forState:UIControlStateNormal];
    
    [aerialBtn addTarget:self action:@selector(addAerialModel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aerialBtn];
    _aerialBtn = aerialBtn;
}

#pragma mark - 设置地图的航拍模式
-(void)addAerialModel{
    // 设置航拍模式
    //    _map.camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(39.9, 116.4) fromDistance:100 pitch:90 heading:0];
    _map.userTrackingMode = BMKUserTrackingModeFollow;
}

//#pragma mark - 添加大头针
//// 大头针视图是有系统来添加的，但是大头针的数据是需要由开发者通过大头针模型来设置的
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//        XGAnnotation *annotation = [[XGAnnotation alloc] init];
//        UITouch *touch = touches.anyObject;
//        CGPoint point = [touch locationInView:_map];
//        CLLocationCoordinate2D coor = [_map convertPoint:point toCoordinateFromView:_map];
//        annotation.coordinate = coor;
//        annotation.title = @"点我干哈";
//        annotation.subtitle = @"😋";
//        [_map addAnnotation:annotation];
//    [self.view endEditing:YES];
//}

#pragma mark - 设置地图的放大和缩小
-(void)addMapScale{
    UIButton *zoomin = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 40, ScreenHeight-150, 30, 30)];
    zoomin.backgroundColor = [UIColor clearColor];
    //    [zoomin setTitle:@"放大" forState:UIControlStateNormal];
    //    [zoomin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [zoomin setBackgroundImage:[UIImage imageNamed:@"amplify"] forState:UIControlStateNormal];
    [self.view addSubview:zoomin];
    [zoomin addTarget:self action:@selector(clickZoom1:) forControlEvents:UIControlEventTouchUpInside];
    _zoomin = zoomin;
    
    UIButton *zoomout = [[UIButton alloc] initWithFrame:CGRectMake(zoomin.frame.origin.x, zoomin.frame.origin.y + 35, 30, 30)];
    zoomout.backgroundColor = [UIColor clearColor];
    //    [zoomout setTitle:@"缩小" forState:UIControlStateNormal];
    //    [zoomout setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [zoomout setBackgroundImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    [self.view addSubview:zoomout];
    [zoomout addTarget:self action:@selector(clickZoom2:) forControlEvents:UIControlEventTouchUpInside];
    _zoomout = zoomout;
    
}
#pragma mark - 地图的缩放

// 变大
-(void)clickZoom1:(UIButton *)sender{
    CLLocationCoordinate2D coordinate = _map.region.center;
    BMKCoordinateSpan spn;
    _zoomout.hidden = NO;
    spn = BMKCoordinateSpanMake(_map.region.span.latitudeDelta * 0.5, _map.region.span.longitudeDelta * 0.5);
    
    
    [_map setRegion:BMKCoordinateRegionMake(coordinate, spn) animated:YES];
    
}
//变小
-(void)clickZoom2:(UIButton *)sender{
    
    CLLocationCoordinate2D coordinate = _map.region.center;
    BMKCoordinateSpan spn;
    spn = BMKCoordinateSpanMake(_map.region.span.latitudeDelta * 2, _map.region.span.longitudeDelta * 02);
    if (spn.latitudeDelta >= 114 && spn.longitudeDelta >= 102) {
        _zoomout.hidden = YES;
        return;
    }
    [_map setRegion:BMKCoordinateRegionMake(coordinate, spn) animated:YES];
    
    
}


#pragma mark - 设置返回按钮
-(void)addBackBtn{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, ScreenHeight- 120, 30, 30)];
    backBtn.backgroundColor = [UIColor clearColor];
    //    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    //    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [backBtn setImage:[UIImage imageNamed:@"current_location"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    _backBtn = backBtn;
}
#pragma mark - 返回按钮的响应事件
-(void)clickBackBtn{
    CLLocationCoordinate2D coordinate = _userLocation.coordinate;
    // 设置跨度 = 当前地图的跨度
    BMKCoordinateSpan spn = _map.region.span;
    [_map setRegion:BMKCoordinateRegionMake(coordinate, spn) animated:YES];
}

#pragma mark - 添加地图的模式
-(void)addMapViewModel{
    NSArray *array = @[@"标准",@"卫星",@"混合",@"地图卫星立交桥",@"混合立交桥"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.frame = CGRectMake(20, 20, ScreenWidth-40, 40);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(clickMapViewModel:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    _segment = segment;
}
#pragma mark - 地图模式响应事件
-(void)clickMapViewModel:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case MKMapTypeStandard:
            _map.mapType = MKMapTypeStandard;
            break;
        case MKMapTypeSatellite:
            _map.mapType = MKMapTypeSatellite;
            break;
        case MKMapTypeHybrid:
            _map.mapType = MKMapTypeHybrid;
            break;
        case MKMapTypeSatelliteFlyover:
            _map.mapType = MKMapTypeSatelliteFlyover;
            break;
        case MKMapTypeHybridFlyover:
            _map.mapType = MKMapTypeHybridFlyover;
            break;
        default:
            break;
    }
}

#pragma mark - 添加地图
-(void)addMapView{
    BMKMapView *map = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
       _map = map;
     [_map setLogoPosition:BMKLogoPositionRightBottom];
    [self.view addSubview:map];

    // 在地图上显示定位
    // 1、请求授权(在Info.plist中添加NSLocationWhenInUseUsageDescription）
    _manager = [[CLLocationManager alloc] init];
    [_manager requestWhenInUseAuthorization];
    
    // 2.设置地图的用户跟踪模式
    map.userTrackingMode = BMKUserTrackingModeFollow;
    map.delegate = self;
    
    // 其他的新属性
    // 显示指南针
    //    _map.showsCompass = YES;
    //    // 显示感兴趣的点，默认是显示的
    //    _map.showsPointsOfInterest = YES;
    //    // 显示标尺(单位：mi 英尺)
    //    _map.showsScale = YES;
    //    // 显示交通情况
    //    _map.showsTraffic = YES;
    //    // 显示定位大头针，默认是显示的
    _map.showsUserLocation = YES;
    // 显示建筑物的3D模型，设置3D/沙盘/航拍模式(高德地图不支持)
    //    _map.showsBuildings = YES;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 10;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
//    _locService.allowsBackgroundLocationUpdates = YES;
    _locService.pausesLocationUpdatesAutomatically = NO;
    [_locService startUserLocationService];
}
#pragma mark - MKMapViewDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _userLocation = userLocation.location;
    // 取出用户当前的经纬度
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    
    // 设置地图的中心点（以用户所在的位置为中心点）
    [_map setCenterCoordinate:userLocation.location.coordinate animated:YES];
    BMKCoordinateRegion region;
    region.center.longitude = center.longitude;
    region.center.latitude = center.latitude;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    [_map updateLocationData:userLocation];
    [_map setRegion:region animated:YES];
    NSLog(@"===================%f",userLocation.location.coordinate.latitude);
    
}
//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count == 0 || error) {
//            return ;
//        }
//        CLPlacemark *pm = placemarks.lastObject;
//        _map.userLocation.title = [NSString stringWithFormat:@"%@-%@-%@",pm.administrativeArea,pm.locality,pm.subLocality];
//        _map.userLocation.subtitle = pm.name;
//
//    }];
//}
//#pragma mark - 大头针的重用
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    // 排除已经定位的大头针
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    XGAnnotationView *anV = [XGAnnotationView xg_annotationWithMapView:_map];
//     anV.image = [UIImage imageNamed:@"origin"];
//
//    return anV;
//}
//#pragma mark - 当已经添加大头针视图后调用(还没有显示在地图上)该方法可以用来设置自定义动画
//-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
//    for (MKAnnotationView *anv in views) {
//        // 排除定位的大头针
//        if ([anv.annotation isKindOfClass:[MKUserLocation class]]) {
//            return;
//        }
//        CGRect targetRect = anv.frame;
//        // 修改位置
//        anv.frame = CGRectMake(targetRect.origin.x, 0, targetRect.size.width, targetRect.size.height);
//        [UIView animateWithDuration:0.3 animations:^{
//            anv.frame = targetRect;
//        }];
//    }
//}

- (void)viewDidAppear:(BOOL)animated{
    
    [self zoomMapViewToFitAnnotations:_map animated:YES];
}
- (void)zoomMapViewToFitAnnotations:(BMKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    int count = (int)[mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    BMKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <BMKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = BMKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    BMKMapRect mapRect = [[BMKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    BMKCoordinateRegion region =  BMKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    NSLog(@"%@－－－－－－",[annotation class]);
    if (![annotation isKindOfClass:[XGAnnotation class]]) return nil;
    
    static NSString *ID = @"tuangou";
    // 从缓存池中取出可以循环利用的大头针view
    BMKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        // 显示子标题和标题
        annoView.canShowCallout = YES;
        // 设置大头针描述的偏移量
        annoView.calloutOffset = CGPointMake(0, -10);
        
        // 设置大头针描述左边的控件
        annoView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    // 传递模型
    annoView.annotation = annotation;
    // 设置图片
    XGAnnotation *tuangouAnno = annotation;
    annoView.image = [UIImage imageNamed:tuangouAnno.icon];
    return annoView;
    
}
/* 进入导航. */
- (void)beginNavigation
{
    
//    [self.geocoder geocodeAddressString:self.OrderModel.district completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error) return;
//
//        CLPlacemark *placemark = [placemarks firstObject];
//
//        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:placemark]];
//
//        NSMutableDictionary *options = [NSMutableDictionary dictionary];
//        options[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
//        options[MKLaunchOptionsShowsTrafficKey] = @YES;
//        [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:options];
//    }];
    
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.OrderModel.latitude floatValue], [self.OrderModel.longitude floatValue]);
      CLLocationCoordinate2D todloc = CLLocationCoordinate2DMake([self.OrderModel.endLatitude floatValue], [self.OrderModel.endLongitude floatValue]);
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//    currentLocation.name = self.OrderModel.departPlace;
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:todloc addressDictionary:nil]];
    
    
    NSArray *arrivePlaceArray = [_OrderModel.arrivePlace componentsSeparatedByString:@","];
    NSMutableArray *arriveArr = [NSMutableArray array];
    [arriveArr addObjectsFromArray:arrivePlaceArray];
    
    if ([_OrderModel.arrivePlace  rangeOfString:@","].location != NSNotFound) {
        
        [arriveArr removeLastObject];
    }
    toLocation.name = arriveArr.lastObject;

    
//    MKMapItem *statrLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
//    statrLocation.name = self.OrderModel.departPlace;

    
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
  
}


#pragma mark - action handle
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatCenterButton
{
    UIButton *centerButton = [FMButton createFMButton];
    centerButton.frame = CGRectMake((ScreenWidth-100)/2, ScreenHeight-200, 100, 100);
    centerButton.layer.cornerRadius= 50;
    centerButton.layer.borderWidth = 1;
    [centerButton setBackgroundColor:BGBlue];
    centerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:centerButton];
    self.centerButton =centerButton;

    [centerButton setTitle:@"到达起点" forState:UIControlStateNormal];
    [self.centerButton addTarget:self action:@selector(beginWithEndWoring) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)requestDataDriverOperationSuccess:(NSDictionary *)resultDic{
    
    NSString *message = [resultDic objectForKey:@"message"];
    NSString *basic_status = [resultDic objectForKey:@"basic_status"];
    if ([message isEqualToString:@"0"]){
        
        if ([basic_status isEqualToString:@"7"]) {
            self.navigationItem.title = @"装货中";
            [self.centerButton setTitle:@"开始服务" forState:(UIControlStateNormal)];
          
        }else if([basic_status isEqualToString:@"2"]){
            self.navigationItem.title = @"运输中";
            [self.centerButton setTitle:@"到达终点" forState:(UIControlStateNormal)];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem addRight_ItemWithTitle:@"开始导航" target:self action:@selector(beginNavigation)];
            
            
        }else if([basic_status isEqualToString:@"8"]){
            self.navigationItem.title = @"卸货中";
            [self.centerButton setTitle:@"结束服务" forState:(UIControlStateNormal)];
        }
        
    }else{
        
    }
}
- (void)requestDataDriverOperationFailed:(NSError *)error{
    
}
//点击了开始服务按钮或者结束服务按钮
-(void)beginWithEndWoring
{
    if ([self.centerButton.currentTitle isEqualToString:@"到达起点"]) {
       [self presentTipAlert:@"7"];
    }else if ([self.centerButton.currentTitle isEqualToString:@"开始服务"]) {
       [self presentTipAlert:@"2"];
    }else if ([self.centerButton.currentTitle isEqualToString:@"到达终点"]) {
        [self presentTipAlert:@"8"];
    }else if ([self.centerButton.currentTitle isEqualToString:@"结束服务"]) {
        [self sureEndServiceAndMoneyDetail];
        [self EndFuwu];
    }
    
}
- (void)presentTipAlert:(NSString *)operationStatus{
    
    NSString *message = @"";

    if ([operationStatus isEqualToString:@"2"]) {
        message = @"是否开始服务";
    }else  if ([operationStatus isEqualToString:@"7"]) {
        
        message = @"是否到达起点";
    }else  if ([operationStatus isEqualToString:@"8"]) {
        
        message = @"是否到达目的地";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle: UIAlertControllerStyleAlert];
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan addAttribute:NSFontAttributeName value: [UIFont fontWithName:Default_APP_Font_Reg size:17] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:RGB(3, 3, 3) range:NSMakeRange(0, [[hogan string] length])];
    [alert setValue:hogan forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
            [self arriveStratPlace:operationStatus];

    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureaction];
    [self presentViewController:alert animated:true completion:nil];
}

//获取当前时间
- (NSString *)getnowDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

- (void)arriveStratPlace:(NSString *)operationStatus{
    
    NSString *currentDateStr = [self getnowDate];
    OrderMapRequestManager *manager  = [OrderMapRequestManager shareInstance];
    manager.delegate = self;
    [manager requestDataDriverOperation:@"app/chartered/driverOperation" operationStatus:operationStatus orderNo:self.OrderModel.orderNo operationTime:currentDateStr];
    
}
//弹出价格和时间的警号
-(void)sureEndServiceAndMoneyDetail
{
    
    
    NSString *currentDateStr = [self getnowDate];
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/endReq"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"reqId":self.OrderModel.orderNo,@"endDate": currentDateStr} success:^(id responseObj) {
        
//        NSString *message = [@"用时：" stringByAppendingString:[responseObj objectForKey:@"time"]];
//        NSString *money = [responseObj objectForKey:@"cost"];
//        NSString *title = [NSString stringWithFormat:@"¥%@",money];
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
        
//        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
//        [hogan addAttribute:NSFontAttributeName value: [UIFont fontWithName:Default_APP_Font_Reg size:30] range:NSMakeRange(0, [[hogan string] length])];
//        [hogan addAttribute:NSForegroundColorAttributeName value:BGBlue range:NSMakeRange(0, [[hogan string] length])];
//        [alert setValue:hogan forKey:@"attributedTitle"];
//
//
//        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
//        [messageAtt addAttribute:NSFontAttributeName value: [UIFont fontWithName:Default_APP_Font_Reg size:17] range:NSMakeRange(0, [[messageAtt string] length])];
//        [messageAtt addAttribute:NSForegroundColorAttributeName value:RGB(3, 3, 3) range:NSMakeRange(0, [[hogan string] length])];
//        [alert setValue:messageAtt forKey:@"attributedMessage"];
//
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        
//        UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            [self EndFuwu];
//
//        }];
//
//        [alert addAction:cancelAction];
//        [alert addAction:sureaction];
//        [self presentViewController:alert animated:true completion:nil];
       
      
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
}


// 最终的结束服务
-(void)EndFuwu
{
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/changeReq"];

    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"orderNo":self.OrderModel.orderNo,@"status":@"3"} success:^(id responseObj) {
        
        
        if ([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccessMessage:@"结束服务成功"];
            [self.centerButton setEnabled:NO];
            self.centerButton.alpha = 0.4;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"button_selected"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"RobOrderSuccess"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"orderEndSuccess" object:nil];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showErrorMessage:@"结束服务失败"];
        }
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"========%@",error);
        
        [MBProgressHUD showErrorMessage:@"网络异常"];
    }];
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_map removeFromSuperview];
    _map.delegate = nil;
    _locService.delegate = nil;

    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}
@end
