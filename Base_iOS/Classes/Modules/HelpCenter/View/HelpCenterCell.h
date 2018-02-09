//
//  HelpCenterCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionModel.h"

@interface HelpCenterCell : UITableViewCell
//image
@property (nonatomic, strong) UIImageView *iconIV;
//arrow
@property (nonatomic, strong) UIImageView *arrowIV;
//line
@property (nonatomic, strong) UIView *line;
//
@property (nonatomic, strong) QuestionModel *question;

@end
