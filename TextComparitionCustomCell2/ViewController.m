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
#import "BookMarkData.h"
#import "AppDelegate.h"
#import "XMLReader.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@interface ViewController (){
    NSArray *_rakuList;
    NSMutableArray *_bookMarkArray;
    RightSlideMenuView *_sideMenuView;
    UIView *_viewForClosingSideMenu;
    BOOL _flg;
    UITableView *bookMarktable;
    NSString *_productName;//検索文字
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _flg=NO;
    
    self.myTableVIew.dataSource=self;
    self.myTableVIew.delegate=self;
    self.myTableVIew.tag = 1;
    
    //coredataの準備
    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    self.managedObjectContext=context;
    //配列にcoredataの中身を追加
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]initWithEntityName:@"BookMarkData"];
    
    NSArray *array =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    _bookMarkArray =[array mutableCopy];
    
    //navigationControllerの名前
    self.title=@"安い順にでるよ！";
    //navigationControllerの右側の設定
  //  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"bookMark一覧" style:UIBarButtonItemStyleDone target:self action:@selector(rightBookMark)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(rightBookMark)];
    
    bookMarktable =(UITableView *)[[RightSlideMenuView alloc]initWithFrame:self.view.frame];;
    bookMarktable.delegate = self;
    bookMarktable.dataSource = self;
    bookMarktable.tag = 2;
    
    _sideMenuView = (RightSlideMenuView *)bookMarktable;
    
    [self.view addSubview:_sideMenuView];
    
    
   //初期画面は何も表示しないため、空白を入れ検索させている。
    _productName=@"";
    [self serchProduct];
    
    
    //カスタムセルを設定
    UINib *nib=[UINib nibWithNibName:@"CustomCellView" bundle:nil];
    
    //テーブルにカスタムセルを設置
    [self.myTableVIew registerNib:nib forCellReuseIdentifier:@"Cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==1){
    return _rakuList.count;
    }else{
        //ブックマークテーブルの行数を返す。
    return _bookMarkArray.count;
    }
}

//テーブルビューの中身を表示
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1){
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
    }else{
        static NSString *cellIdentifier =@"Cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        if(cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
           
            
            
        }
        
        //bookmarkarrayの中にコアデータ型のデータ入ってる。そのためこのような指定が必要
        BookMarkData *bookmarkdata =_bookMarkArray[indexPath.row];

        cell.textLabel.text=bookmarkdata.title;
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//セルが押された時の処理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1){
    DetailViewController*dvc=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
   
    
    dvc.toURL=[NSString stringWithFormat:@"%@",_rakuList[indexPath.row][@"Item"][@"affiliateUrl"]];
    
    
    [[self navigationController]pushViewController:dvc animated:YES];
    }else{
        
        //ワンテンポ遅れるブックマークバー
        //bookmarkの中身を書く
        BookMarkData *bookmarkdata = _bookMarkArray[indexPath.row];
        _productName =[NSString stringWithFormat:@"%@",bookmarkdata.title];
        NSLog(@"プロダクトネーム=%@",_productName);
       
        self.inputTextField.text=[NSString stringWithFormat:@"%@",bookmarkdata.title];
        
        
        
        //JSONフィアルを取得
        [self serchProduct];
        
        [self.myTableVIew reloadData];
        //画面を閉じる。
        [self closeSideMenu:0];
    }
}

//検索データをコアデータに追加
- (IBAction)addBookMark:(id)sender {
    
    
    //コアデータに追加
    if([self.inputTextField.text isEqualToString:@""]){
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"お知らせ" message:@"文字が入力されていません。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
    }else{
    
        NSString *title =self.inputTextField.text;
        
        //coredataに保存
        BookMarkData *bookmarkdata=[NSEntityDescription insertNewObjectForEntityForName:@"BookMarkData" inManagedObjectContext:self.managedObjectContext];
        [bookmarkdata setTitle:title];
        
        NSError *error;
        if(![self.managedObjectContext save:&error]){
            NSLog(@"%@",error);
        }else{
            NSLog(@"保存成功");
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"message" message:@"BookMarkに追加されました。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alert show];
        }
    }
    
    //配列に追加.
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]initWithEntityName:@"BookMarkData"];
    
    NSArray *array =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    _bookMarkArray =[array mutableCopy];
    //TODO:aaa
    [bookMarktable reloadData];
}


//検索した時の処理
- (IBAction)textInputEnd:(id)sender {
    _productName =[NSString stringWithFormat:@"%@",self.inputTextField.text];
   // NSString *name=[NSString stringWithFormat:@"%@",self.inputTextField.text];
    
    //urlからJSONデータを取得。配列に入れる。
    [self serchProduct];
    
    //テーブルビューをリロード
    [self.myTableVIew reloadData];
    NSLog(@"リロード完了");
}

