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
    
    __block NSString *name = @"其他";
    
    [self.expresses enumerateObjectsUsingBlock:^(ExpressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([self.logisticsCompany isEqualToString:obj.dkey]) {
            
            name = obj.dvalue;
        }
    }];
    
    return name;
}

@end
