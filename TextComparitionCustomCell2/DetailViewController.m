//
//  DetailViewController.m
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/10/01.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *myURL =[NSURL URLWithString:self.toURL];
    NSURLRequest *myURLReq =[NSURLRequest requestWithURL:myURL];
    [self.myWebView loadRequest:myURLReq];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
