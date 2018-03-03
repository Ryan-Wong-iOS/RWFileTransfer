//
//  RWPhotoViewCell.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/1.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWPhotoViewCell.h"
#import "RWimageViewModel.h"

@interface RWPhotoViewCell()

@property (strong, nonatomic)CALayer *imageLayer;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (copy, nonatomic)RWimageViewModel *viewModel;

//@property (strong, nonatomic)UIImageView *testView;

@end

@implementation RWPhotoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imageLayer = ({
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor grayColor].CGColor;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer;
    });
    [self.bgView.layer addSublayer:_imageLayer];
    
}

- (void)bindViewModel:(RWimageViewModel *)viewModel {
    _viewModel = viewModel;
    _selectBtn.selected = _viewModel.selected;
    __weak typeof(self) weakSelf = self;
    [_viewModel loadImageDataWithPhotoWidth:150 success:^(id responseObject) {
        UIImage *image = (UIImage *)responseObject;
        [weakSelf setupImageViewByLayer:image];
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupImageViewByLayer:(UIImage *)image {
    _imageLayer.frame = self.bounds;
    _imageLayer.contents = (id)image.CGImage;
}

- (IBAction)selectAction:(id)sender {
    
    UIButton *button =(UIButton *)sender;
    button.selected = !button.selected;
    _viewModel.selected = button.selected;
    !_selectAction?:_selectAction(_viewModel.selected);
}

@end
