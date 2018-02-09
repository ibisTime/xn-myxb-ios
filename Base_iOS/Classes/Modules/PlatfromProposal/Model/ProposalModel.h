//
//  ProposalModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

/**
 平台建议
 */
@interface ProposalModel : BaseModel
//头像
@property (nonatomic, copy) NSString *photo;
//昵称
@property (nonatomic, copy) NSString *nickName;
//日期
@property (nonatomic, copy) NSString *createTime;
//评分
@property (nonatomic, copy) NSString *score;
//内容
@property (nonatomic, copy) NSString *comment;

//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
