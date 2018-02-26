//
//  TripInfoModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface TripInfoModel : BaseModel
//开始时间
@property (nonatomic, copy) NSString *startDatetime;
//结束时间
@property (nonatomic, copy) NSString *endDatetime;
//备注
@property (nonatomic, copy) NSString *remark;

@end
