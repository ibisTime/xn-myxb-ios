//
//  RankingModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface RankingModel : BaseModel

//头像
@property (nonatomic, copy) NSString *photo;
//名字
@property (nonatomic, copy) NSString *name;
//金额
@property (nonatomic, strong) NSNumber *amount;
//排名
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, copy) NSString *rankImg;

//第几期
@property (nonatomic, copy) NSString *periods;

@end
