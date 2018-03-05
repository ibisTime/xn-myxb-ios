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
@property (nonatomic, copy) NSString *realName;
//日期
@property (nonatomic, copy) NSString *commentDatetime;
//评分
@property (nonatomic, assign) NSInteger score;
//内容
@property (nonatomic, copy) NSString *content;
//是否被采纳
@property (nonatomic, copy) NSString *isAccept;

//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
