//
//  BannerModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@interface BannerModel : BaseModel
//图片
@property (nonatomic, copy) NSString *pic;
//广告
@property (nonatomic, copy) NSString *url;
@property (nonatomic,copy) NSString *name;
//类型
@property (nonatomic, copy) NSString *kind;

@end
//广告
FOUNDATION_EXTERN NSString *const kBannerTypeAdvertisement;
//喜报
FOUNDATION_EXTERN NSString *const kBannerTypeGoodNews;
//预报
FOUNDATION_EXTERN NSString *const kBannerTypePrediction;
//品牌
FOUNDATION_EXTERN NSString *const kBannerTypeBrand;
//美容院
FOUNDATION_EXTERN NSString *const kBannerTypeSalon;
//专家
FOUNDATION_EXTERN NSString *const kBannerTypExpert;
