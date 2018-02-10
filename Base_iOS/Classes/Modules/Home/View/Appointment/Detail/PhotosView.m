//
//  PhotosView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "PhotosView.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
//Extension
#import <PYPhotoBrowseView.h>
//M
//V
//C

@implementation PhotosView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (void)setPics:(NSArray *)pics {
    
    _pics = pics;
    //添加图片
    [self addPhoto];
}

- (void)addPhoto {
    
    NSInteger count = _pics.count;
    
    __block CGFloat photoH = 0;
    
    [_pics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj]]];
        
        CGFloat fixelW = CGImageGetWidth(image.CGImage);
        CGFloat fixelH = CGImageGetHeight(image.CGImage);
        CGFloat imgW = (kScreenWidth - 2*15 - 10)/2.0;
        //通过图片的宽高比得到视图展示的高度
        CGFloat height = fixelH*(kScreenWidth - 2*15)/fixelW;
        
        UIImageView *photoIV = [[UIImageView alloc] init];
        
        photoIV.tag = 1500 + idx;
        photoIV.userInteractionEnabled = YES;
        
        NSInteger baseNum = 3;
        
        if (count <= baseNum + 1) {
            
            photoIV.frame = CGRectMake(15, photoH, kScreenWidth - 2*15, height);
            photoH = photoIV.yy + 10;
            
        } else  {
            
            if (count%2 == 1) {
                
                if (idx < baseNum) {
                    
                    photoIV.frame = CGRectMake(15, photoH, kScreenWidth - 2*15, height);
                    photoH = photoIV.yy + 10;
                    
                } else {
                    
                    photoIV.frame = CGRectMake(15 + ((idx - baseNum)%2)*(imgW + 10), photoH, imgW, imgW);
                    photoH = (idx - baseNum)%2 == 0 ? photoH: photoIV.yy + 10;
                    
                    if (fixelW > fixelH) {
                        
                        photoIV.layer.masksToBounds = YES;
                        photoIV.contentMode = UIViewContentModeScaleAspectFill;
                        
                    } else if (fixelW < fixelH) {
                        
                        photoIV.layer.masksToBounds = YES;
                        photoIV.contentMode = UIViewContentModeScaleAspectFit;
                        photoIV.layer.contentsRect = CGRectMake(0, 0,1, fixelW/fixelH);
                        photoIV.contentMode = UIViewContentModeScaleToFill;
                    }
                }
                
            } else {
                
                if (idx < baseNum + 1) {
                    
                    photoIV.frame = CGRectMake(15, photoH, kScreenWidth - 2*15, height);
                    photoH = photoIV.yy + 10;
                    
                } else {
                    
                    photoIV.frame = CGRectMake(15 + ((idx - baseNum - 1)%2)*(imgW + 10), photoH, imgW, imgW);
                    photoH = (idx - baseNum - 1)%2 == 0 ? photoH: photoIV.yy + 10;
                    
                    if (fixelW > fixelH) {
                        
                        photoIV.layer.masksToBounds = YES;
                        photoIV.contentMode = UIViewContentModeScaleAspectFill;
                        
                    } else if (fixelW < fixelH) {
                        
                        photoIV.layer.masksToBounds = YES;
                        photoIV.contentMode = UIViewContentModeScaleAspectFit;
                        photoIV.layer.contentsRect = CGRectMake(0, 0, 1, fixelW/fixelH);
                        photoIV.contentMode = UIViewContentModeScaleToFill;
                        
                    }
                }
            }
        }
        
        photoIV.image = image;
        
        [self addSubview:photoIV];
        //添加点击手势
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhoto:)];
        
        [photoIV addGestureRecognizer:tapGR];
        
    }];
    
    self.photoH = photoH;
}

#pragma mark - Events
- (void)clickPhoto:(UITapGestureRecognizer *)tapGR {
    
    NSInteger index = tapGR.view.tag - 1500;
    
//    创建图片浏览器
    PYPhotoBrowseView *photoBrowseView = [[PYPhotoBrowseView alloc] init];
    
    //frameFormWindow
    photoBrowseView.frameFormWindow = CGRectMake(kScreenWidth/2.0, kScreenHeight/2.0, 0, 0);
    //frameToWindow
    photoBrowseView.frameToWindow = CGRectMake(kScreenWidth/2.0, kScreenHeight/2.0, 0, 0);
    photoBrowseView.imagesURL = _pics;
    //        photoBroseView.sourceImgageViews = [self.imageViewArr copy];
    photoBrowseView.currentIndex = index;
    
    [photoBrowseView show];
}

@end
