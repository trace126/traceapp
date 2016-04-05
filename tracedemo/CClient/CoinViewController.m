//
//  CoinViewController.m
//  tracedemo
//
//  Created by zhuxiaoxia on 16/3/23.
//  Copyright © 2016年 trace. All rights reserved.
//

#import "CoinViewController.h"
#import "TKUserCenter.h"

@interface CoinViewController ()

@end

@implementation CoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moneyText.text =  [[TKUserCenter instance] getUser].ackData.bigMoney;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self TKaddNavigationTitle:@"我的大牌币"];
}

@end
