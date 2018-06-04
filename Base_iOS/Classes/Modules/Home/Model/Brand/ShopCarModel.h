//
//  ShopCarModel.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ShopCarModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//数量
@property (nonatomic, assign) NSNumber *quantity;
//用户编号
@property (nonatomic, copy) NSString *userId;
//编号
@property (nonatomic, copy) NSString *carcode;
//产品编号
@property (nonatomic, copy) NSString *productCode;
////产品信息
@property (nonatomic, copy) NSDictionary *product;
//是否选中   默认为NO
@property (nonatomic, assign)BOOL isChouse;
/***
"description" : "Innisfree（悦诗风吟）是韩国化妆品品牌，也是由韩国第一化妆品集团AmorePacific爱茉莉太平洋集团潜心研制的自然主义化妆品，是高科技和自然的完美结合。这一品牌的化妆品的特性：自然、健康、朴素、时尚。从推出第一支产品迄今，悦诗风吟一直坚持这些理念，并运用先进科技，不断对品牌进行提升，追求自然与肌肤的完美融合。",
"updateDatetime" : "May 13, 2018 12:46:40 PM",
"soldOutCount" : 21,
"brandAdviser" : "U20180307181803655240",
"slogan" : "innisfree悦诗风吟是环保公益主力化妆品品牌.提供包括基础护理、洁面卸妆、面膜、彩妆、男士、身体系列和美妆工具.选取来自纯净岛屿的精萃原料,将健康之美赋予每一位消费者。",
"advPic" : "3_1520590820982.png||1_1520590823630.png||水乳套装_1520590827162.png",
"type" : "T",
"pic" : "悦诗风吟_1520590816885.jpg",
"code" : "P201803071841451103259",
"price" : 150000,
"location" : "1",
"orderNo" : 6,
"updater" : "admin",
"categoryCode" : "C201805090124597449796",
"brandCode" : "B201803071753067166795",
"remark" : "",
"name" : "悦诗风吟",
"status" : "2"
*/
@end
