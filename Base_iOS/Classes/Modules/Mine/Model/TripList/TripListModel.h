//
//  TripListModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface TripListModel : BaseModel
//开始时间
@property (nonatomic, copy) NSString *startDatetime;
//结束时间
@property (nonatomic, copy) NSString *endDatetime;
//code
@property (nonatomic, copy) NSString *code;
//type
@property (nonatomic) NSNumber *type;

@property (nonatomic, copy) NSString *planDatetime;//

@property (nonatomic, copy) NSString *mryApproveDatetime;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *realDatetime;

@property (nonatomic, copy) NSString *approveDatetime;

@property (nonatomic , strong) NSDictionary *user;

@property (nonatomic , strong) NSDictionary *refereeUser;


@end
