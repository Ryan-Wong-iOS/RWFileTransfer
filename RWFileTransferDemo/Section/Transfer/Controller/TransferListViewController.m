//
//  TransferViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "TransferListViewController.h"
#import "RWAlbumListViewController.h"
#import "RWTransferViewModel.h"
#import "RWTransferCenter.h"

#import "RWUserCenter.h"
#import "RWSession.h"
#import "RWOutputStream.h"
#import "RWInputStream.h"

#import "RWFileManager.h"
#import "RWFileHandle.h"

@interface TransferListViewController () <RWSessionDelegate, RWOutputStreamDelegate, RWInputStreamDelegate>

@property (strong, nonatomic)RWTransferCenter *center;

@property (strong, nonatomic)RWSession *session;
@property (strong, nonatomic)RWOutputStream *outputStream;
@property (strong, nonatomic)RWInputStream *inputStream;

@end

@implementation TransferListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"任务准备：%@", self.center.readyTaskDatas);
    if (self.center.readyTaskDatas.count > 0) {
        [self sendTest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *chooseBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择文件" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAction)];
    self.navigationItem.rightBarButtonItem = chooseBtn;
    
    self.session.delegate = self;
}

- (void)chooseAction {
    RWAlbumListViewModel *viewModel = [[RWAlbumListViewModel alloc] init];
    viewModel.title = @"选择相册";
    RWAlbumListViewController *vc = [[RWAlbumListViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendTest {
    if (self.center.readyTaskDatas.count <= 0) {
        return;
    }
    RWTransferViewModel *viewModel = [self.center currentReadyTask];
    NSLog(@"准备发送 %@", viewModel.timestampText);
    NSArray *peers = [self.session connectedPeers];
    
    if (peers.count) {
        RWOutputStream *outputStream = [[RWOutputStream alloc] initWithOutputStream:[self.session outputStreamForPeer:peers[0] With:viewModel.timestampText]];
        outputStream.streamName = viewModel.timestampText;
        outputStream.delegate = self;
        [outputStream streamWithAsset:viewModel.asset];
        [outputStream start];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tran" forIndexPath:indexPath];
    
    
    return cell;
}

#pragma mark - RWSession Delegate

-(void)session:(RWSession *)session didReceiveStream:(NSInputStream *)stream WithName:(NSString *)streamName {
    RWInputStream *inputStream = [[RWInputStream alloc] initWithInputStream:stream];
    inputStream.streamName = streamName;
    inputStream.delegate = self;
    [inputStream start];
}

-(RWSession *)session {
    return [RWUserCenter center].session;
}

-(RWTransferCenter *)center {
    return [RWTransferCenter center];
}

#pragma mark - RWOutputStream Delegate

-(void)outputStream:(RWOutputStream *)outputStream progress:(long long)progress {
    
}

-(void)outputStream:(RWOutputStream *)outputStream transferEndWithStreamName:(NSString *)name {
    outputStream.delegate = nil;
    outputStream = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.center nextReadyTask];
        [self sendTest];
    });
}

-(void)outputStream:(RWOutputStream *)outputStream transferErrorWithStreamName:(NSString *)name {
    outputStream.delegate = nil;
    outputStream = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendTest];
    });
}

#pragma mark - RWInputStream Delegate
- (void)inputStream:(RWInputStream *)inputStream progress:(long long)progress {
    
}

- (void)inputStream:(RWInputStream *)inputStream transferEndWithStreamName:(NSString *)name filePath:(NSString *)filePath {
    NSLog(@"传输完成 得到临时文件路径 ： %@", filePath);
    
    [self handleTmpFile:filePath name:name];
    
    [inputStream stop];
    inputStream.delegate = nil;
    inputStream = nil;
}

- (void)inputStream:(RWInputStream *)inputStream transferErrorWithStreamName:(NSString *)name {
    [inputStream stop];
    inputStream.delegate = nil;
    inputStream = nil;
}

- (void)handleTmpFile:(NSString *)filePath name:(NSString *)name {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *pictureDirectory = [RWFileManager picturesDirectory];
        NSString *fileName = [[name stringByReplacingOccurrencesOfString:@"." withString:@"_"] stringByAppendingString:@".png"];
        NSString *targetPath = [NSString stringWithFormat:@"%@/%@", pictureDirectory, fileName];
        [weakSelf moveItemFrom:filePath to:targetPath];
    });
}

- (void)moveItemFrom:(NSString *)filePath to:(NSString *)targetPath {
    [RWFileHandle copyFileFromPath:filePath toPath:targetPath];
    [RWFileManager deleteFileAtPath:filePath];
}

@end
