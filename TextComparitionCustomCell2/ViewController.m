//
//  ViewController.m
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/09/30.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import "ViewController.h"
#import "CustomCellTableViewCell.h"

@interface ViewController (){
    NSArray *_rakuList;
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableVIew.dataSource=self;
    self.myTableVIew.delegate=self;
    _textExplanation=@[@"あ",@"ああ",@"あああ"];
   
    //楽天のAPI
    NSURL *rakuMyURL =[NSURL URLWithString:@"https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json&keyword=c%E8%A8%80%E8%AA%9E&affiliateId=145ec597.8c7b7ba8.145ec598.8682c646&sort=%2BitemPrice&page=1&hits=15&applicationId=1063216542896291664"];
    
    //c%E8%A8%80%E8%AA%9Eが検索文字の場所今回の場合は「C言語」という単語を16進文字コードに変換している。

    
    NSURLRequest *rakuMyURLReq=[NSURLRequest requestWithURL:rakuMyURL];
    
    //↓onnectionで通信開始。
    NSData *rakuJson_data=[NSURLConnection sendSynchronousRequest:rakuMyURLReq returningResponse:nil error:nil];
    NSError *rakuerror=nil;
    NSDictionary* rakujsonObject=[NSJSONSerialization JSONObjectWithData:rakuJson_data options:NSJSONReadingAllowFragments  error:&rakuerror];
    //&をつけると参照形式になり、その変数は引数にもなり、戻り値にもなる。
    _rakuList=rakujsonObject[@"Items"];
    NSLog(@"%@",_rakuList);
    
    
    
    //カスタムセルを設定
    UINib *nib=[UINib nibWithNibName:@"CustomCellView" bundle:nil];
    
    //テーブルにカスタムセルを設置
    [self.myTableVIew registerNib:nib forCellReuseIdentifier:@"Cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rakuList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*CellIdentifier=@"Cell";
    CustomCellTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //商品名を表示
    cell.textTitleLabel.text=[NSString stringWithFormat:@"%@",_rakuList[indexPath.row][@"Item"][@"itemName"]];
    
    //値段を表示
    cell.priceLabel.text=[NSString stringWithFormat:@"%@円",_rakuList[indexPath.row][@"Item"][@"itemPrice"]];
    
    //imageを表示
    NSArray *myArray= _rakuList[indexPath.row][@"Item"][@"mediumImageUrls"];
    NSDictionary *myArraysub =myArray[0];
   // NSDictionary *dic =[NSString stringWithFormat:@"%@",myArray[@"mediumImageUrls"][@"imageUrl"]];
//    NSLog(@"%@",myString);
//    NSURL *myURL = [NSURL URLWithString:myString];
    
    
    NSURL *myURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",myArraysub[@"imageUrl"]]];
    
    //NSURL *myURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_rakuList[indexPath.row][@"Item"][@"mediumImageUrls"][@"imageUrl"]]];
   // NSURL *myURL=[NSURL URLWithString:@"http://thumbnail.image.rakuten.co.jp/@0_mall/glbooks/cabinet/04574985/syouhinga.jpg?_ex=64x64"];
    NSLog(@"%@",myURL);
    
    NSData *myData=[NSData dataWithContentsOfURL:myURL];
    UIImage *myImage=[UIImage imageWithData:myData];
    cell.cellImageVIew.image=myImage;
    
    
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
