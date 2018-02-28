//
//  AutoresizeLabelFlowCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AutoresizeLabelFlowCell.h"
#import "AutoresizeLabelFlowConfig.h"
#define JKColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface AutoresizeLabelFlowCell()

@end

@implementation AutoresizeLabelFlowCell

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [AutoresizeLabelFlowConfig shareConfig].itemColor;
        _titleLabel.textColor = [AutoresizeLabelFlowConfig shareConfig].textColor;
        _titleLabel.font = [AutoresizeLabelFlowConfig shareConfig].textFont;
        _titleLabel.layer.cornerRadius = [AutoresizeLabelFlowConfig shareConfig].itemCornerRadius;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderColor = JKColor(220, 220, 220, 1.0).CGColor;
        _titleLabel.layer.borderWidth = 0.5;
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(AutoresizeLabelModel *)model {
    
    _model = model;
    self.titleLabel.frame = self.bounds;
    self.titleLabel.text = model.title;
    self.titleLabel.backgroundColor = model.isSelected ? [AutoresizeLabelFlowConfig shareConfig].itemSelectBgColor: [AutoresizeLabelFlowConfig shareConfig].itemColor;
    self.titleLabel.textColor = model.isSelected ? [AutoresizeLabelFlowConfig shareConfig].textSelectColor: [AutoresizeLabelFlowConfig shareConfig].textColor;

}

@end
