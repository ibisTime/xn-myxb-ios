//
//  MyInfomationModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface MyInfomationModel : BaseModel

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *style;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *slogan;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *speciality;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *approver;

@property (nonatomic, copy) NSString *approveDatetime;

@property (nonatomic, copy) NSString *applyDatetime;
//资料状态(1 待审核 2 审核不通过 3 审核通过)
@property (nonatomic, copy) NSString *status;

@end
