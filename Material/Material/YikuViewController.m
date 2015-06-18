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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initController];
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
    self.packageTextField.text=data;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmAction:(id)sender {
}
@end
