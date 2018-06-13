//
//  BrandOrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,BrandOrderStatus) {
    
    BrandOrderStatusAllOrder = -1,       //全部
    BrandOrderStatusWillTpye1 = 0,       //代付款
    BrandOrderStatusWillTpye2 = 1,        //待发货
    BrandOrderStatusWillTpye3 = 4,     //待收货
    BrandOrderStatusWillTpye4 = 5,     //带评价
    BrandOrderStatusWillTpye5 = 6,       //已完成
};

@interface BrandOrderListVC : BaseViewController

@property (nonatomic,assign) BrandOrderStatus status;

@property (nonatomic,copy) NSString *statusCode;

@end
