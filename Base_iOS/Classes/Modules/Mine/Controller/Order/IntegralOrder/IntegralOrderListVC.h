//
//  IntegralOrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,IntegralOrderStatus) {
    
    IntegralOrderStatusAllOrder = -1,       //全部
    IntegralOrderStatusWillSend = 0,        //待发货
    IntegralOrderStatusWillReceipt = 1,     //待收货
    IntegralOrderStatusWillComment = 2,     //待评价
    IntegralOrderStatusDidComplete = 3,     //已完成
    IntegralOrderStatusDidCancel = 4,       //无货取消

};

@interface IntegralOrderListVC : BaseViewController

@property (nonatomic,assign) IntegralOrderStatus status;

@property (nonatomic,copy) NSString *statusCode;

@end
