//
//  BrandOrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "ExpressModel.h"
#import "BrandDetailModel.h"
#import "MJExtension.h"

@interface BrandOrderModel : BaseModel

@property (nonatomic,copy) NSString *code;
//产品名称
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *brandName;

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

@property (nonatomic, strong) NSNumber *totalAmount;

//单价
@property (nonatomic, strong) NSNumber *unitPrice;
//收货人
@property (nonatomic,copy) NSString *receiver;
//电话
@property (nonatomic,copy) NSString *reMobile;
//地址
@property (nonatomic,copy) NSString *reAddress;
//下单人
@property (nonatomic,copy) NSString *applyUser;
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
//快递转义
@property (nonatomic, strong) NSArray <ExpressModel *>*expresses;
//下单数量
@property (nonatomic, strong) NSNumber *quantity;
//
@property (nonatomic, strong)NSArray *productOrderList;

@property (nonatomic, strong)BrandDetailModel *detailModel;

@property (nonatomic, assign)NSNumber *payType;


- (NSString *)getStatusName;

- (NSString *)getExpressName;

@end

FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillType;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillType1;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillType2;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillType3;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillType4;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillType5;
FOUNDATION_EXTERN NSString *const kBrandOrderStatusWillType6;


