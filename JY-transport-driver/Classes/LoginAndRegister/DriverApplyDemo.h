//
//  DriverApplyDemo.h
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/9.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverApplyDemo : UIView

@property (nonatomic,strong)UIButton *finishBtn;
- (void)showImgView:(NSString *)imgName;

- (void)disMissView;

- (void)updatHeight:(int)bottomheight imgHeight:(int)imgHeight;

@end
