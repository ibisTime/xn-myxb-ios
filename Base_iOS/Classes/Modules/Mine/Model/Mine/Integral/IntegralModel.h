//
//  IntegralModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface IntegralModel : BaseModel
//库存
@property (nonatomic, assign) NSInteger quantity;
//图文详情
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *faceKind;
//广告语
@property (nonatomic, copy) NSString *slogan;
//缩略图
@property (nonatomic, copy) NSString *advPic;
//产品图片
@property (nonatomic, copy) NSString *pic;
//由pic 转化成的 数组,eg: http://wwwa.dfdsf.dcom
@property (nonatomic,copy) NSArray *pics;
//产品编号
@property (nonatomic, copy) NSString *code;
//价格
@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *remark;
//产品名称
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *status;
//cellHeight
@property (nonatomic) CGSize size;

@end
