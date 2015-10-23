//
//  DetailViewController.m
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/10/01.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"VIEWURL=%@",self.toURL);
    NSURL *myURL =[NSURL URLWithString:self.toURL];
    NSURLRequest *myURLReq =[NSURLRequest requestWithURL:myURL];
    [self.myWebView loadRequest:myURLReq];
    [self bannerstart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bannerstart{
    //バナーを設置
    //変数を初期化
    _adView =[[ADBannerView alloc]init];
    
    //配置場所を決定。
    //adview　はもともと自身の高さを持っている。今回の場合はおおよそ４０
    //ユーザからは見えない場所に設置している。（画面外の上）
    _adView.frame = CGRectMake(0, self.view.frame.size.height, _adView.frame.size.width, _adView.frame.size.height);
    
    //透明にセット
    _adView.alpha=0.0;
    
    //delegate
    _adView.delegate=self;
    
    //画面本体に追加
    [self.view addSubview:_adView];
    
    //最初はバナーが表示されていないので表示フラグをNOに
    _inVisble=NO;
}

//広告が正常に配信された場合。
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    //バナーを見えるところに再配置
    
    //広告が表示されていない時この処理をしたいので、分岐を行う。
    //アニメーションに対してのcontext(内容）がない（nil)
    if (!_inVisble) {
        [UIView beginAnimations:@"animateAdBannerOn" context:nil];
        
        [UIView setAnimationDuration:0.3];//再生される感覚のスピード、大きければ大きほどゆっくり。
        //どういう場所に次は置かれるのかを指定。
        //縦横の大きさはそのままで、バナーの縦幅を取得している。
        //x軸は０,y軸は40
        
        _adView.frame = CGRectMake(0, self.view.frame.size.height - _adView.frame.size.height, _adView.frame.size.width, _adView.frame.size.height);
        
        
        //   banner.frame=CGRectOffset(banner.frame, 0, CGRectGetHeight(banner.frame));
        //三番目が右下Y座標の数値
        //二番目が左上のどこから始まるか？
        banner.alpha=1.0;//透明度を表している。1.0は不透明。
        [UITableView commitAnimations];
        
        //表示フラグの変更。
        _inVisble=YES;
    }
    
    
    
    
}

//広告が正常に配信されなかった場合。
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //バナーが表示されていたら隠す。
    if (_inVisble) {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:nil];
        
        [UIView setAnimationDuration:0.3];//再生される感覚のスピード、大きければ大きほどゆっくり。
        //どういう場所に次は置かれるのかを指定。
        //縦横の大きさはそのままで、バナーの縦幅を取得している。
        //x軸は０,y軸は40
        _adView.frame = CGRectMake(0, self.view.frame.size.height - _adView.frame.size.height, _adView.frame.size.width, _adView.frame.size.height);
        
        //banner.frame = CGRectMake(0, self.view.frame.size.height,banner.frame.size.width, banner.frame.size.height);
        banner.alpha=0.0;//透明度を表している。1.0は不透明。
        [UITableView commitAnimations];
        
        _inVisble=NO;
    }
    
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
