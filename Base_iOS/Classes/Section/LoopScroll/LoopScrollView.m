//
//  LoopScrollView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "LoopScrollView.h"

#import <YYText.h>
#import "NSTimer+Loop.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"

@interface LoopScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) YYLabel *currentLabel;
@property (nonatomic, strong) YYLabel *nextLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *leftIconIV;

@end

@implementation LoopScrollView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _timeinterval = 2.0f;
        _textColor = kTextColor;
        _textFont = Font(13.0);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self.scrollView addGestureRecognizer:tap];
    }
    return self;
}

+ (instancetype)loopTitleViewWithFrame:(CGRect)frame titleImgArr:(NSArray *)titleImgArr
{
    LoopScrollView *loopView = [[self alloc] initWithFrame:frame];
    
    loopView.currentLabel = [[YYLabel alloc]init];
    [loopView.scrollView addSubview:loopView.currentLabel];
    
    loopView.nextLabel = [[YYLabel alloc]init];
    [loopView.scrollView addSubview:loopView.nextLabel];
    
    loopView.titleImgArr = titleImgArr;
    
    return loopView;
}

#pragma mark - Lazyload

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)leftIconIV {
    
    if (!_leftIconIV) {
        
        //左边图标
        _leftIconIV = [[UIImageView alloc] init];
        
        [self addSubview:_leftIconIV];
    }
    
    return _leftIconIV;
}

#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //
    _leftIconIV.frame = CGRectMake(10, 0, self.leftImage.size.width, self.leftImage.size.height);
    
    _leftIconIV.centerY = self.centerY;
    
    //滚动内容宽度
    CGFloat lblW = CGRectGetWidth(self.bounds) - (_leftIconIV.xx + 10);
    
    _currentLabel.frame = CGRectMake(_leftIconIV.xx + 10, 0, lblW, CGRectGetHeight(self.bounds));
    
    _nextLabel.frame = CGRectOffset(_currentLabel.frame, 0, CGRectGetHeight(_currentLabel.bounds));
}

#pragma mark - Setting
- (void)setTitlesArr:(NSArray *)titlesArr
{
    _titlesArr = titlesArr;
    
    _currentIndex = 0;
    
    self.scrollView.scrollEnabled = NO;
    
    if (![_timer isValid]) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeinterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        
        [_timer pauseTimer];
    }
    
    if (titlesArr.count <= 1) {
        
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds));
        
    }else{
        
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds)*2);
        
        [self.timer resumeTimerAfterTimeInterval:_timeinterval];
    }
    
    [self refreshCurrentTitleView];
}

- (void)setTitleImgArr:(NSArray *)titleImgArr {
    
    _titleImgArr = titleImgArr;
}

- (void)setLeftImage:(UIImage *)leftImage {
    
    _leftImage = leftImage;
    
    self.leftIconIV.image = leftImage;
}

#pragma mark - Events
- (void)tapClick:(UITapGestureRecognizer *)tapGR {
    
    if (self.loopBlock) {
        
        self.loopBlock();
    }
}
//定时器
- (void)onTimer:(NSTimer *)timer
{
    CGPoint pointMake = CGPointMake(0, CGRectGetHeight(self.bounds));

    [self.scrollView setContentOffset:pointMake animated:YES];
}

- (void)refreshTitleIndex
{
    if (self.scrollView.contentOffset.y >= CGRectGetHeight(self.bounds)*0.5) {
        
        _currentIndex ++;
        
        if (_currentIndex > self.titlesArr.count - 1) {
            
            _currentIndex = 0;
        }
    }
}

- (void)refreshCurrentTitleView
{
    NSInteger index = _currentIndex;
    
    self.currentLabel.attributedText = [self getAttachmentTextWithStr:self.titlesArr[index] image:self.titleImgArr[index]];
    
    index = _currentIndex + 1 >= self.titlesArr.count ? 0: _currentIndex + 1;
    
    self.nextLabel.attributedText = [self getAttachmentTextWithStr:self.titlesArr[index] image:self.titleImgArr[index]];
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //触摸滑动时暂停定时器
    [self.timer pauseTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    [self refreshTitleIndex];
    
    //触摸滚动结束重启定时器
    [self.timer resumeTimerAfterTimeInterval:_timeinterval];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self refreshTitleIndex];
    
    [self refreshCurrentTitleView];

}

#pragma mark private

/**
 带图片头的文字循环
 
 @param labelText label赋值
 @param data 本地图片资源（可置空）
 @return 拼接好的富文本
 */
- (NSMutableAttributedString *)getAttachmentTextWithStr:(NSString *)labelText image:(id)data
{
    UIImage *image;
    
    if ([data isKindOfClass:[UIImage class]]) {
        
        image = (UIImage *)data;
    }else if ([data isKindOfClass:[NSString class]]) {
        
        NSString *imageName = (NSString *)data;
        image = [UIImage imageNamed:imageName];
    }
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:self.textFont alignment:YYTextVerticalAlignmentCenter];
    
    [text appendAttributedString:attachText];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",labelText] attributes:nil]];
    text.yy_font = self.textFont;
    text.yy_color = self.textColor;
    
    return text;
}

@end
