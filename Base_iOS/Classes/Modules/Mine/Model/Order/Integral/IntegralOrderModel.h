//
//  IntegralOrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "ExpressModel.h"

@interface IntegralOrderModel : BaseModel

@property (nonatomic,copy) NSString *code;
//产品名称
@property (nonatomic, copy) NSString *productName;
//广告语
@property (nonatomic, copy) NSString *productSlogan;
//产品图片
@property (nonatomic, copy) NSString *productPic;
//总价
@property (nonatomic, strong) NSNumber *amount;
//单价
@property (nonatomic, strong) NSNumber *price;
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

//0全部 1 待发货 2 待收货 3 待评价 4 已完成 92 商户取消 93 快递异常
@property (nonatomic,copy) NSString *status; //状态

@property (nonatomic,copy) NSString *deliveryDatetime; //发货时间
@property (nonatomic,copy) NSString *applyDatetime; //发货时间
//快递编号
@property (nonatomic,copy) NSString *logisticsCode;
//快递公司
@property (nonatomic,copy) NSString *logisticsCompany;
//快递转义
@property (nonatomic, strong) NSArray <ExpressModel *> *expresses;
//下单数量
@property (nonatomic, strong) NSNumber *quantity;

- (NSString *)getStatusName;

- (NSString *)getExpressName;

@end

FOUNDATION_EXTERN NSString *const kOrderStatusWillSendGood;
FOUNDATION_EXTERN NSString *const kOrderStatusWillReceiveGood;
FOUNDATION_EXTERN NSString *const kOrderStatusWillComment;
FOUNDATION_EXTERN NSString *const kOrderStatusDidComplete;
