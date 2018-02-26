//
//  IntregalTaskCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntregalTaskCell.h"

#define kLeftX 15

@interface IntregalTaskCell ()

@property (nonatomic, strong) UILabel *taskNameLabel;   //任务名

@property (nonatomic, strong) UILabel *intregalNumLabel;//任务积分数

@end

@implementation IntregalTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init

- (void)initSubviews {
    
    self.taskNameLabel = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor
                                                      font:15.0];
    
    [self.contentView addSubview:self.taskNameLabel];
    [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_lessThanOrEqualTo(16);
        
    }];
    
    CGFloat btnH = 25;
    
    self.comfirmBtn = [UIButton buttonWithTitle:@"赚积分" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:13.0 cornerRadius:btnH/2.0];
    
    self.comfirmBtn.layer.borderWidth = 1;
    self.comfirmBtn.layer.borderColor = kAppCustomMainColor.CGColor;
    
    [self.comfirmBtn setTitleColor:kTextColor2 forState:UIControlStateSelected];
    
    [self.contentView addSubview:self.comfirmBtn];
    [self.comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.width.equalTo(@55);
        make.height.equalTo(@(btnH));
        make.centerY.equalTo(@0);
        
    }];
    
    self.intregalNumLabel = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor
                                                         font:12.0];
    
    self.intregalNumLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.intregalNumLabel];
    [self.intregalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.comfirmBtn.mas_left).offset(-kLeftX);
        make.centerY.equalTo(@0);
        make.height.lessThanOrEqualTo(@14.0);
        make.width.lessThanOrEqualTo(@200);
        
    }];
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kPaleGreyColor;
    
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)setTask:(IntregalTaskModel *)task {

    _task = task;
    
    self.taskNameLabel.text = _task.note;
    
    NSString *text = _task.isFirst ? _task.value: [NSString stringWithFormat:@"+%@分", _task.cvalue];
    
    self.intregalNumLabel.text = text;
}

@end
