//
//  ViewController.h
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/09/30.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _textExplanation;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableVIew;


@end

