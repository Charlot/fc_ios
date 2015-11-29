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
#import "UITextField+Extended.h"
#import "InventoryAPI.h"

@interface InventoryConfirmViewController () <CaptuvoEventsProtocol,
                                              UITextFieldDelegate>
@property(strong, nonatomic) IBOutlet UITextField *whouseidTextField;
@property(weak, nonatomic) IBOutlet UITextField *partTextField;
@property(weak, nonatomic) IBOutlet UITextField *positionTextField;
@property(weak, nonatomic) IBOutlet UITextField *qtyTextField;
@property(weak, nonatomic) IBOutlet UITextField *scanTextField;
- (IBAction)confirm:(id)sender;

@end

@implementation InventoryConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)initController {
  // Do any additional setup after loading the view.
  //    NSLog(@"pass inventory id is %d", self.inventroy_id);
  self.scanTextField.delegate = self;
  [self.scanTextField becomeFirstResponder];
  self.scanTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
  self.scanTextField.nextTextField = self.positionTextField;

  self.partTextField.delegate = self;
  self.partTextField.nextTextField = self.qtyTextField;
  self.partTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];

  self.qtyTextField.delegate = self;
  self.qtyTextField.nextTextField = self.positionTextField;

  self.positionTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];

  self.whouseidTextField.delegate = self;
}

- (void)loadData {
  self.partTextField.text = self.inventory_list_item.part_id;
  self.scanTextField.text = self.inventory_list_item.package_id;
  self.qtyTextField.text = self.inventory_list_item.qty;
  self.positionTextField.text = self.inventory_list_item.position;
  self.whouseidTextField.text = self.inventory_list_item.whouse_id;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initController];
  [self loadData];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
  NSArray *subviews = [self.view subviews];
  for (id objInput in subviews) {
    if ([objInput isKindOfClass:[UITextField class]]) {
      UITextField *theTextField = objInput;
      if ([objInput isFirstResponder]) {
        //                if (theTextField == self.scanTextField) {
        //                    NSLog(@"this is scanTextField");
        //                }
        [theTextField resignFirstResponder];
      }
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
  //  self.scanTextField.text = @"";
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}

- (void)postCheckStock:(NSString *)data {
  //扫描到对应的号码时应该去触发receive
  AFNetOperate *AFNet = [[AFNetOperate alloc] init];
  AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
  [manager POST:[AFNet check_stock]
      parameters:@{
        @"package_id" : data
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [AFNet.activeView stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
          [self.scanTextField resignFirstResponder];
          [self.positionTextField becomeFirstResponder];

        } else {
          UIAlertView *alert = [[UIAlertView alloc]
                  initWithTitle:@"系统提示"
                        message:[NSString stringWithFormat:
                                              @"该商品未存在库存"]
                       delegate:self
              cancelButtonTitle:@"确定"
              otherButtonTitles:nil];
          AudioServicesPlaySystemSound(1051);
          [alert show];
        }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AFNet.activeView stopAnimating];
        [AFNet alert:[NSString
                         stringWithFormat:@"%@", [error localizedDescription]]];
      }];
}

- (void)decoderDataReceived:(NSString *)data {
  //    if([self.scanTextField isFirstResponder])
  //    {
  //        self.scanTextField.text=data;
  //        [self postCheckStock:data];
  //    }
  //
  //    if ([self.positionTextField isFirstResponder]) {
  //       [self postData];
  //    }

  NSArray *subviews = [self.view subviews];
  for (id objInput in subviews) {
    if ([objInput isKindOfClass:[UITextField class]]) {
      UITextField *tmpTextFile = objInput;
      if ([objInput isFirstResponder]) {
        tmpTextFile.text = data;
        if (tmpTextFile == self.scanTextField) {
          NSLog(@"this is scanTextField");
          [self postCheckStock:data];
          break;
        }

        if (tmpTextFile == self.positionTextField) {
          NSLog(@"this is positionTextField");
          [self postData];
          break;
        }

        [tmpTextFile resignFirstResponder];
        [tmpTextFile.nextTextField becomeFirstResponder];
        break;
      }
    }
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if ((textField == self.scanTextField) || (textField == self.partTextField)
//            || (textField == self.qtyTextField)
//            || (textField == self.positionTextField)) {
//        [textField resignFirstResponder];
//    }
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

  UITextField *next = textField.nextTextField;
  if (next) {
    [next becomeFirstResponder];
  } else {
    [textField resignFirstResponder];
  }
  return NO;
}

- (IBAction)confirm:(id)sender {
  if (self.positionTextField.text.length > 0) {
    if (self.qtyTextField.text.length > 0 &&
        self.whouseidTextField.text.length > 0 &&
        self.partTextField.text.length > 0) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"确认提交？"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
      [alert show];

    } else {
      UIAlertView *alert =
          [[UIAlertView alloc] initWithTitle:@""
                                     message:@"请填写相关项"
                                    delegate:self
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil];
      [alert show];
    }

  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"请填写库位"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
  }
}

- (void)updateInventoryListItem {
  InventoryAPI *api = [[InventoryAPI alloc] init];
  [api UpdateInventoryListItem:self.inventory_list_item.ID
                  withWhouseID:self.whouseidTextField.text
                  withPosition:self.positionTextField.text
                       withQty:self.qtyTextField.text
                    withPartID:self.partTextField.text
                 withPackageID:self.scanTextField.text
                      withView:self.view
                         block:^(BOOL state, NSError *error) {
                           if (error == nil) {
                             if (state) {
                               [self.navigationController
                                   popViewControllerAnimated:YES];
                             }
                           }
                         }];
}

- (void)postData {
  NSString *package_id = self.scanTextField.text;
  NSString *part_id = self.partTextField.text;
  //    NSLog([NSString stringWithFormat:@"the part id is %@", part_id]);
  NSString *qty = self.qtyTextField.text;
  NSString *position = self.positionTextField.text;

  AFNetOperate *AFNet = [[AFNetOperate alloc] init];
  AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
  [manager POST:[AFNet inventory_list_item]
      parameters:@{
        @"package_id" : package_id,
        @"part_id" : part_id,
        @"qty" : qty,
        @"position" : position,
        @"inventory_list_id" : self.inventroy_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *subviews = [self.view subviews];
        for (id objInput in subviews) {
          if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            theTextField.text = @"";
          }
        }
        [self.scanTextField becomeFirstResponder];

        [AFNet.activeView stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {

          //                  [AFNet alert: [NSString
          //                  stringWithFormat:@"生成成功，且唯一码已入库"]];
          [AFNet alertSuccess:responseObject[@"content"]];

        } else if ([responseObject[@"result"] integerValue] == 2) {
          //                  [AFNet alert: [NSString
          //                  stringWithFormat:@"生成成功，且唯一码未入库"]];
          [AFNet alertSuccess:responseObject[@"content"]];

        } else {
          //                  [AFNet alert: [NSString
          //                  stringWithFormat:@"生成失败"]];
          [AFNet alert:responseObject[@"content"]];
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AFNet.activeView stopAnimating];
        [AFNet alert:[NSString
                         stringWithFormat:@"%@", [error localizedDescription]]];
      }];
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    //    [self postData];
    //    [self.navigationController popViewControllerAnimated:YES];
    [self updateInventoryListItem];
  }
}
@end
