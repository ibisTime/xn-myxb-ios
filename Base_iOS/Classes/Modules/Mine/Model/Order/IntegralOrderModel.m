//
//  IntegralOrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralOrderModel.h"

@implementation IntegralOrderModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{ @"productOrderList" : [IntegralOrderDetailModel class]};
    
}

- (NSString *)getStatusName {
    
    //0 待发货 2待评价 3已完成 4无货取消
    
    NSDictionary *dict = @{
                           @"0" : @"待发货",
                           @"2" : @"待评价",
                           @"3" : @"已完成",
                           @"4": @"无货取消",
                           };
    
    return dict[self.status];
    
}

@end
