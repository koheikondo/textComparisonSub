//
//  ViewController.h
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/09/30.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>{
    
}

@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
@property(strong,nonatomic)NSManagedObjectContext * managedObjectContext;
//データ（コア）を取得する時に使うオブジェクトと管理（追加、削除、更新）するオブジェクト
@property (weak, nonatomic) IBOutlet UIWebView *myRakutenWebVIew;

@property (weak, nonatomic) IBOutlet UITableView *myTableVIew;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
- (IBAction)addBookMark:(id)sender;

- (IBAction)textInputEnd:(id)sender;
- (IBAction)shareBtn:(id)sender;

@end

