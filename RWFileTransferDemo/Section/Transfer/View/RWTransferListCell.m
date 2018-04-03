//
//  RWTransferListCell.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/22.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWTransferListCell.h"
#import "RWTransferViewModel.h"

static float const imageWidth = 50;
static float const spaceWidth = 10;

@interface RWTransferListCell()

@property (strong, nonatomic)CALayer *imageLayer;
@property (strong, nonatomic)CATextLayer *nameLayer;
@property (strong, nonatomic)CATextLayer *statusLayer;

@property (strong, nonatomic)RWTransferViewModel *viewModel;

@end

@implementation RWTransferListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _imageLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(spaceWidth, spaceWidth, imageWidth, imageWidth);
        layer.backgroundColor = [UIColor grayColor].CGColor;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer;
    });
    [self.contentView.layer addSublayer:_imageLayer];
    
    _nameLayer = ({
        CGFloat width = kWidth  - spaceWidth - imageWidth - spaceWidth - spaceWidth;
        CATextLayer *nameLayer = [CATextLayer layer];
        nameLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, spaceWidth, width, 20);
        nameLayer.contentsScale = [UIScreen mainScreen].scale;
        nameLayer.foregroundColor =[UIColor blackColor].CGColor;
        nameLayer.fontSize = 15.0f;
        nameLayer;
    });
    [self.contentView.layer addSublayer:_nameLayer];
    
    _statusLayer = ({
        CGFloat width = kWidth  - spaceWidth - imageWidth - spaceWidth - spaceWidth;
        CATextLayer *statusLayer = [CATextLayer layer];
        statusLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, width, 20);
        statusLayer.contentsScale = [UIScreen mainScreen].scale;
        statusLayer.foregroundColor =[UIColor blackColor].CGColor;
        statusLayer.fontSize = 13.0f;
        statusLayer;
    });
    [self.contentView.layer addSublayer:_statusLayer];
}

- (void)bindViewModel:(RWTransferViewModel *)viewModel {
    _viewModel = viewModel;
    
//    _imageLayer.contents = (id)image.CGImage;
    _nameLayer.string = viewModel.name;
    NSString *sizeStr = [RWCommon getFileSizeTextFromSize:viewModel.size];
    _statusLayer.string = [NSString stringWithFormat:@"%@(%@)", viewModel.statusText, sizeStr];
}

@end
