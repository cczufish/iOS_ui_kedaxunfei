//
//  UserWordsViewController.m
//  MSC
//
//  Created by iflytek on 13-4-17.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "UserWordsViewController.h"
#import "iflyMSC/IFlyUserWords.h"

@interface UserWordsViewController ()

@end

@implementation UserWordsViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id) init
{
    if (self = [super init]) {
        
        CGRect frame = [[UIScreen mainScreen] applicationFrame];
        _isrTextView = [[ISRTextView alloc] initWithFrame:frame];
        
        _isrTextView.ent = @"sms";
        [_isrTextView setText:USERWORDS];
        _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _loginButton.frame = CGRectMake(15, 300, 135, 50);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
        
        _uploadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _uploadButton.frame = CGRectMake(160, 300, 135, 50);
        [_uploadButton setTitle:@"上传" forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(onUpload:) forControlEvents:UIControlEventTouchUpInside];
        
        _uploader = [[IFlyDataUploader alloc] initWithDelegate:nil pwd:nil params:nil delegate:self];


        self.title = @"用户词条转写";
    }
    return self;
}

-(void) onLogin:(id) sender
{
    if (![IFlySpeechUser isLogin]) {
        
        _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"正在登录" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [_alertView show];
        
        // 需要先登录
        IFlySpeechUser *loginUser = [[IFlySpeechUser alloc] initWithDelegate:self];
        
        // user 和 pwd 都传入nil时表示是匿名登录
        NSString *loginString = [[NSString alloc] initWithFormat:@"appid=%@",APPID];
        [loginUser login:nil pwd:nil param:loginString];
        [loginString release];
    }
    else {
        _alertView = [[UIAlertView alloc] initWithTitle:@"已登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alertView show];
    }
}

- (void) onUpload:(id)sender
{
    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"正在上传" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alertView show];

    IFlyUserWords *iFlyUserWords = [[[IFlyUserWords alloc] initWithJson:USERWORDS]autorelease];
    [_uploader uploadData:NAME params:PARAMS data:[iFlyUserWords toString]];
}


- (void) loadView
{
    self.view = _isrTextView;
}

- (void)viewDidLoad
{
    [self.view addSubview:_loginButton];
    [self.view addSubview:_uploadButton];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onEnd:(IFlySpeechUser *)iFlySpeechUser error:(IFlySpeechError *)error
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    [_alertView release];
    if (![error errorCode]) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alertView show];
    }
    else {
        _alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[error errorDesc] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alertView show];
        
    }
}

- (void) onEnd:(IFlyDataUploader*) uploader grammerID:(NSString *)grammerID error:(IFlySpeechError *)error
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    [_alertView release];
    
    NSLog(@"%d",[error errorCode]);
    
    if (![error errorCode]) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"上传成功" message:grammerID delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alertView show];
    }
    else {
        _alertView = [[UIAlertView alloc] initWithTitle:@"上传失败" message:[error errorDesc] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alertView show];
    }
}

@end
