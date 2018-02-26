//
//  BrandOrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface BrandOrderModel : BaseModel

@property (nonatomic,copy) NSString *code;
//产品名称
@property (nonatomic, copy) NSString *productName;
//广告语
@property (nonatomic, copy) NSString *productSlogan;
//产品图片
@property (nonatomic, copy) NSString *productPic;
//产品编号
@property (nonatomic, copy) NSString *productCode;
//品牌编号
@property (nonatomic, copy) NSString *brandCode;
//总价
@property (nonatomic, strong) NSNumber *amount;
//单价
@property (nonatomic, strong) NSNumber *unitPrice;
//收货人
@property (nonatomic,copy) NSString *receiver;
//电话
@property (nonatomic,copy) NSString *reMobile;
//地址
@property (nonatomic,copy) NSString *reAddress;
//类型
@property (nonatomic,copy) NSString *type;
//商家嘱托
@property (nonatomic,copy) NSString *applyNote;

//0 待审核 1 审核未通过 2待发货 3待评价 4已完成
@property (nonatomic,copy) NSString *status; //状态

@property (nonatomic,copy) NSString *deliveryDatetime; //发货时间
@property (nonatomic,copy) NSString *applyDatetime; //发货时间
//快递编号
@property (nonatomic,copy) NSString *logisiticsCode;
//快递公司
@property (nonatomic,copy) NSString *logisiticsCompany;
//下单数量
@property (nonatomic, strong) NSNumber *quantity;

- (NSString *)getStatusName;

- (NSString *)getExpressName;

@end

FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillCheck;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusCheckFailed;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillSendGood;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillComment;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusDidComplete;
