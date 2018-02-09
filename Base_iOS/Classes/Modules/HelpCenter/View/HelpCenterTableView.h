//
//  HelpCenterTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"

#import "QuestionModel.h"

@interface HelpCenterTableView : TLTableView

@property (nonatomic, strong) NSArray <QuestionModel *>*questions;

@end
