//
//  IntregalRecordCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "IntregalRecordCell.h"
//Category
#import "NSString+Date.h"
#import "NSNumber+Extension.h"

#define kLeftX 15

@interface IntregalRecordCell ()

@property (nonatomic, strong) UILabel *taskNameLabel;   //任务名

@property (nonatomic, strong) UILabel *intregalNumLabel;//任务积分数

@property (nonatomic, strong) UILabel *timeLabel;    //积分获得时间

@end

@implementation IntregalRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init

- (void)initSubviews {
    
    self.intregalNumLabel = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor
                                                         font:12.0];
    
    self.intregalNumLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.intregalNumLabel];
    [self.intregalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-kLeftX));
        make.centerY.equalTo(@0);
        make.height.lessThanOrEqualTo(@14.0);
        make.width.lessThanOrEqualTo(@200);
        
    }];
    
    self.taskNameLabel = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor
                                                      font:15.0];
    
    [self.contentView addSubview:self.taskNameLabel];
    [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.lessThanOrEqualTo(@200);
        make.height.lessThanOrEqualTo(@16);
        
    }];
    
    self.timeLabel = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:14.0];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kLeftX));
        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@250);
        make.height.lessThanOrEqualTo(@14.0);
        
    }];
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kPaleGreyColor;
    
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setTask:(IntregalRecordModel *)task {
    
    _task = task;
    
    self.taskNameLabel.text = _task.bizNote;
    
    self.intregalNumLabel.text = [NSString stringWithFormat:@"%@", [_task.transAmount convertToRealMoney]];
    
    self.timeLabel.text = [_task.createDatetime convertToDetailDate];
}


@end
