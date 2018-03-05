//
//  GoodNewsModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface GoodNewsModel : BaseModel
//广告图
@property (nonatomic, copy) NSString *advPic;
//缩略图
@property (nonatomic, copy) NSString *pic;
//
@property (nonatomic,copy) NSArray *pics;
//标题
@property (nonatomic, copy) NSString *title;
//内容
@property (nonatomic, copy) NSString *desc;

@end

