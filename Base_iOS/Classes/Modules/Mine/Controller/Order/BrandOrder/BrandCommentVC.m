//
//  BrandCommentVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandCommentVC.h"
//Category
#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"
//M
#import "KeyValueModel.h"
//V
#import "TLTextView.h"
#import "MovieAddComment.h"

@interface BrandCommentVC ()
//
@property (nonatomic, strong) BaseView *topView;
//评论
@property (nonatomic, strong) TLTextView *commentTV;
//使用效果
@property (nonatomic, strong) MovieAddComment *effectCommentView;
//物流服务
@property (nonatomic, strong) MovieAddComment *serviceCommentView;
//
@property (nonatomic, strong) NSArray <KeyValueModel *>*models;
//
@property (nonatomic, strong) NSMutableArray <MovieAddComment *>*starViews;

@end

@implementation BrandCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提交评论";
    //取评分的系统参数
    [self requestScoreKeyValue];
    //发布
    [self addItem];
}

#pragma mark - Init
- (void)initTopView {
    
    self.starViews = [NSMutableArray array];
    
    self.topView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.models.count*38 + 25)];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.topView];
    
    [self.models enumerateObjectsUsingBlock:^(KeyValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        KeyValueModel *model = self.models[idx];
        //使用效果
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor2
                                                          font:15.0];
        
        textLbl.frame = CGRectMake(15, 25 + idx*38, 70, kFontHeight(15.0));
        
        textLbl.text = model.cvalue;
        [self.topView addSubview:textLbl];
        //
        MovieAddComment *commentView = [[MovieAddComment alloc] init];
        
        commentView.frame = CGRectMake(textLbl.xx + 15, 0, 130, 40);
        
        commentView.centerY = textLbl.centerY;
        
        [self.topView addSubview:commentView];
        
        [self.starViews addObject:commentView];
    }];
    
}

- (void)initCommentView {
    
    //评论
    self.commentTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, self.topView.yy + 10, kScreenWidth, 180)];
    
    self.commentTV.placeholderLbl.origin = CGPointMake(15, 15);
    self.commentTV.placeholderLbl.font = Font(13.0);
    self.commentTV.textContainerInset = UIEdgeInsetsMake(17, 10, 0, 0);
    self.commentTV.placholder = @"宝贝满足你的期待吗? 说是它的优点吧";
    
    [self.view addSubview:self.commentTV];
    
}

- (void)addItem {
    
    [UIBarButtonItem addLeftItemWithImageName:@"cancel"
                                        frame:CGRectMake(0, 0, 44, 44)
                                           vc:self
                                       action:@selector(cancel)];
    
    [UIBarButtonItem addRightItemWithTitle:@"发布"
                                titleColor:kWhiteColor
                                     frame:CGRectMake(0, 0, 50, 44)
                                        vc:self
                                    action:@selector(comment)];
}

#pragma mark - Events

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)comment {
    
    __block BOOL isStop = NO;
    __block KeyValueModel *model;
    
    [self.starViews enumerateObjectsUsingBlock:^(MovieAddComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        model = self.models[idx];
        
        if (obj.count == -1) {
            
            *stop = YES;
            
            isStop = YES;
        }
    }];
    
    if (isStop) {
        
        [TLAlert alertWithInfo:[NSString stringWithFormat:@"请对%@", model.cvalue]];
        return ;
    }
    if (![self.commentTV.text valid]) {
        [TLAlert alertWithInfo:[NSString stringWithFormat:@"请输入评论内容"]];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = @"805420";
    http.parameters[@"commenter"] = [TLUser user].userId;
    http.parameters[@"type"] = @"P";
    http.parameters[@"content"] = self.commentTV.text;
    http.parameters[@"orderCode"] = self.code;
    NSMutableArray *reqArr = [NSMutableArray array];
    
    [self.models enumerateObjectsUsingBlock:^(KeyValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MovieAddComment *commentView = self.starViews[idx];
        
        NSDictionary *dic = @{
                              @"ckey" : obj.ckey,
                              @"score": [NSString stringWithFormat:@"%ld", commentView.count],
                              };
        
        [reqArr addObject:dic];
    }];
    
    http.parameters[@"req"] = reqArr.copy;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *code = responseObject[@"data"][@"code"];
        
        if ([code containsString:@"filter"]) {
            
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"评论成功, 您的评论包含敏感字符,我们将进行审核"]];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            return ;
        }
        
        [self.view endEditing:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCommentList" object:nil];
        
        [TLAlert alertWithSucces:[NSString stringWithFormat:@"%@成功", self.titleStr]];
        
        if (self.commentSuccess) {
            
            self.commentSuccess();
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Data
- (void)requestScoreKeyValue {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805914";
    http.parameters[@"type"] = @"ISW";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.models = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //
        [self initTopView];
        //
        [self initCommentView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
