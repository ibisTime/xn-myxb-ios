//
//  NoticeModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

#import <UIKit/UIKit.h>

@interface NoticeModel : BaseModel

@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *fromSystemCode;
@property (nonatomic, copy) NSString *pushType;
@property (nonatomic, copy) NSString *pushedDatetime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *smsContent;
@property (nonatomic, copy) NSString *smsTitle;
@property (nonatomic, copy) NSString *smsType;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *toKind;
@property (nonatomic, copy) NSString *toSystemCode;

@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, assign) CGFloat cellHeight;

@end
