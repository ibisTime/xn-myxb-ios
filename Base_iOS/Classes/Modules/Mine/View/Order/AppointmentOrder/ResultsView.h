//
//  ResultsView.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/6.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
#import "AppointmentOrderModel.h"
@interface ResultsView : BaseView

- (instancetype)initWithFrame:(CGRect)frame withOrder:(AppointmentOrderModel *)order;

@end
