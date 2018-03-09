//
//  JYChooseCityViewController.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JYChooseCityViewControllerDelegate <NSObject>

-(void)chooseServiceLine:(NSString *)City lineId:(NSString *)CityID provice:(NSString *)provice proviceID:(NSString *)proviceID;
@end

@interface JYChooseCityViewController : UIViewController

@property (nonatomic,strong)id <JYChooseCityViewControllerDelegate> delegate;

@end
