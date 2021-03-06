//
//  PictureLibraryView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PictureLibraryView.h"

//Category
#import "NSString+Date.h"

@interface PictureLibraryView()

//背景
@property (nonatomic, strong) UIView *bgView;
//确认按钮
@property (nonatomic, strong) UIButton *confirmBtn;
//当前选择
@property (nonatomic, strong) NSIndexPath *currentSelect;

@end

@implementation PictureLibraryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
        
    }
    return self;
}

#pragma mark - Init

- (void)initSubviews {
    
    //背景

    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor
                                               alpha:0.6];
    
    CGFloat bgW = kScreenWidth - 2*kWidth(35);

    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.bgView.frame = CGRectMake(0, 0, bgW, 100);
    self.bgView.backgroundColor = kWhiteColor;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];

    //选择头像
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kThemeColor
                                                    font:16.0];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.text = @"请选择头像";
    textLbl.frame = CGRectMake(0, 35, 200, 16);
    textLbl.centerX = self.bgView.width/2.0;

    [self.bgView addSubview:textLbl];
    
    //头像库
    [self initCollectionView];
    //确定
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定"
                                          titleColor:kWhiteColor
                                     backgroundColor:kThemeColor
                                           titleFont:14.0
                                        cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:confirmBtn];

    self.confirmBtn = confirmBtn;

}

- (void)initCollectionView {
    
    BaseWeakSelf;
    
    //布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //
    CGFloat itemWidth = kWidth(60);
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.minimumLineSpacing = kWidth(25);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[PictureLibraryCollectionView alloc] initWithFrame:CGRectMake(kWidth(35), kWidth(72), _bgView.width - kWidth(70), kWidth(240)) collectionViewLayout:flowLayout];
    
    self.collectionView.photoBlock = ^(NSIndexPath *indexPath) {
        
        weakSelf.currentSelect = indexPath;
    };
    
    [self.bgView addSubview:self.collectionView];
    
}

#pragma mark - Setting
- (void)setPhotos:(NSArray<PictureModel *> *)photos {
    
    _photos = photos;
    
    self.collectionView.photos = photos;

    [self.collectionView reloadData];
    //设置frame
    CGFloat bgW = kScreenWidth - 2*kWidth(35);
    CGFloat h = photos.count <= 9 ? ((photos.count-1)/3+1)*kWidth(80): kWidth(240);
    
    self.collectionView.height = h;
    
    self.confirmBtn.frame = CGRectMake((bgW - kWidth(250))/2.0, self.collectionView.yy + 40, kWidth(250), 35);

    self.bgView.frame = CGRectMake(0, 0, bgW, self.confirmBtn.yy + kWidth(20));
    
    self.bgView.center = self.center;
}

#pragma mark - Events
- (void)confirm {
    
    [self hide];
    
    if (_pictureBlock) {
        
        _pictureBlock(_currentSelect);
    }
}

- (void)cancel {
    
    [self hide];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

@end
