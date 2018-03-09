//
//  AppointmentOrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface AppointmentOrderListVC : BaseViewController
//订单状态
@property (nonatomic,copy) NSString *status;
//预约类型
@property (nonatomic, copy) NSString *kind;

@property (nonatomic,copy) NSString *statusCode;

@end
