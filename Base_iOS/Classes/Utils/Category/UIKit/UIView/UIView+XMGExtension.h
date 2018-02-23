//
//  UIView+XMGExtension.h
//
//  Copyright (c)  . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XMGExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic , assign) CGFloat centerX;
@property (nonatomic , assign) CGFloat centerY;

/**白色label*/
- (UIView*)itemTitleView:(NSString *)title;

/** 终点x */
@property (nonatomic, assign) CGFloat xx;
/** 终点y */  //set为起点不变 增加高度
@property (nonatomic, assign) CGFloat yy;

/** 终点y */  //set为改变起点，size不变
@property (nonatomic, assign) CGFloat yy_size;

/** 终点y */  //set为改变起点，size不变
@property (nonatomic, assign) CGFloat xx_size;

@end
