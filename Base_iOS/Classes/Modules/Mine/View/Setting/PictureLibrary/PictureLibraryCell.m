//
//  PictureLibraryCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PictureLibraryCell.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Extension
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"

@interface PictureLibraryCell()

//头像
@property (nonatomic, strong) UIImageView *photoIV;

@end

@implementation PictureLibraryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat imgW = 60;
    
    self.photoIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgW)];
    
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.photoIV.clipsToBounds = YES;
    self.photoIV.layer.cornerRadius = imgW/2.0;
    self.photoIV.layer.borderWidth = 1;
    
    [self addSubview:self.photoIV];

}

#pragma mark - Setting
- (void)setPictureModel:(PictureModel *)pictureModel {
    
    _pictureModel = pictureModel;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[pictureModel.url convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];

    self.photoIV.layer.borderColor = pictureModel.isSelected ? kThemeColor.CGColor: kLineColor.CGColor;

}
@end
