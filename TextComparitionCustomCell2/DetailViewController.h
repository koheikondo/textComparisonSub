//
//  DetailViewController.h
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/10/01.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (nonatomic,assign) int selectNum;
@property (nonatomic,assign) NSString *toURL;
@end
