//
//  TransferViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "TransferListViewController.h"
#import "RWAlbumListViewController.h"
#import "RWVideoListViewController.h"
#import "RWTransferListView.h"
#import "RWTransferViewModel.h"
#import "RWTransferCenter.h"

#import "RWUserCenter.h"
#import "RWSession.h"
#import "RWOutputStream.h"
#import "RWInputStream.h"

#import "RWFileManager.h"
#import "RWFileHandle.h"

@interface TransferListViewController () <RWSessionDelegate, RWOutputStreamDelegate, RWInputStreamDelegate>

@property (strong, nonatomic)RWTransferListViewModel *viewModel;

@property (strong, nonatomic)RWTransferListView *transferListView;

@property (strong, nonatomic)RWSession *session;
@property (strong, nonatomic)RWOutputStream *outputStream;
@property (strong, nonatomic)RWInputStream *inputStream;

@end

@implementation TransferListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self sendTaskInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = (RWTransferListViewModel *)self.baseViewModel;
    [_viewModel setTarget:self];
    
    self.title = _viewModel.title;
    
    [self.view addSubview:self.transferListView];
    
    self.session.delegate = self;
    
    UIBarButtonItem *chooseBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择文件" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAction)];
    self.navigationItem.rightBarButtonItem = chooseBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notConnect) name:kRWSessionStateNotConnectedNotification object:nil];
    
    [self registerSenderTaskListener];
}

- (void)notConnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)chooseAction {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"请选择发送的文件目录" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            RWAlbumListViewModel *viewModel = [[RWAlbumListViewModel alloc] init];
            viewModel.title = @"选择相册";
                RWAlbumListViewController *vc = [[RWAlbumListViewController alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }]];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            RWAlbumListViewModel *viewModel = [[RWAlbumListViewModel alloc] init];
            viewModel.title = @"选择视频";
            RWVideoListViewController *vc = [[RWVideoListViewController alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }]];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self.navigationController presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)sendTaskInfo {
    [_viewModel sendPeerTaskInfo];
    [_transferListView reloadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RWSession Delegate

-(void)session:(RWSession *)session didReceiveData:(NSData *)data {
    [_viewModel handleReceiveData:data];
}

-(void)session:(RWSession *)session didReceiveStream:(NSInputStream *)stream WithName:(NSString *)streamName {
    [_viewModel createReceiveStreamWithStream:stream streamName:streamName];
    [_transferListView reloadTableView];
}

#pragma mark - RWOutputStream Delegate

-(void)outputStream:(RWOutputStream *)outputStream progress:(long long)progress {
    
}

-(void)outputStream:(RWOutputStream *)outputStream transferEndWithStreamName:(NSString *)name {
    outputStream.delegate = nil;
    outputStream = nil;
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.viewModel nextReadyTask];
        [self sendTaskInfo];
    });
}

-(void)outputStream:(RWOutputStream *)outputStream transferErrorWithStreamName:(NSString *)name {
    outputStream.delegate = nil;
    outputStream = nil;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self sendFile];
//    });
}

#pragma mark - RWInputStream Delegate
- (void)inputStream:(RWInputStream *)inputStream streamName:(NSString *)name progress:(long long)progress {
    [_viewModel receiveTaskProgressWithStreamName:name progress:progress];
    NSInteger index = [_viewModel getTaskIndexWithStreamName:name];
    [_transferListView reloadProgressCell:index];
}

- (void)inputStream:(RWInputStream *)inputStream transferEndWithStreamName:(NSString *)name filePath:(NSString *)filePath {
    __weak typeof(self) weakSelf = self;
    [_viewModel handleTmpFile:filePath name:name completion:^(NSString *targetName) {
        NSInteger index = [weakSelf.viewModel getTaskIndexWithStreamName:targetName];
        [weakSelf.transferListView reloadSingleCell:index];
    }];
    [_viewModel receiveTaskFinishWithStreamName:name];
    
    [inputStream stop];
    inputStream.delegate = nil;
    inputStream = nil;
    
    NSInteger index = [_viewModel getTaskIndexWithStreamName:name];
    [_transferListView reloadSingleCell:index];
}

- (void)inputStream:(RWInputStream *)inputStream transferErrorWithStreamName:(NSString *)name {
    [_viewModel receiveTaskErrorWithStreamName:name];
    
    [inputStream stop];
    inputStream.delegate = nil;
    inputStream = nil;
    
    NSInteger index = [_viewModel getTaskIndexWithStreamName:name];
    [_transferListView reloadSingleCell:index];
}

#pragma mark - Data From Receiver
- (void)registerSenderTaskListener {
    __weak typeof(self) weakSelf = self;
    [_viewModel sendTaskBegin:^(NSDictionary *dict) {
        NSString *name = dict[@"timestamp"];
        NSInteger index = [weakSelf.viewModel getTaskIndexWithStreamName:name];
        [weakSelf.transferListView reloadSingleCell:index];
    }];
    
    [_viewModel sendTaskProgress:^(NSDictionary *dict) {
        NSString *name = dict[@"timestamp"];
        NSInteger index = [weakSelf.viewModel getTaskIndexWithStreamName:name];
        [weakSelf.transferListView reloadProgressCell:index];
    }];
    
    [_viewModel sendTaskFinish:^(NSDictionary *dict) {
        NSString *name = dict[@"timestamp"];
        NSInteger index = [weakSelf.viewModel getTaskIndexWithStreamName:name];
        [weakSelf.transferListView reloadSingleCell:index];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [_viewModel nextReadyTask];
//            [self sendTaskInfo];
//        });
    }];
    
    [_viewModel sendTaskError:^(NSDictionary *dict) {
        NSString *name = dict[@"timestamp"];
        NSInteger index = [weakSelf.viewModel getTaskIndexWithStreamName:name];
        [weakSelf.transferListView reloadSingleCell:index];
    }];
}

#pragma mark - Lazy load
-(RWTransferListView *)transferListView {
    if (!_transferListView) {
        _transferListView = [[RWTransferListView alloc] initWithFrame:self.view.frame];
    }
    return _transferListView;
}

-(RWSession *)session {
    return [RWUserCenter center].session;
}

-(void)dealloc {
    RWStatus(@"传输圈销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[RWUserCenter center] remove];
    [[RWTransferCenter center] removeAllTaskData];
}

@end
