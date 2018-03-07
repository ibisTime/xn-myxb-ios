//
//  MovieAddComment.m
//  qukan43
//
//  Created by yang on 15/12/3.
//  Copyright © 2015年 ReNew. All rights reserved.
//

#import "MovieAddComment.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "TLUser.h"

#define kStarNum 5

@implementation MovieAddComment

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initSubviews];
        
        _imageViewArray = @[self.img_star1, self.img_star2, self.img_star3, self.img_star4, self.img_star5];
        
        //        self.v_addcomment = [array objectAtIndex:0];
        
        [self cleamCount];
        [self addSubview:self.v_addcomment];
        
        self.count = -1;
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.v_star = [[UIView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.v_star];
    [self.v_star mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        
    }];
    
    for (int i = 0; i < kStarNum; i++) {
        
        CGFloat x = 5+i*26;
        CGFloat w = 15;
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:kImage(@"big_star_unselect")];
        
        [self.v_star addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.width.height.equalTo(@(w));
            make.centerY.equalTo(@0);
        }];
        
        if (i == 0) {
            
            self.img_star1 = iv;
            
        } else if (i == 1) {
            
            self.img_star2 = iv;
            
        }else if (i == 2) {
            
            self.img_star3 = iv;
            
        }else if (i == 3) {
            
            self.img_star4 = iv;
            
        }else if (i == 4) {
            
            self.img_star5 = iv;
            
        }
    };
    
}

- (void)cleamCount {
    
    self.count = -1;
    
    [self.img_star1 setImage:[UIImage imageNamed:@"big_star_unselect"]];
    [self.img_star2 setImage:[UIImage imageNamed:@"big_star_unselect"]];
    [self.img_star3 setImage:[UIImage imageNamed:@"big_star_unselect"]];
    [self.img_star4 setImage:[UIImage imageNamed:@"big_star_unselect"]];
    [self.img_star5 setImage:[UIImage imageNamed:@"big_star_unselect"]];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.v_star];
    
    self.canAddStar = YES;
    self.canRequest = NO;
    
    [self changeStarForegroundViewWithPoint:point];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.canAddStar) {
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.v_star];
        
        [self changeStarForegroundViewWithPoint:point];
    }
    
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.canAddStar) {
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.v_star];
        
        self.canRequest = YES;
        
        [self changeStarForegroundViewWithPoint:point];
    }
    
    self.canAddStar = NO;
    
    return;
}


- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    
    if (![[TLUser user] isLogin]) {
        
        if (_starBlock && self.canRequest) {
            
            _starBlock(self.count);
        }
        return ;
    }
    
    NSInteger count = 0;
    
    count = count + [self changeImg:point.x image:self.img_star1];
    count = count + [self changeImg:point.x image:self.img_star2];
    count = count + [self changeImg:point.x image:self.img_star3];
    count = count + [self changeImg:point.x image:self.img_star4];
    count = count + [self changeImg:point.x image:self.img_star5];
    
    if(count == 0) {
        
        count = 1;
        [self.img_star1 setImage:[UIImage imageNamed:@"big_star_select"]];
    }
    
    self.count = count;
    
    if (_starBlock && self.canRequest) {
        
        _starBlock(self.count);
    }
}

- (NSInteger)changeImg:(float)x image:(UIImageView*)img {
    
    if(x >= img.frame.origin.x ) {
        
        NSLog(@"%f",img.frame.origin.x);
        [img setImage:[UIImage imageNamed:@"big_star_select"]];
        
        return 1;
        //        [self setImageAnimation:img];
    }else {
        
        [img setImage:[UIImage imageNamed:@"big_star_unselect"]];
        
        return 0;
    }
}

- (void)setImageAnimation:(UIView *)v {
    
    CGRect rec = v.frame;
    
    [UIView animateWithDuration:0.1 animations:^ {
        
        v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y -3, v.frame.size.width, v.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^ {
            
            v.frame = rec;
            
        } completion:^(BOOL finished) {
            
            v.frame = rec;
        }];
    }];
}

- (void)setSelectedStarNum:(NSInteger)starNum {
    
    for (int i = 0; i < starNum; i++) {
        
        UIImageView *imageView = _imageViewArray[i];
        [imageView setImage:[UIImage imageNamed:@"big_star_select"]];
    }
}

@end
