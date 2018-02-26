//
//  SendCommentVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SendCommentVC.h"
//Category
#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"
//V
#import "TLTextView.h"

@interface SendCommentVC ()
//评论
@property (nonatomic, strong) TLTextView *commentTV;

@end

@implementation SendCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提交评论";
    //
    [self initSubviews];
    //发布
    [self addItem];
}

#pragma mark - Init
- (void)initSubviews {
    
    //评论
    self.commentTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    
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
    
    if (![self.commentTV.text valid]) {
        [TLAlert alertWithInfo:[NSString stringWithFormat:@"请输入评论内容"]];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = @"805420";
    http.parameters[@"commenter"] = [TLUser user].userId;
    http.parameters[@"type"] = @"IP";
    http.parameters[@"content"] = self.commentTV.text;
    http.parameters[@"orderCode"] = self.code;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
