//
//  IntegralOrderFooterView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IntegralOrderModel.h"

typedef NS_ENUM(NSInteger, IntegralOrderEventsType) {
    
    IntegralOrderEventsTypeReceiptGood = 0, //确认收货
    IntegralOrderEventsTypeComment,         //评价
};

typedef void(^IntegralOrderBlock)(IntegralOrderEventsType type);

@interface IntegralOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) IntegralOrderModel *order;

@property (nonatomic, copy) IntegralOrderBlock orderBlock;

@end
