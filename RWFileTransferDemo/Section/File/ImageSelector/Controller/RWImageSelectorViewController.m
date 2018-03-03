//
//  RWImageSelectorViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/26.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWImageSelectorViewController.h"
#import "RWImageSelectorViewModel.h"
#import "RWAlbumViewModel.h"
#import "RWimageViewModel.h"
#import "RWPhotoCollectView.h"

#import "RWImageLoad.h"

@interface RWImageSelectorViewController ()

@property (strong, nonatomic)RWPhotoCollectView *photoCV;

@property (strong, nonatomic)RWImageSelectorViewModel *viewModel;

@end

@implementation RWImageSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = self.baseViewModel;
    self.title = self.viewModel.title;
    
    [self.view addSubview:self.photoCV];

    [_photoCV reloadWithData:_viewModel.albumViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RWPhotoCollectView *)photoCV {
    if (!_photoCV) {
        _photoCV = [[RWPhotoCollectView alloc] initWithFrame:self.view.frame];
    }
    return _photoCV;
}

@end
