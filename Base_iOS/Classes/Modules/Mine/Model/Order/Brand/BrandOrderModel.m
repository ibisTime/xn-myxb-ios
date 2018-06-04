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
                           kBrandOrderStatusWillCheck : @"待审核",
                           kBrandOrderStatusCheckFailed : @"审核未通过",
                           kBrandOrderStatusWillSendGood : @"待发货",
                           kBrandOrderStatusWillComment : @"待评价",
                           kBrandOrderStatusDidComplete : @"已完成",
                           };
    
    return dict[self.status];
}
- (BrandDetailModel *)detailModel
{
    if (self.productOrderList.count == 0) {
        return nil;
    }
    NSDictionary *dic = [self.productOrderList objectAtIndex:0];
    return [BrandDetailModel mj_objectWithKeyValues:dic];
}
- (NSString *)getExpressName {
    
    __block NSString *name = @"其他";
    
    [self.expresses enumerateObjectsUsingBlock:^(ExpressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([self.logisiticsCompany isEqualToString:obj.dkey]) {
            
            name = obj.dvalue;
        }
    }];
    
    return name;
}

@end
