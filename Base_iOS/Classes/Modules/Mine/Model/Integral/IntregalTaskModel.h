//
//  IntregalTaskModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@interface IntregalTaskModel : BaseModel

@property (nonatomic, copy) NSString *cvalue;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *note;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *ckey;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, assign) BOOL isFirst;

@end