//検索文字を検索する。webからAPIを引っ張ってきて、配列に入れている。
-(void)serchProduct{
    NSString *encodeName = [_productName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    
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
    
    
    
    
    
    //AmazonAPIスタート
    
    NSMutableString *myStringOfHash=[NSMutableString stringWithString:@"GET\nwebservices.amazon.co.jp\n/onca/xml\n"];
    
    NSMutableString *myString1=[NSMutableString stringWithFormat:@"http://webservices.amazon.co.jp/onca/xml?"];
    //http://webservices.amazon.com/onca/xml?
    
    
    NSMutableString *myString2=[NSMutableString stringWithFormat:@"AWSAccessKeyId=AKIAITG265V3E7GIXTIQ&AssociateTag=settanaoto-22&Keywords=%@",encodeName];
    //TODO:検索文字を追加の処理を書く。
    
    //  NSString *myString2_1=@"&Operation=ItemSearch&ResponseGroup=ItemAttributes%2COffers&SearchIndex=All&Service=AWSECommerceService&Sort=price&Timestamp=";
    //カテゴリ指定しないバージョン
    //  NSString *myString2_1=@"&Operation=ItemSearch&ResponseGroup=Medium&SearchIndex=All&Service=AWSECommerceService&Timestamp=";
    
    
    //カテゴリ指定するバージョン
    NSString *myString2_1=@"&Operation=ItemSearch&ResponseGroup=Medium&SearchIndex=Books&Service=AWSECommerceService&Sort=pricerank&Timestamp=";
    //NSString *myString2_1=@"&Operation=ItemSearch&ResponseGroup=ItemAttributes%2COffers&SearchIndex=All&Service=AWSECommerceService&Timestamp=";
    [myString2 appendString:myString2_1];
    
    NSLog(@"%@",myString2);
    
    NSString *myString3=@"&Version=2013-08-01";
    NSString *myString4=@"&Signature=";
    
    //今日の日付を取得
    NSDate *now =[NSDate date];
    NSLog(@"現在時刻%@",now);
    //指定した書式で日付を文字列に変換する。
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // 日付を yyyy/MM/dd hh:mm:ss形式に変更
    NSString *dateString = [dateFormatter stringFromDate:now];
    NSLog(@"%@", dateString);
    [myString2 appendString:dateString];
    
    
    NSDate *now2 =[NSDate date];
    NSLog(@"現在時刻%@",now2);
    //指定した書式で日付を文字列に変換する。
    NSDateFormatter *dateFormatterM =[[NSDateFormatter alloc]init];
    [dateFormatterM setDateFormat:@"HH:mm:ss"];
    
    // 日付を yyyy/MM/dd hh:mm:ss形式に変更
    NSString *dateString2 = [dateFormatterM stringFromDate:now2];
    NSLog(@"%@", dateString2);
    
    //追加するときの文字列を作成T~Z形式
    NSString *dateFinal=[NSString stringWithFormat:@"T%@Z",dateString2];
    NSLog(@"最終日付%@",dateFinal);
    
    //エンコーディング
    NSString *encodeNameDate = [dateFinal stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    
    [myString2 appendString:encodeNameDate];
    [myString2 appendString:myString3];
    [myStringOfHash appendString:myString2];
    
    
    //ハッシュタグを取得、#include <CommonCrypto/CommonDigest.h>#include <CommonCrypto/CommonHMAC.h>
    NSString *key;
    key=@"XIURsSPrqyImsfeMrhiB7cTCgIopq9uv6wQopvCg";
    const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [myStringOfHash cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    //base64Encoding  base64EncodedStringWithOptions:0
    
    NSString *encodeNameDateHash = [hash stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    
    
    [myString1 appendString:myString2];
    [myString1 appendString:myString4];
    [myString1 appendString:encodeNameDateHash];
    
    NSURL *amazonMyURL =[NSURL URLWithString:myString1];
    
    //c%E8%A8%80%E8%AA%9Eが検索文字の場所今回の場合は「C言語」という単語を16進文字コードに変換している。
    
    
    NSURLRequest *amazonMyURLReq=[NSURLRequest requestWithURL:amazonMyURL];
    
    //↓onnectionで通信開始。
    NSData *amazonXML_data=[NSURLConnection sendSynchronousRequest:amazonMyURLReq returningResponse:nil error:nil];
    
    NSLog(@"amazonXMLデータは%@",amazonXML_data);
    
    //XMLReaderをインストールして、#importする。
    NSError*amazonError1;
    NSDictionary*amazonDict= [XMLReader dictionaryForXMLData:amazonXML_data options:XMLReaderOptionsProcessNamespaces  error:&amazonError1];
    
    NSError *amazonError;
    NSData *amazonJsonDate=[NSJSONSerialization dataWithJSONObject:amazonDict options:NSJSONWritingPrettyPrinted error:&amazonError];
    NSString *amazonJsonString=[[NSString alloc]initWithData:amazonJsonDate encoding:NSUTF8StringEncoding];
    NSLog(@"%@",amazonJsonString);
    
    //出来たURLの確認
    NSLog(@"URL=%@",myString1);
    NSLog(@"最終日付エンコード後＝%@",encodeNameDate);
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
                                                          self.navigationController.navigationBar.frame.size.height+20,
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
                         _sideMenuView.frame=CGRectMake(self.view.frame.size.width, sideMenuFrame.origin.y-50, sideMenuFrame.size.width, sideMenuFrame.size.height);
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


//スワイプで削除（bookMarkBar)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag==2){
    
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //CoreDataから削除
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            //↑２行はテンプレート　コアデータの中身を操作する際の。
            
            //_bookMarkArrayにはstring型だけではなく　コアデータのオブジェクトが入っているため識別できる。
            BookMarkData *bookMarkData =  _bookMarkArray[indexPath.row];
            [context deleteObject:bookMarkData];
            
            NSError *error = nil;
            //save methodが実行されている。これを指定しないと上書きされない。
            if (![context save:&error]) {
                NSLog(@"%@", error);
            } else {
                NSLog(@"削除完了");
            }
            
            //表示側も配列からデータを削除することでCoreDataの状態を反映
            [_bookMarkArray removeObjectAtIndex:indexPath.row]; // 削除ボタンが押された行のデータを配列から削除します。
            
            //テーブルビューからも消します
            [bookMarktable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // ここは空のままでOKです。
        }
    }else{
        
    }
    
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    if (tableView.tag==1) {
    return UITableViewCellEditingStyleNone;
    
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}
@end
