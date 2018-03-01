//
//  PictureModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface PictureModel : BaseModel
//头像
@property (nonatomic, copy) NSString *url;
//等级
@property (nonatomic, copy) NSString *level;
//类型
@property (nonatomic, copy) NSString *kind;
//说明
@property (nonatomic, copy) NSString *remark;
//编号
@property (nonatomic, copy) NSString *code;
//是否选择
@property (nonatomic, assign) BOOL isSelected;

@end
