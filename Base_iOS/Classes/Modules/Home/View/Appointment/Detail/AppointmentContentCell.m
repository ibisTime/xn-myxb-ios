//
//  AppointmentContentCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentContentCell.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
#import "UIButton+EnLargeEdge.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Extension.h"
//Extension
#import "MLLinkLabel.h"
#import "PYPhotosView.h"
#import <PYPhotoView.h>
#import <UIView+PYExtension.h>
#import <PYProgressView.h>
//M
//V
#import "PhotosView.h"
#import "LinkLabel.h"

@interface AppointmentContentCell()
//文字
@property (nonatomic, strong) UILabel *contentLbl;
//展开/收起
@property (nonatomic, strong) UIButton *showBtn;
//图片
@property (nonatomic, strong) PhotosView *photosView;
//右箭头
@property (nonatomic, strong) UIImageView *arrowIV;
//介绍
@property (nonatomic, copy) NSString *introduce;

@end

@implementation AppointmentContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    //内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:14.0];
    
    self.contentLbl.numberOfLines = 5;
    self.contentLbl.backgroundColor = [UIColor whiteColor];
    self.contentLbl.width = kScreenWidth - 30;
    
    [self addSubview:self.contentLbl];
    
    self.showBtn = [UIButton buttonWithTitle:@"展开"
                                  titleColor:kTextColor2
                             backgroundColor:kClearColor
                                   titleFont:13.0];
    
    [self.showBtn setImage:kImage(@"下拉") forState:UIControlStateNormal];
    [self.showBtn setTitle:@"收起" forState:UIControlStateSelected];
    [self.showBtn setImage:kImage(@"上拉") forState:UIControlStateSelected];

    [self.showBtn addTarget:self action:@selector(showTitleContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.showBtn setEnlargeEdge:20];
    
    [self addSubview:self.showBtn];
    
    //添加图片
    PhotosView *photosView = [[PhotosView alloc] init];
    
    photosView.backgroundColor = kWhiteColor;
    
    [self addSubview:photosView];
    self.photosView = photosView;
    
}

- (void)setSubviewLayout {
    
    CGFloat margin = 15;

    //个人简介
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(margin));
        make.height.lessThanOrEqualTo(@(MAXFLOAT));
        make.width.equalTo(@(kScreenWidth - 2*margin));
    }];
    //展示按钮
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLbl.mas_bottom);
        make.centerX.equalTo(@0);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    [self.showBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_showBtn.imageView.width - 20, 0, 0)];
    [self.showBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_showBtn.titleLabel.intrinsicContentSize.width - 20)];
    //图片
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(@0);
        make.height.mas_equalTo(self.photosView.photoH);
        make.width.equalTo(@(kScreenWidth));
        
        if (!_showBtn.hidden) {
            
            make.top.equalTo(self.showBtn.mas_bottom).offset(0);
            
        } else {
            
            make.top.equalTo(self.contentLbl.mas_bottom).offset(10);
        }

        
    }];
    
}

#pragma mark - Events

- (void)showTitleContent:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    _contentLbl.numberOfLines = sender.selected ? 0: 5;

    [_contentLbl labelWithTextString:self.introduce lineSpace:5];

    if ([self.delegate respondsToSelector:@selector(didSelectActionWithType:index:)]) {
        
        [self.delegate didSelectActionWithType:AppointmentTypeShowTitle index:0];
    }
}

- (void)clickHeadIcon:(UITapGestureRecognizer *)tapGR {
    
    NSInteger index = (tapGR.view.tag - 5000)/10;
    
    if ([self.delegate respondsToSelector:@selector(didSelectActionWithType:index:)]) {
        
        [self.delegate didSelectActionWithType:AppointmentTypeLookAllComment index:index];
    }
}

#pragma mark - Setting

- (void)setDetailModel:(AppointmentDetailModel *)detailModel {
    
    _detailModel = detailModel;
    
    _introduce = detailModel.introduce;
    
    //_layoutItem.good.desc
    [_contentLbl labelWithTextString:detailModel.introduce lineSpace:5];
    
    //判断是否超出5行
    NSInteger lineCount = [_contentLbl getLinesArrayOfStringInLabel];
    
    _showBtn.hidden = lineCount > 5 ? NO: YES;
    //
    [self setSubviewLayout];
    //
    [self layoutSubviews];
    //cell高度
    detailModel.contentHeight = self.photosView.yy + 15;
    
}

- (void)setBrandModel:(BrandModel *)brandModel {
    
    _brandModel = brandModel;
    
    _introduce = brandModel.introduce;

    //_layoutItem.good.desc
    [_contentLbl labelWithTextString:brandModel.introduce lineSpace:5];
    //照片
    self.photosView.pics = @[@"https://www.baidu.com/img/bd_logo1.png"];
    
    //判断是否超出5行
    NSInteger lineCount = [_contentLbl getLinesArrayOfStringInLabel];
    
    _showBtn.hidden = lineCount > 5 ? NO: YES;
    //
    [self setSubviewLayout];
    //
    [self layoutSubviews];
    //cell高度
    brandModel.contentHeight = self.photosView.yy + 15;
}

@end
