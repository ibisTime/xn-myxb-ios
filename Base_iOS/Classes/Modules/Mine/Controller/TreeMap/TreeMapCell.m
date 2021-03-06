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

@interface TreeMapCell ()

@property (nonatomic , strong)UIButton *rightImageBtn;
@end

@implementation TreeMapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLable];
        [self addSubview:self.peoleoLabel];
        [self addSubview:self.lineview];
        [self addSubview:self.rightImageBtn];

        
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageView.mas_right).with.offset(10);
            make.top.bottom.right.equalTo(@0);
        }];
        
        [self.peoleoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.right.equalTo(self.mas_right).with.offset(-50);
            make.height.equalTo(@50);
        }];
        
        [self.rightImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(@0);
            make.width.equalTo(@50);
        }];
        
        [self.rightImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(@0);
            make.width.equalTo(@50);
        }];
    }
    return self;
}

- (void)setModel:(TreeMacModel *)model
{
    _model = model;
    
    self.nameLable.text = model.realName;
    self.lineview.frame = CGRectMake(model.depth * 15 + 15, 49.5, kScreenWidth - model.depth * 15 - 15, .5);
    if (model.ShowLinview) {
        
        self.headerImageView.clipsToBounds = NO;
        self.headerImageView.layer.cornerRadius = 0;
        self.headerImageView.image = nil;

        self.headerImageView.frame = CGRectMake(model.depth * 15 + 15, 16, 5, 18);
        self.headerImageView.backgroundColor = kThemeColor;
        switch (model.depth) {
            case 0:
            {
                [self.rightImageBtn setImage:kImage(@"051-下拉箭头") forState:UIControlStateNormal];
            }
                break;
            case 2 :
            {
                [self.rightImageBtn setImage:kImage(@"下拉-圆") forState:UIControlStateNormal];
            }
                break;
            case 4 :
            {
                [self.rightImageBtn setImage:kImage(@"下拉-圆") forState:UIControlStateNormal];
            }
                break;
                
            default:
            {
                [self.rightImageBtn setImage:nil forState:UIControlStateNormal];

            }
                break;
        
        }

    }
    else
    {
        self.headerImageView.clipsToBounds = YES;

        self.headerImageView.frame = CGRectMake(model.depth * 15 + 15, 5, 40, 40);

        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[model.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        self.headerImageView.layer.cornerRadius = CGRectGetHeight(self.headerImageView.frame) / 2;
        [self.rightImageBtn setImage:nil forState:UIControlStateNormal];

    }
    
   
    
   
    
    
    
    
    if ([model.realName isEqualToString:@"有效推荐码"]) {
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
        _headerImageView.backgroundColor = kThemeColor;
        
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
- (UIButton *)rightImageBtn
{
    if (!_rightImageBtn) {
        _rightImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rightImageBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
