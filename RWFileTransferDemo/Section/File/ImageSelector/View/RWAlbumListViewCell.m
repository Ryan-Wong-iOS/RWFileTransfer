//
//  RWAlbumListViewCell.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWAlbumListViewCell.h"
#import "RWAlbumViewModel.h"

@interface RWAlbumListViewCell()

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@property (strong, nonatomic) RWAlbumViewModel *viewModel;

@end

@implementation RWAlbumListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(RWAlbumViewModel *)viewModel {
    _viewModel = viewModel;
    
    _titleLab.text = _viewModel.title;
    _countLab.text = [NSString stringWithFormat:@"%zd/%zd", _viewModel.selectedCount, _viewModel.count];
    _selectBtn.selected = _viewModel.selected;
}

- (IBAction)selectAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
        [_viewModel selectedAll];
    } else {
        [_viewModel removeAll];
    }
    button.selected = !button.selected;
    _countLab.text = [NSString stringWithFormat:@"%zd/%zd", _viewModel.selectedCount, _viewModel.count];
}

@end
