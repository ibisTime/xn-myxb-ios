//
//  IntegralOrderDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "IntegralOrderModel.h"

@interface IntegralOrderDetailVC : BaseViewController
//
@property (nonatomic, strong) IntegralOrderModel *order;
//评价
@property (nonatomic,copy) void(^commentSuccess)(void);
//收货
@property (nonatomic,copy) void(^receiveSuccess)(void);

@end
