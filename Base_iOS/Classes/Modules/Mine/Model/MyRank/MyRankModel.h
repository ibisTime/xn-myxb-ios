//
//  MyRankModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface MyRankModel : BaseModel
//金额
@property (nonatomic, strong) NSNumber *amount;
//日期
@property (nonatomic, copy) NSString *periods;
//排名
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, copy) NSString *rankImg;
//昵称
@property (nonatomic, copy) NSString *name;

@end
