//
//  CreateMovementListItemViewController.m
//  Material
//
//  Created by ryan on 11/29/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "CreateMovementListItemViewController.h"
#import "UITextField+Extended.h"
#import "KeychainItemWrapper.h"
#import "Movement.h"
#import "DBManager.h"
#import "AFNetOperate.h"
#import "MovementAPI.h"

@interface CreateMovementListItemViewController ()
@property(strong, nonatomic) IBOutlet UITextField *toWhouseTextField;
@property(strong, nonatomic) IBOutlet UITextField *toPositionTextField;
@property(strong, nonatomic) IBOutlet UITextField *packageTextField;
@property(strong, nonatomic) IBOutlet UITextField *partIDTextField;
@property(strong, nonatomic) IBOutlet UITextField *qtyTextField;
@property(strong, nonatomic) IBOutlet UITextField *fromWhouseTextField;
@property(strong, nonatomic) IBOutlet UITextField *fromPositionTextField;

- (IBAction)createButtonClick:(id)sender;
@end

@implementation CreateMovementListItemViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  //  [self getPackageInfo:@"WI311501127113"];
  [self initController];
}

- (void)dismissKeyboard {
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

- (void)initController {
  // Do any additional setup after loading the view.
  self.toWhouseTextField.delegate = self;
  [self.toWhouseTextField becomeFirstResponder];
  self.toPositionTextField.delegate = self;
  self.packageTextField.delegate = self;
  self.qtyTextField.delegate = self;
  self.partIDTextField.delegate = self;
  self.fromPositionTextField.delegate = self;
  self.fromWhouseTextField.delegate = self;

  self.toWhouseTextField.nextTextField = self.toPositionTextField;
  self.toPositionTextField.nextTextField = self.packageTextField;
  self.packageTextField.nextTextField = self.qtyTextField;
  self.qtyTextField.nextTextField = self.partIDTextField;
  self.partIDTextField.nextTextField = self.fromWhouseTextField;
  self.fromWhouseTextField.nextTextField = self.fromPositionTextField;

  self.toWhouseTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
  self.toPositionTextField.inputView =
      [[UIView alloc] initWithFrame:CGRectZero];
  self.fromWhouseTextField.inputView =
      [[UIView alloc] initWithFrame:CGRectZero];
  self.fromPositionTextField.inputView =
      [[UIView alloc] initWithFrame:CGRectZero];
  self.packageTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
  self.partIDTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
  self.packageTextField.text = @"";
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  UITextField *next = textField.nextTextField;
  if (next) {
    [next becomeFirstResponder];
  } else {
    [textField resignFirstResponder];
  }
  return NO;
}

- (void)decoderDataReceived:(NSString *)data {
  NSArray *subviews = [self.view subviews];
  for (id objInput in subviews) {
    if ([objInput isKindOfClass:[UITextField class]]) {
      UITextField *tmpTextFile = objInput;
      if ([objInput isFirstResponder]) {
        tmpTextFile.text = data;
        if (tmpTextFile == self.packageTextField) {
          [self getPackageInfo:tmpTextFile.text];
        }
        [tmpTextFile resignFirstResponder];
        [tmpTextFile.nextTextField becomeFirstResponder];
        break;
      }
    }
  }
}

- (void)getPackageInfo:(NSString *)package_id {
  MovementAPI *api = [[MovementAPI alloc] init];
  [api getPackageInfo:package_id
             withView:self.view
                block:^(NSMutableArray *dataArray, NSError *error) {
                  if (error == nil) {
                    NSDictionary *dictData = [dataArray mutableCopy];
                    self.partIDTextField.text = [NSString
                        stringWithFormat:@"%@",
                                         [dictData objectForKey:@"part_id"]];
                    self.qtyTextField.text = [NSString
                        stringWithFormat:@"%@", [dictData objectForKey:@"qty"]];
                  }
                }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createButtonClick:(id)sender {
  if (self.toWhouseTextField.text.length > 0) {
    if (self.toPositionTextField.text.length > 0) {
      if (self.fromWhouseTextField.text.length > 0) {

        UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@""
                                       message:@"确认提交？"
                                      delegate:self
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@"确定", nil];
        [alert show];
      } else {
        UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@""
                                       message:@"请填写源仓库"
                                      delegate:self
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
        [alert show];
      }

    } else {
      UIAlertView *alert =
          [[UIAlertView alloc] initWithTitle:@""
                                     message:@"请填写进入位置"
                                    delegate:self
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil];
      [alert show];
    }
  } else {
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@""
                                   message:@"请填写进入仓库"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
    [alert show];
  }
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSString *strToWh = self.toWhouseTextField.text;
  NSString *strToPosition = self.toPositionTextField.text;
  NSString *strPackage = self.packageTextField.text;
  NSString *strQty = self.qtyTextField.text;
  NSString *strPartNr = self.partIDTextField.text;
  NSString *strFromWh = self.fromWhouseTextField.text;
  NSString *strFromPosition = self.fromPositionTextField.text;

  if (buttonIndex == 1) {

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]
        initWithObjectsAndKeys:self.movementListID, @"movement_list_id",
                               strToWh, @"toWh", strToPosition, @"toPosition",
                               strFromWh, @"fromWh", strFromPosition,
                               @"fromPosition", strQty, @"qty", strPartNr,
                               @"partNr", strPackage, @"packageId", nil];
    AFNetOperate *AFNet = [[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
    [manager POST:[AFNet ValidateMovement]
        parameters:dict
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [AFNet.activeView stopAnimating];
          if ([responseObject[@"result"] integerValue] == 1) {
            [AFNet alertSuccess:responseObject[@"content"]];
            [dict setValue:self.userName forKey:@"user"];
            Movement *movement = [[Movement alloc] initWithObject:dict];
            MovementAPI *api = [[MovementAPI alloc] init];
            [api createMovement:movement];
            [self clearData];
          } else {
            [AFNet alert:responseObject[@"content"]];
            NSLog(@"%@", responseObject[@"content"]);
          }

        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [AFNet.activeView stopAnimating];
          [AFNet
              alert:[NSString
                        stringWithFormat:@"%@", [error localizedDescription]]];
        }];
  }
}

- (void)clearData {
  NSArray *subviews = [self.view subviews];
  for (id objInput in subviews) {
    if ([objInput isKindOfClass:[UITextField class]]) {
      UITextField *theTextField = objInput;
      theTextField.text = @"";
    }
  }
  [self.toWhouseTextField becomeFirstResponder];
}

@end
