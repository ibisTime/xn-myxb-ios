//
//  BrandDetailModel.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressModel.h"

@interface BrandDetailModel : BaseModel
/*
advPic        string    @mock=广告图
brandName        string    @mock=品牌
orderNo        string    @mock=排序
price        string    @mock=价格
productCode        string    @mock=产品
productName        string    @mock=产品名称
quantity        string    @mock=数量
*/
@property (nonatomic , copy) NSString *advPic;

@property (nonatomic , copy) NSString *brandName;
@property (nonatomic , copy) NSString *orderNo;
@property (nonatomic , copy) NSNumber *price;
@property (nonatomic , copy) NSString *productCode;
@property (nonatomic , copy) NSString *productName;
@property (nonatomic , copy) NSNumber *quantity;
@property (nonatomic , strong)NSDictionary *product;

@end
