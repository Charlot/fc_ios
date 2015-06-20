//
//  YikuViewController.m
//  Material
//
//  Created by exmooncake on 15-6-18.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "YikuViewController.h"
#import "UITextField+Extended.h"

@interface YikuViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fromPositionTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromWhTextField;
@property (weak, nonatomic) IBOutlet UITextField *partNrTextField;
@property (weak, nonatomic) IBOutlet UITextField *qtyTextField;
@property (weak, nonatomic) IBOutlet UITextField *packageTextField;
@property (weak, nonatomic) IBOutlet UITextField *toPositionTextField;
@property (weak, nonatomic) IBOutlet UITextField *toWhTextField;
- (IBAction)confirmAction:(id)sender;

@end

@implementation YikuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initController
{
	// Do any additional setup after loading the view.
    self.toWhTextField.delegate = self;
    [self.toWhTextField becomeFirstResponder];
    self.toPositionTextField.delegate = self;
    self.packageTextField.delegate = self;
    self.qtyTextField.delegate = self;
    self.partNrTextField.delegate = self;
    self.fromPositionTextField.delegate = self;
    self.fromWhTextField.delegate = self;
    
    self.toWhTextField.nextTextField = self.toPositionTextField;
    self.toPositionTextField.nextTextField = self.packageTextField;
    self.packageTextField.nextTextField = self.qtyTextField;
    self.qtyTextField.nextTextField = self.partNrTextField;
    self.partNrTextField.nextTextField = self.fromWhTextField;
    self.fromWhTextField.nextTextField = self.fromPositionTextField;
    
    
    self.toWhTextField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    self.toPositionTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.fromWhTextField.inputView = [[UIView alloc] initWithFrame: CGRectZero];
    self.fromPositionTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    
    [self initController];
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
    self.packageTextField.text=@"";
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSInteger nextTag = textField.tag + 1;
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//    if (nextResponder) {
//        [nextResponder becomeFirstResponder];
//        NSLog(@"next resonder");
//    }
//    else
//    {
//        [textField resignFirstResponder];
//        NSLog(@"current textfield %d", textField.tag);
//    }
    
    UITextField *next = textField.nextTextField;
    if (next)
    {
        [next becomeFirstResponder];
        NSLog(@"next resonder");
    }
    else
    {
        [textField resignFirstResponder];
        NSLog(@"current textfield %d", textField.tag);
    }
    return NO;
}

-(void)decoderDataReceived:(NSString *)data
{
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                theTextField.text = data;
                [theTextField.nextTextField becomeFirstResponder];
            }
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmAction:(id)sender
{
    if (self.toWhTextField.text.length > 0)
    {
        if (self.toPositionTextField.text.length > 0)
        {

            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"确认提交？"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:@"请填写进入位置"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请填写进入仓库"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *strToWh = self.toWhTextField.text;
    NSString *strToPosition = self.toPositionTextField.text;
    NSString *strPackage = self.packageTextField.text;
    NSString *strQty = self.qtyTextField.text;
    NSString *strPartNr = self.partNrTextField.text;
    NSString *strFromWh = self.fromWhTextField.text;
    NSString *strFromPosition = self.fromPositionTextField.text;
    
    
    NSLog(@"CONFIRM");
            if(buttonIndex==1){
                
                NSArray *subviews = [self.view subviews];
//                int i =0 ;
                for (id objInput in subviews) {
                    if ([objInput isKindOfClass:[UITextField class]]) {
                        UITextField *theTextField = objInput;
                        theTextField.text = @"";
//                        NSLog(@"time is %d", i);
//                        i++;
                        
                    }
                }
                [self.toWhTextField becomeFirstResponder];
                

                AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                [manager POST:[AFNet move]
                   parameters:@{@"toWh": strToWh, @"toPosition": strToPosition, @"fromWh": strFromWh, @"fromPosition": strFromPosition, @"qty": strQty, @"partNr": strPartNr, @"uniqueId": @"", @"packageId": strPackage, @"fifo": @"" }
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          [AFNet.activeView stopAnimating];
                          if([responseObject[@"result"] integerValue]==1)
                          {
                              [AFNet alertSuccess:responseObject[@"content"]];
                          }
                          else
                          {
                              [AFNet alert:responseObject[@"content"]];
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [AFNet.activeView stopAnimating];
                          [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                      }
                 ];
            }
    

    
}

@end
