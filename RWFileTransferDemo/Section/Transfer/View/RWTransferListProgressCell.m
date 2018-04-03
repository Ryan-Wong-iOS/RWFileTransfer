//
//  RWTransferListProgressCell.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/23.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWTransferListProgressCell.h"
#import "RWTransferViewModel.h"

static float const imageWidth = 50;
static float const spaceWidth = 10;
static float const buttonWidth = 50;

@interface RWTransferListProgressCell()

@property (strong, nonatomic)CALayer *imageLayer;
@property (strong, nonatomic)CATextLayer *nameLayer;
@property (strong, nonatomic)CALayer *progressLayer;
@property (strong, nonatomic)CALayer *progressBgLayer;
@property (strong, nonatomic)CATextLayer *sizeLayer;
@property (strong, nonatomic)UIButton *cancelBtn;
@property (assign, nonatomic)CGFloat fullProgressWidth;

@property (strong, nonatomic)RWTransferViewModel *viewModel;

@end

@implementation RWTransferListProgressCell

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
    
     _fullProgressWidth = kWidth  - spaceWidth - imageWidth - spaceWidth - spaceWidth - buttonWidth - spaceWidth;
    _progressBgLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, _fullProgressWidth, 2);
        layer.backgroundColor = [UIColor grayColor].CGColor;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer;
    });
    [self.contentView.layer addSublayer:_progressBgLayer];
    
    _progressLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, 0, 2);
        layer.backgroundColor = [UIColor blueColor].CGColor;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer;
    });
    [self.contentView.layer addSublayer:_progressLayer];
    
    _sizeLayer = ({
        CATextLayer *statusLayer = [CATextLayer layer];
        statusLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 40, _fullProgressWidth, 20);
        statusLayer.contentsScale = [UIScreen mainScreen].scale;
        statusLayer.foregroundColor =[UIColor blackColor].CGColor;
        statusLayer.fontSize = 13.0f;
        statusLayer;
    });
    [self.contentView.layer addSublayer:_sizeLayer];
    
    _cancelBtn = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(spaceWidth + imageWidth + spaceWidth +_fullProgressWidth + spaceWidth, 10, buttonWidth, buttonWidth)];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button;
    });
    [self.contentView addSubview:_cancelBtn];
}

- (void)bindViewModel:(RWTransferViewModel *)viewModel {
    _viewModel = viewModel;
    
    //    _imageLayer.contents = (id)image.CGImage;
    _nameLayer.string = viewModel.name;
    NSString *transferSizeStr = [RWCommon getFileSizeTextFromSize:viewModel.transferSize];
    NSString *sizeStr = [RWCommon getFileSizeTextFromSize:viewModel.size];
    _sizeLayer.string = [NSString stringWithFormat:@"%@/%@", transferSizeStr, sizeStr];
    
    CGFloat progress = (CGFloat)_viewModel.transferSize / (CGFloat)_viewModel.size;
    [self setProgress:progress];
}

- (void)setProgress:(CGFloat)progress {
    if (progress <= 0) {
        self.progressLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, 0, 2);
        [self.layer displayIfNeeded];
    }else if (progress <= 1) {
        self.progressLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, progress * _fullProgressWidth, 2);
    }else {
        self.progressLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, _fullProgressWidth, 2);
    }
}

@end
