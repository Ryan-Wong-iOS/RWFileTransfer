//
//  RWVideoListViewCell.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/9.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWVideoListViewCell.h"
#import "RWimageViewModel.h"

@interface RWVideoListViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (strong, nonatomic) RWimageViewModel *viewModel;

@end

@implementation RWVideoListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(RWimageViewModel *)viewModel {
    _viewModel = viewModel;
    
    _titleLab.text = _viewModel.name;
    _selectBtn.selected = _viewModel.selected;
    
    [_viewModel loadVideoDataSuccess:^(long long size, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _coverV.image = image;
            _sizeLab.text = [NSString stringWithFormat:@"%.2fMB",(CGFloat)(size / 1024.0 / 1024.0)];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)selectAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    _viewModel.selected = button.selected;
    !_selectAction?:_selectAction(_viewModel.selected);
}

@end
