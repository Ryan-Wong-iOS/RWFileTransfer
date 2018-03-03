//
//  RWBaseViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWBaseViewController.h"

@interface RWBaseViewController ()

@property (strong, nonatomic, readwrite)id baseViewModel;

@end

@implementation RWBaseViewController

- (instancetype)initWithViewModel:(id)baseViewModel{
    self = [super init];
    if (self) {
        self.baseViewModel = baseViewModel;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
