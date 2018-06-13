//
//  TreeMapCell.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TreeMapCell.h"
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"

@implementation TreeMapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLable];
        [self addSubview:self.peoleoLabel];
        [self addSubview:self.lineview];

        
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageView.mas_right).with.offset(10);
            make.top.bottom.right.equalTo(@0);
        }];
        
        [self.peoleoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.right.equalTo(self.mas_right).with.offset(-20);
            make.height.equalTo(@50);
        }];
    }
    return self;
}

- (void)setModel:(TreeMacModel *)model
{
    _model = model;
    
    self.headerImageView.clipsToBounds = YES;
    self.nameLable.text = model.realName;
    self.lineview.frame = CGRectMake(model.depth * 15 + 15, 49.5, kScreenWidth - model.depth * 15 - 15, .5);
    if (model.ShowLinview) {
        
        self.headerImageView.frame = CGRectMake(model.depth * 15 + 15, 16, 5, 18);
        self.headerImageView.backgroundColor = kThemeColor;

    }
    else
    {
        self.headerImageView.frame = CGRectMake(model.depth * 15 + 15, 5, 40, 40);

        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[model.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        self.headerImageView.layer.cornerRadius = CGRectGetHeight(self.headerImageView.frame) / 2;

    }
    
    if (model.peopleNumberl != 0) {
        self.peoleoLabel.text = [NSString stringWithFormat:@"%ld人",model.peopleNumberl];
    }
    else
    {
        self.peoleoLabel.text = @"";
    }
    
    
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        
    }
    return _headerImageView;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
        _nameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLable;
}
- (UILabel *)peoleoLabel
{
    if (!_peoleoLabel) {
        _peoleoLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:16];
        _peoleoLabel.textAlignment = NSTextAlignmentRight;
    }
    return _peoleoLabel;
}
- (UIView *)lineview
{
    if (!_lineview) {
        _lineview = [[UIView alloc]init];
        _lineview.backgroundColor = kSilverGreyColor;
    }
    return _lineview;
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
