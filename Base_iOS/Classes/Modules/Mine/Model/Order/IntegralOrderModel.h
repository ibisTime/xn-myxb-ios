//
//  IntegralOrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "IntegralOrderDetailModel.h"

@interface IntegralOrderModel : BaseModel

@property (nonatomic,copy) NSString *code;

//产品名称
@property (nonatomic, copy, readonly) NSString *productName;
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

//物品数组 <OrderDetailModel *>
@property (nonatomic,copy) NSArray <IntegralOrderDetailModel *> *productOrderList;

//0全部 1待支付 2 待发货 3 待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
@property (nonatomic,copy) NSString *status; //状态

@property (nonatomic,copy) NSString *deliveryDatetime; //发货时间
@property (nonatomic,copy) NSString *applyDatetime; //发货时间
//快递编号
@property (nonatomic,copy) NSString *logisticsCode;
//快递公司
@property (nonatomic,copy) NSString *logisticsCompany;
//下单数量
@property (nonatomic, strong) NSNumber *quantity;

- (NSString *)getStatusName;

@end
