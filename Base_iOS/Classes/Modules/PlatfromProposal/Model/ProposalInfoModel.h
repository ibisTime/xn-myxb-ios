//
//  ProposalInfoModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ProposalInfoModel : BaseModel
//平均分
@property (nonatomic, assign) CGFloat average;
//总条数
@property (nonatomic, assign) NSInteger totalCount;
//一星条数
@property (nonatomic, assign) NSInteger yfCount;
//二星条数
@property (nonatomic, assign) NSInteger lfCount;
//三星条数
@property (nonatomic, assign) NSInteger sfCount;
//四星条数
@property (nonatomic, assign) NSInteger siCount;
//五星条数
@property (nonatomic, assign) NSInteger wfCount;

@end
