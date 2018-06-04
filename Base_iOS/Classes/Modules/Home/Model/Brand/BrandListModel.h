//
//  BrandListModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface BrandListModel : BaseModel
//广告语
@property (nonatomic, copy) NSString *slogan;
//手机号
@property (nonatomic, copy) NSString *mobile;
//缩略图
@property (nonatomic, copy) NSString *advPic;
//编号
@property (nonatomic, copy) NSString *code;
//名称
@property (nonatomic, copy) NSString *name;
//类别
@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *desc;

@end
