//
//  ViewController.m
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/09/30.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import "ViewController.h"
#import "CustomCellTableViewCell.h"
#import "RightSlideMenuView.h"
#import "DetailViewController.h"

@interface ViewController (){
    NSArray *_rakuList;
    RightSlideMenuView *_sideMenuView;
    UIView *_viewForClosingSideMenu;
    BOOL _flg;
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _flg=NO;
    
    self.myTableVIew.dataSource=self;
    self.myTableVIew.delegate=self;
    
    
    //navigationControllerの名前
    self.title=@"安い順にでるよ！";
    //navigationControllerの右側の設定
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"bookMark一覧" style:UIBarButtonItemStyleDone target:self action:@selector(rightBookMark)];
    
    _sideMenuView =[[RightSlideMenuView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_sideMenuView];
    
   // _textExplanation=@[@"あ",@"ああ",@"あああ"];
   
    //楽天のAPI c%E8%A8%80%E8%AA%9E
    NSURL *rakuMyURL =[NSURL URLWithString:@"https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json&keyword=&affiliateId=145ec597.8c7b7ba8.145ec598.8682c646&sort=%2BitemPrice&page=1&hits=15&applicationId=1063216542896291664"];
    
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
// NSLog(@"%@",myString);
// NSURL *myURL = [NSURL URLWithString:myString];
    //NSURL *myURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",_rakuList[indexPath.row][@"Item"][@"mediumImageUrls"][@"imageUrl"]]];
    // NSURL *myURL=[NSURL URLWithString:@"http://thumbnail.image.rakuten.co.jp/@0_mall/glbooks/cabinet/04574985/syouhinga.jpg?_ex=64x64"];

    
    NSURL *myURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",myArraysub[@"imageUrl"]]];
    
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

//セルが押された時の処理
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController*dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
   
    
    dvc.toURL=[NSString stringWithFormat:@"%@",_rakuList[indexPath.row][@"Item"][@"affiliateUrl"]];
    
    
    [[self navigationController]pushViewController:dvc animated:YES];
}

//検索した時の処理
- (IBAction)textInputEnd:(id)sender {
    
    NSString *name=[NSString stringWithFormat:@"%@",self.inputTextField.text];
    NSString *encodeName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    
    NSMutableString *myString=[NSMutableString stringWithFormat:@"https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json&keyword=%@",encodeName];
    
   [myString appendString:@"&affiliateId=145ec597.8c7b7ba8.145ec598.8682c646&sort=%2BitemPrice&page=1&hits=15&applicationId=1063216542896291664"];
    //文字列に%が入っているため2つに分けて文字列を生成する必要がある。
    
   // NSURL *rakuMyURL =[NSURL URLWithString:@"https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json&keyword=%@&affiliateId=145ec597.8c7b7ba8.145ec598.8682c646&sort=%2BitemPrice&page=1&hits=15&applicationId=1063216542896291664"];
    
    NSURL *rakuMyURL =[NSURL URLWithString:myString];
    
    //c%E8%A8%80%E8%AA%9Eが検索文字の場所今回の場合は「C言語」という単語を16進文字コードに変換している。
    
    
    NSURLRequest *rakuMyURLReq=[NSURLRequest requestWithURL:rakuMyURL];
    
    //↓onnectionで通信開始。
    NSData *rakuJson_data=[NSURLConnection sendSynchronousRequest:rakuMyURLReq returningResponse:nil error:nil];
    NSError *rakuerror=nil;
    NSDictionary* rakujsonObject=[NSJSONSerialization JSONObjectWithData:rakuJson_data options:NSJSONReadingAllowFragments  error:&rakuerror];
    //&をつけると参照形式になり、その変数は引数にもなり、戻り値にもなる。
    _rakuList=rakujsonObject[@"Items"];
    
    //テーブルビューをリロード
    [self.myTableVIew reloadData];
    NSLog(@"リロード完了");
}

//ブックマークを右側から表示
-(void)rightBookMark{
    
    if(_flg){
        [self closeSideMenu:0];
    }else{
    // show side menu with animation
    CGRect sideMenuFrame = _sideMenuView.frame;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // アニメーションをする処理
                         _sideMenuView.frame = CGRectMake(self.view.frame.size.width-sideMenuFrame.size.width,
                                                          self.navigationController.navigationBar.frame.size.height,
                                                          sideMenuFrame.size.width,
                                                          sideMenuFrame.size.height);
                     } completion:^(BOOL finished) {
                         // アニメーションが終わった後実行する処理
                     }];
        _flg=YES;
        
    // メニュー外をタップしたら、メニューを閉じるようにする
    // そのためのUIViewをメニュー外に設置し、これをタップしたらメニューを閉じるようにする
    if (!_viewForClosingSideMenu)
    {
        _viewForClosingSideMenu = [[UIView alloc] initWithFrame:
                                   CGRectMake(0,
                                              0,
                                              self.view.frame.size.width
                                              -sideMenuFrame.size.width,
                                              self.view.frame.size.height)];
        _viewForClosingSideMenu.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *closeSideMenuTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(closeSideMenu:)];
        [_viewForClosingSideMenu addGestureRecognizer:closeSideMenuTap];
        [self.view addSubview: _viewForClosingSideMenu];
        }
    }
}

-(void)closeSideMenu:(int)destination
{
    CGRect sideMenuFrame = _sideMenuView.frame;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // アニメーションをする処理
//                         _sideMenuView.frame = CGRectMake(outsideSideMenuX,
//                                                          sideMenuFrame.origin.y,
//                                                          sideMenuFrame.size.width,
//                                                          sideMenuFrame.size.height);
                         _sideMenuView.frame=CGRectMake(self.view.frame.size.width, sideMenuFrame.origin.y, sideMenuFrame.size.width, sideMenuFrame.size.height);
                     } completion:^(BOOL finished) {
                         // アニメーションが終わった後実行する処理
                     }];
    
    // メニューを閉じるためのUIViewを削除
    if (_viewForClosingSideMenu)
    {
        [_viewForClosingSideMenu removeFromSuperview];
        _viewForClosingSideMenu= nil;
    }
    _flg=NO;
}


@end
