//
//  NoticeCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NoticeCell.h"

#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "NSString+Date.h"
#import "NSAttributedString+add.h"

@interface NoticeCell ()

@property (nonatomic,strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation NoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = kClearColor;
        
        CGFloat x = 15;
        CGFloat w = kScreenWidth - 2*x;
        CGFloat topH = 45;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, 125)];
        
        bgView.backgroundColor = kWhiteColor;
        bgView.layer.cornerRadius = 10;
        bgView.clipsToBounds = YES;
        
        [self.contentView addSubview:bgView];
        
        self.bgView = bgView;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, topH)];
        
        topView.backgroundColor = kAppCustomMainColor;
        [bgView addSubview:topView];
        //标题
        self.titleLabel = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kWhiteColor
                                                       font:15.0];
        
        self.titleLabel.backgroundColor = kClearColor;
        
        [topView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.centerY.equalTo(@0);
            make.right.equalTo(@(-x));
            make.height.equalTo(@20);
            
        }];
        
        self.contentLabel = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor
                                                         font:15.0];
        
        self.contentLabel.numberOfLines = 0;
        
        [bgView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.top.equalTo(self.mas_top).offset(topH + 10);
            make.right.equalTo(@(-x));
        }];
        
        self.bottomView = [[UIView alloc] init];
        
        [bgView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
            make.width.equalTo(@(w));
            make.left.equalTo(@0);
            make.height.equalTo(@(40));
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, kLineHeight)];
        
        lineView.backgroundColor = kLineColor;
        
        [self.bottomView addSubview:lineView];
        
        self.timeLabel = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:13.0];
        
        self.timeLabel.frame = CGRectMake(x, 0, self.bottomView.width - 2*x, 15.0);
        
        self.timeLabel.centerY = self.bottomView.height/2.0;
        
        [self.bottomView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.centerY.equalTo(@0);
            make.height.equalTo(@15);
        }];
        
    }
    return self;
    
}

- (void)setNotice:(NoticeModel *)notice {
    
    _notice = notice;
    
    self.titleLabel.text = _notice.smsTitle;
    
    self.contentLabel.text = _notice.smsContent;
    
    NSString *date = [_notice.pushedDatetime convertToDetailDate];
    
    NSAttributedString *timeAttr = [NSAttributedString getAttributedStringWithImgStr:@"消息时间" index:0 string:[NSString stringWithFormat:@"  %@", date] labelHeight:self.timeLabel.height];
    
    self.timeLabel.attributedText = timeAttr;
    
    [self layoutIfNeeded];

    self.bgView.height = self.bottomView.yy;
    
    notice.cellHeight = self.bottomView.yy;
    
}

@end
