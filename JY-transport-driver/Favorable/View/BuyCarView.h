//
//  BuyCarView.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCarView : UIView

@property (nonatomic, copy) void(^BuyCarBlock)(NSString *);  
@property (nonatomic,strong)UIImageView *currentImageView;
@property (nonatomic,strong)UILabel *carLabel;
@end
