//
//  CPBaseViewController.m
//  lottery
//
//  Created by wayne on 2017/11/1.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBaseViewController.h"

@interface CPBaseViewController ()

@end

@implementation CPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewDidAfterLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersHomeIndicatorAutoHidden {
    
    return YES;
    
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
