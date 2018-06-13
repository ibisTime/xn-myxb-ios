//
//  BrandOrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandOrderModel.h"

NSString *const kBrandOrderStatusWillType = @"0";
NSString *const kBrandOrderStatusWillType1 = @"1";
NSString *const kBrandOrderStatusWillType2 = @"2";
NSString *const kBrandOrderStatusWillType3 = @"3";
NSString *const kBrandOrderStatusWillType4 = @"4";
NSString *const kBrandOrderStatusWillType5 = @"5";
NSString *const kBrandOrderStatusWillType6 = @"6";



@implementation BrandOrderModel

- (NSString *)getStatusName {
    
    //0 待审核 1 审核未通过 2待发货 3待评价 4已完成
    
    NSDictionary *dict = @{
                           kBrandOrderStatusWillType : @"待付款",
                           kBrandOrderStatusWillType1 : @"待发货",
                           kBrandOrderStatusWillType2 : @"已取消",
                           kBrandOrderStatusWillType3 : @"平台已取消",
                           kBrandOrderStatusWillType4 : @"待收货",
                           kBrandOrderStatusWillType5 : @"待评价",
                           kBrandOrderStatusWillType6 : @"已完成",

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
