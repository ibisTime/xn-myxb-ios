//
//  BrandOrderFooterView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BrandOrderModel.h"

typedef NS_ENUM(NSInteger, BrandOrderEventsType) {
    
    BrandOrderEventsTypeReceiptGood = 0, //确认收货
    BrandOrderEventsTypeComment,         //评价
};

typedef void(^BrandOrderBlock)(BrandOrderEventsType type);

@interface BrandOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) BrandOrderModel *order;

@property (nonatomic, assign) BrandOrderEventsType eventsType;

@property (nonatomic, copy) BrandOrderBlock orderBlock;

@end
