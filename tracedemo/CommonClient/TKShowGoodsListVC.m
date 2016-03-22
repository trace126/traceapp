//
//  TKShowGoodsListVC.m
//  tracedemo
//
//  Created by cmcc on 16/3/21.
//  Copyright © 2016年 trace. All rights reserved.
//

#import "TKShowGoodsListVC.h"
#import "TKShowGoodsListVM.h"

@interface TKShowGoodsListVC ()

@end





@implementation TKShowGoodsListVC





- (void)viewDidLoad {
//    self.hidDefaultBackBtn = YES;
    [super viewDidLoad];
    
    
    [self.view addSubview:self.vm.pullRefreshView];
    [self.vm tkLoadDefaultData];
    [self.vm tkUpdateViewConstraint];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(TKIShowGoodsVM *)vm
{
    if(!_vm)
    {
        _vm  = [[TKIShowGoodsVM alloc] initWithFreshAbleTable];
    }
    return _vm;
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