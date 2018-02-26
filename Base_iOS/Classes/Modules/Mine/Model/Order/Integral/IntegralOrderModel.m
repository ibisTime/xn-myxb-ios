//
//  IntegralOrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralOrderModel.h"

NSString *const kOrderStatusWillSendGood = @"0";
NSString *const kOrderStatusWillReceiveGood = @"1";
NSString *const kOrderStatusWillComment = @"2";
NSString *const kOrderStatusDidComplete = @"3";

@implementation IntegralOrderModel

- (NSString *)getStatusName {
    
    //0 待发货 2待评价 3已完成 4无货取消
    
    NSDictionary *dict = @{
                           @"0" : @"待发货",
                           @"1" : @"待收货",
                           @"2" : @"待评价",
                           @"3" : @"已完成",
                           @"4" : @"无货取消",
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
    
    if (dic[self.logisticsCompany]) {
        
        name = dic[self.logisticsCompany];
    }
    
    return name;
    
}

@end
