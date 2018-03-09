//
//  XGAnnotationView.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/20.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGAnnotationView.h"

@implementation XGAnnotationView

+(instancetype)xg_annotationWithMapView:(BMKMapView *)mapView{
    // 实现重用
    static NSString *ID = @"annotation";
    XGAnnotationView *anV = (XGAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (nil == anV) {
        anV = [[XGAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        //anV.image = [UIImage imageNamed:@"destination"];
        // 设置标注
        anV.canShowCallout = YES;
        
    }
    return anV;
}

-(void)setAnnotation:(id<BMKAnnotation>)annotation{
    [super setAnnotation:annotation];
}



@end
