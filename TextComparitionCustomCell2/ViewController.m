//
//  ViewController.m
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/09/30.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import "ViewController.h"
#import "CustomCellTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableVIew.dataSource=self;
    self.myTableVIew.delegate=self;
    _textExplanation=@[@"あ",@"ああ",@"あああ"];
   
    //楽天のAPI
    NSURL *rakuMyURL =[NSURL URLWithString:@"https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json&keyword=c%E8%A8%80%E8%AA%9E&affiliateId=145ec597.8c7b7ba8.145ec598.8682c646&sort=%2BitemPrice&page=1&hits=15&applicationId=1063216542896291664"];
    
    NSURLRequest *rakuMyURLReq=[NSURLRequest requestWithURL:rakuMyURL];
    
    NSData *rakuJson_data=[NSURLConnection sendSynchronousRequest:rakuMyURLReq returningResponse:nil error:nil];
    NSError *rakuerror=nil;
    NSDictionary *rakujsonObject=[NSJSONSerialization JSONObjectWithData:rakuJson_data options:NSJSONReadingAllowFragments  error:&rakuerror];
    
    
    
    //カスタムセルを設定
    UINib *nib=[UINib nibWithNibName:@"CustomCellView" bundle:nil];
    
    //テーブルにカスタムセルを設置
    [self.myTableVIew registerNib:nib forCellReuseIdentifier:@"Cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _textExplanation.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*CellIdentifier=@"Cell";
    CustomCellTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",_textExplanation[indexPath.row]];
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
