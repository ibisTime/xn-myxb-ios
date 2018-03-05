//
//  OrderFooterView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
//M
#import "BrandOrderModel.h"
#import "IntegralOrderModel.h"
#import "AppointmentOrderModel.h"
#import "AchievementOrderModel.h"

typedef NS_ENUM(NSInteger, OrderEventsType) {
    
    OrderEventsTypeReceiptGood = 0, //确认收货
    OrderEventsTypeComment,         //评价
    OrderEventsTypeOverClass,       //下课
    OrderEventsTypeVisit,           //上门
};

typedef void(^OrderBlock)(OrderEventsType type);

@interface OrderFooterView : UITableViewHeaderFooterView
//品牌
@property (nonatomic,strong) BrandOrderModel *brandOrder;
//积分
@property (nonatomic, strong) IntegralOrderModel *integralOrder;
//预约
@property (nonatomic, strong) AppointmentOrderModel *appointmentOrder;
//成果
@property (nonatomic, strong) AchievementOrderModel *achievementOrder;

@property (nonatomic, copy) OrderBlock orderBlock;


@end
