//
//  AutoresizeLabelModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface AutoresizeLabelModel : BaseModel
//text
@property (nonatomic, copy) NSString *title;
//是否选中
@property (nonatomic, assign) BOOL isSelected;

@end
