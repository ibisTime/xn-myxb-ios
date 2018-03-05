//
//  ProposalHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
//M
#import "ProposalInfoModel.h"
//V
#import "MovieAddComment.h"

@interface ProposalHeaderView : UIView
//星星
@property (nonatomic, strong) MovieAddComment *starView;
//
@property (nonatomic, strong) ProposalInfoModel *info;

@end
