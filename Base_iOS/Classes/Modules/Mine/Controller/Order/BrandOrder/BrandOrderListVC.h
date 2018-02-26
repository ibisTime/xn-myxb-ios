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
    BrandOrderStatusWillCheck = 0,       //待审核
    BrandOrderStatusWillSend = 1,        //待发货
    BrandOrderStatusWillComment = 2,     //待评价
    BrandOrderStatusDidComplete = 3,     //已完成
    
};

@interface BrandOrderListVC : BaseViewController

@property (nonatomic,assign) BrandOrderStatus status;

@property (nonatomic,copy) NSString *statusCode;

@end
