//
//  PSCityPickerView.h
//  Diamond
//
//  Created by Pan on 15/8/12.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSCityPickerView;

@protocol PSCityPickerViewDelegate <NSObject>

NS_ASSUME_NONNULL_BEGIN

/**
 *  告诉代理，用户选择了省市区
 *
 *  @param picker   picker
 *  @param province 省
 *  @param city     市
 *  @param district 区
 */
- (void)cityPickerView:(PSCityPickerView *)picker
    finishPickProvince:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district ProvinceID:(NSString *)provinceID
                  cityID:(NSString *)cityID
              districtID:(NSString *)districtID;

@end


@interface PSCityPickerView : UIPickerView

@property (nonatomic, weak, nullable) id<PSCityPickerViewDelegate> cityPickerDelegate;
@property (nonatomic,assign)NSInteger ComponentNum;
@property (nonatomic,assign)NSInteger ComponentWidth;
@property (nonatomic,assign)NSInteger ComponentRowheight;


- (void)showPickView;
NS_ASSUME_NONNULL_END

@end