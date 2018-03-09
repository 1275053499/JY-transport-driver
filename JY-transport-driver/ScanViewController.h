//
//  ScanViewController.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/10.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>


@protocol ScanViewControllerDelegate <NSObject>

- (void)chooseScanNumber:(NSString *)str;

@end

@interface ScanViewController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate>


@property (nonatomic,strong)NSString *whitchVCFrom;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)id <ScanViewControllerDelegate> delegate;
@end
