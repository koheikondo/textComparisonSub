//
//  RightSlideMenuView.m
//  TextComparitionCustomCell2
//
//  Created by 近藤 康平 on 2015/10/03.
//  Copyright (c) 2015年 Kohe. All rights reserved.
//

#import "RightSlideMenuView.h"

@implementation RightSlideMenuView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width, 0, 160, 568);
        //self.frame = CGRectMake( 0, 0, 160, 568);
        self.backgroundColor = [UIColor blueColor];
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 100, 100)];
        title.text = @"スライドメニューが表示されました";
        title.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
