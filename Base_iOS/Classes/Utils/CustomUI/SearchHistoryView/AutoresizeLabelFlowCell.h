//
//  AutoresizeLabelFlowCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoresizeLabelModel.h"

@interface AutoresizeLabelFlowCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;
//
@property (nonatomic, strong) AutoresizeLabelModel *model;

@end
