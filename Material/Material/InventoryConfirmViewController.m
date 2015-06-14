//
//  InventoryConfirmViewController.m
//  Material
//
//  Created by exmooncake on 15-6-14.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "InventoryConfirmViewController.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface InventoryConfirmViewController ()<CaptuvoEventsProtocol, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;

@end

@implementation InventoryConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    NSLog(@"pass inventory id is %d", self.inventroy_id);
    self.scanTextField.delegate=self;
    [self.scanTextField becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    self.scanTextField.text=@"";
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}


-(void)decoderDataReceived:(NSString *)data
{
    self.scanTextField.text=data;
    //扫描到对应的号码时应该去触发receive
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet check_stock]
       parameters:@{@"package_id":data}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  
              }
              else{
                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                                 message:[NSString stringWithFormat:@"该商品未存在库存"]
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                  AudioServicesPlaySystemSound(1051);
                  [alert show];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
          }
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
