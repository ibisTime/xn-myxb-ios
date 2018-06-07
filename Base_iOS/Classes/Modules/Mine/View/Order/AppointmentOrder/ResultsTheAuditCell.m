//
//  ResultsTheAuditCell.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ResultsTheAuditCell.h"
@interface ResultsTheAuditCell ()

@end

@implementation ResultsTheAuditCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textTF];
        UIView *bottomLine = [[UIView alloc] init];
        
        bottomLine.backgroundColor = kLineColor;
        
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
            
        }];
    }
    return self;
}

- (TLTextField *)textTF
{
    if (!_textTF) {
        _textTF = [[TLTextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:@"" rightTitle:@"" titleWidth:120 placeholder:@""];
        _textTF.userInteractionEnabled = NO;
        _textTF.rightLbl.textColor = [UIColor colorWithHexString:@"#484848"];
    }
    return _textTF;
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
