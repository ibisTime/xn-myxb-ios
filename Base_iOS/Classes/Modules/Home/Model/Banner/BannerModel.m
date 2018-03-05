//
//  BannerModel.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BannerModel.h"
#import "NSString+Extension.h"

//广告
NSString *const kBannerTypeAdvertisemnet = @"1";
//喜报
NSString *const kBannerTypeGoodNews      = @"2";
//预报
NSString *const kBannerTypePrediction    = @"3";
//品牌
NSString *const kBannerTypeBrand         = @"4";
//美容院
NSString *const kBannerTypeSalon         = @"5";
//专家
NSString *const kBannerTypExpert         = @"6";

@implementation BannerModel

- (NSString *)pic {
    
    return [_pic convertImageUrl];
}

@end
