//
//  RWTransferListCell.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/22.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWTransferListCell.h"
#import "RWTransferViewModel.h"
#import "RWImageLoad.h"

static float const imageWidth = 50;
static float const spaceWidth = 10;

static float const buttonWidth = 50;

@interface RWTransferListCell()

@property (strong, nonatomic)CALayer *imageLayer;
@property (strong, nonatomic)CATextLayer *nameLayer;
@property (strong, nonatomic)CATextLayer *statusLayer;

@property (strong, nonatomic)CALayer *progressLayer;
@property (strong, nonatomic)CALayer *progressBgLayer;
@property (strong, nonatomic)CATextLayer *sizeLayer;
@property (strong, nonatomic)UIButton *cancelBtn;
@property (assign, nonatomic)CGFloat fullProgressWidth;

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
        layer.contentsGravity = kCAGravityResize;
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
    [_statusLayer setHidden:YES];
    [self.contentView.layer addSublayer:_statusLayer];
    
    
    _fullProgressWidth = kWidth  - spaceWidth - imageWidth - spaceWidth - spaceWidth - buttonWidth - spaceWidth;
    _progressBgLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, _fullProgressWidth, 2);
        layer.backgroundColor = [UIColor grayColor].CGColor;
        layer;
    });
    [_progressBgLayer setHidden:YES];
    [self.contentView.layer addSublayer:_progressBgLayer];
    
    _progressLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, 0, 2);
        layer.backgroundColor = [UIColor blueColor].CGColor;
        layer;
    });
    [_progressLayer setHidden:YES];
    [self.contentView.layer addSublayer:_progressLayer];
    
    _sizeLayer = ({
        CATextLayer *statusLayer = [CATextLayer layer];
        statusLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 40, _fullProgressWidth, 20);
        statusLayer.contentsScale = [UIScreen mainScreen].scale;
        statusLayer.foregroundColor =[UIColor blackColor].CGColor;
        statusLayer.fontSize = 13.0f;
        statusLayer;
    });
    [_sizeLayer setHidden:YES];
    [self.contentView.layer addSublayer:_sizeLayer];
    
    _cancelBtn = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(spaceWidth + imageWidth + spaceWidth +_fullProgressWidth + spaceWidth, 10, buttonWidth, buttonWidth)];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button;
    });
    [_cancelBtn setHidden:YES];
    [self.contentView addSubview:_cancelBtn];
}

- (void)bindViewModel:(RWTransferViewModel *)viewModel {
    _viewModel = viewModel;
    
    _nameLayer.string = viewModel.name;
    
    if (viewModel.cover) {
        _imageLayer.contents = (id)viewModel.cover.CGImage;
    } else {
        __weak typeof(self)weakSelf = self;
        if (viewModel.asset) {
            [viewModel loadImageDataWithPhotoWidth:150 success:^(id responseObject) {
                UIImage *image = (UIImage *)responseObject;
                weakSelf.imageLayer.contents = (id)image.CGImage;
            } failure:^(NSError *error) {
                
            }];
        } else if (viewModel.sandboxPath) {
            [viewModel loadSandBoxImageWithIsCoverSize:YES completion:^(UIImage *coverImage) {
                weakSelf.imageLayer.contents = (id)coverImage.CGImage;
            }];
        }
    }
    
    if (viewModel.status == RWTransferStatusTransfer) {
        [self inProgressModel:viewModel];
    } else {
        [self inNormalModel:viewModel];
    }
}

- (void)inNormalModel:(RWTransferViewModel *)viewModel {
    
    [self setProgress:0.0];
    
    [_statusLayer setHidden:NO];
    [_sizeLayer setHidden:YES];
    [_progressLayer setHidden:YES];
    [_progressBgLayer setHidden:YES];
    [_cancelBtn setHidden:YES];
    
    NSString *sizeStr = [RWCommon getFileSizeTextFromSize:viewModel.size];
    _statusLayer.string = [NSString stringWithFormat:@"%@(%@)", viewModel.statusText, sizeStr];
}

- (void)inProgressModel:(RWTransferViewModel *)viewModel {
    
    [_statusLayer setHidden:YES];
    [_sizeLayer setHidden:NO];
    [_progressLayer setHidden:NO];
    [_progressBgLayer setHidden:NO];
    [_cancelBtn setHidden:NO];
    
    NSString *transferSizeStr = [RWCommon getFileSizeTextFromSize:viewModel.transferSize];
    NSString *sizeStr = [RWCommon getFileSizeTextFromSize:viewModel.size];
    _sizeLayer.string = [NSString stringWithFormat:@"%@/%@", transferSizeStr, sizeStr];
    
    CGFloat progress = (CGFloat)_viewModel.transferSize / (CGFloat)_viewModel.size;
    [self setProgress:progress];
}

- (void)setProgress:(CGFloat)progress {
    if (progress <= 0) {
        self.progressLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, 0, 2);
    }else if (progress <= 1) {
        self.progressLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, progress * _fullProgressWidth, 2);
    }else {
        self.progressLayer.frame = CGRectMake(spaceWidth + imageWidth + spaceWidth, 35, _fullProgressWidth, 2);
    }
}


@end
