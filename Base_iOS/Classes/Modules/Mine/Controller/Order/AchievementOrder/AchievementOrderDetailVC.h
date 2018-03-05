//
//  AchievementOrderDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//M
#import "AchievementOrderModel.h"

@interface AchievementOrderDetailVC : BaseViewController
//
@property (nonatomic, strong) AchievementOrderModel *order;
//上门
@property (nonatomic,copy) void(^visitSuccess)(void);
//下课
@property (nonatomic,copy) void(^overClassSuccess)(void);

@end
