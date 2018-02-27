//
//  AppointmentOrderDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "AppointmentOrderModel.h"

@interface AppointmentOrderDetailVC : BaseViewController
//
@property (nonatomic, strong) AppointmentOrderModel *order;
//上门
@property (nonatomic,copy) void(^visitSuccess)(void);
//下课
@property (nonatomic,copy) void(^overClassSuccess)(void);

@end
