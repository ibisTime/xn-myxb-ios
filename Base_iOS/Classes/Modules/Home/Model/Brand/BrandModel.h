//
//  BrandModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface BrandModel : BaseModel

//广告语
@property (nonatomic, copy) NSString *slogan;
//顾问手机号
@property (nonatomic, copy) NSString *mobile;
//轮播图
@property (nonatomic, copy) NSString *advPic;
//编号
@property (nonatomic, copy) NSString *code;
//名称
@property (nonatomic, copy) NSString *name;
//价格
@property (nonatomic, strong) NSNumber *price;
//已售数量
@property (nonatomic, assign) NSInteger soldOutCount;
//缩略图
@property (nonatomic, copy) NSString *pic;
//品牌编号
@property (nonatomic, copy) NSString *brandCode;
//图文详情
@property (nonatomic, copy) NSString *desc;
//由pic 转化成的 数组
@property (nonatomic,copy) NSArray *pics;
//总条数
@property (nonatomic, assign) NSInteger totalCount;
//平均分
@property (nonatomic, assign) CGFloat average;
//
@property (nonatomic, assign) CGFloat commentHeight;

@end
