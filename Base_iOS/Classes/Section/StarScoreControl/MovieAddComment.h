//
//  MovieAddComment.h
//  qukan43
//
//  Created by yang on 15/12/3.
//  Copyright © 2015年 ReNew. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectStarBlock)(NSInteger count);

@interface MovieAddComment : UIView

@property (strong,nonatomic) UIView *v_addcomment;

@property (strong,nonatomic) UIView *v_star;
@property (strong,nonatomic) UIView *v_count;

@property (strong,nonatomic) UIImageView *img_star1;
@property (strong,nonatomic) UIImageView *img_star2;
@property (strong,nonatomic) UIImageView *img_star3;
@property (strong,nonatomic) UIImageView *img_star4;
@property (strong,nonatomic) UIImageView *img_star5;

@property (nonatomic, strong) NSArray *imageViewArray;

@property NSInteger count;

@property BOOL canAddStar;

@property (nonatomic, copy) SelectStarBlock starBlock;

- (instancetype)init;
- (void)cleamCount;

//设置选择的星星数

- (void)setSelectedStarNum:(NSInteger)starNum;

@end
