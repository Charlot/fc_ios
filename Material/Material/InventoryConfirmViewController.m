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
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *qtyTextField;
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
- (IBAction)confirm:(id)sender;

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.scanTextField) || (textField == self.partTextField)
            || (textField == self.qtyTextField)
            || (textField == self.positionTextField)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)confirm:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                              message:@"确认提交？"
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                                    otherButtonTitles:@"确定", nil];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *package_id = self.scanTextField.text;
    NSString *part_id = self.partTextField.text;
    NSLog([NSString stringWithFormat:@"the part id is %@", part_id]);
    NSString *qty = self.qtyTextField.text;
    NSString *position = self.positionTextField.text;
    
    if(buttonIndex==1){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet inventory_list_item]
           parameters:@{@"package_id": package_id, @"part_id": part_id, @"qty": qty, @"position": position, @"inventory_list_id": self.inventroy_id}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      
                      [AFNet alert: [NSString stringWithFormat:@"生成成功，且唯一码已入库"]];

                                        }
                  else if([responseObject[@"result"] integerValue] == 2){
                      [AFNet alert: [NSString stringWithFormat:@"生成成功，且唯一码未入库"]];
                      
                  }
                  else{
                      [AFNet alert: [NSString stringWithFormat:@"生成失败"]];

                  }
                  NSLog(@"the result is %@", responseObject[@"result"]);

              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
                  [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
              }
         ];
    }
}
@end
