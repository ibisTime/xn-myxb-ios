//
//  WithdrawalCell.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WithdrawalCell.h"
#import "UILabel+Extension.h"
#import "NSString+Date.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"


@interface WithdrawalCell ()

@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UILabel *timeLabel;
@property (nonatomic , strong)UILabel *moneyLabel;
@end

@implementation WithdrawalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews
{
    self.nameLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
    
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.height.equalTo(@18.0);
        make.top.equalTo(@10);
        
    }];
    
    self.timeLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.height.equalTo(@14.0);
        make.bottom.equalTo(@10);
        
    }];
    
    self.moneyLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
    
    self.moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@15);
        make.height.equalTo(@18.0);
        make.top.equalTo(@10);
        
    }];
    
}
- (void)setModel:(IntregalRecordModel *)model
{
    _model = model;
    self.nameLabel.text = model.realName;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
