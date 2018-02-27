//
//  BrandOrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandOrderModel.h"

NSString *const kBrandOrderStatusWillCheck = @"0";
NSString *const kBrandOrderStatusCheckFailed = @"1";
NSString *const kBrandOrderStatusWillSendGood = @"2";
NSString *const kBrandOrderStatusWillComment = @"3";
NSString *const kBrandOrderStatusDidComplete = @"4";

@implementation BrandOrderModel

- (NSString *)getStatusName {
    
    //0 待审核 1 审核未通过 2待发货 3待评价 4已完成
    
    NSDictionary *dict = @{
                           kBrandOrderStatusWillCheck : @"待发货",
                           kBrandOrderStatusCheckFailed : @"审核未通过",
                           kBrandOrderStatusWillSendGood : @"待发货",
                           kBrandOrderStatusWillComment : @"待评价",
                           kBrandOrderStatusDidComplete : @"已完成",
                           };
    
    return dict[self.status];
}

- (NSString *)getExpressName {
    
    NSString *name = @"其他";
    
    NSDictionary *dic = @{@"EMS":   @"邮政EMS",
                          @"STO":   @"申通快递",
                          @"ZTO":   @"中通快递",
                          @"YTO":   @"圆通快递",
                          @"HTKY":  @"汇通快递",
                          @"SF":    @"顺丰快递",
                          @"TTKD":  @"天天快递",
                          @"ZJS":   @"宅急送",
                          
                          };
    
    if (dic[self.logisiticsCompany]) {
        
        name = dic[self.logisiticsCompany];
    }
    
    return name;
}

@end
