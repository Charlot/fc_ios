//
//  InventorySettingViewController.m
//  Material
//
//  Created by exmooncake on 15-6-13.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "InventorySettingViewController.h"
#import "AFNetOperate.h"
#import "PrinterSetting.h"
#import <AudioToolbox/AudioToolbox.h>

@interface InventorySettingViewController () <UITextFieldDelegate>
- (IBAction)logout:(id)sender;
@property(strong, nonatomic) IBOutlet UITextField *addressTextField;
@property(strong, nonatomic) IBOutlet UITextField *portTextField;
@property(strong, nonatomic) IBOutlet UITextField *modelTextField;
@property(strong, nonatomic) UIPickerView *typePicker;
@property(strong, nonatomic) NSArray *pickerElements;
@property(strong, nonatomic) PrinterSetting *printerSetting;
- (IBAction)resetModel:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)touchScreen:(id)sender;

@end

@implementation InventorySettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

#pragma pick view delegate
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (int)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component {
  return [self.pickerElements count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  return [self.pickerElements objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  self.modelTextField.text = [self.pickerElements objectAtIndex:row];
}

/**
 *  初始化控件 载入数据
 */
- (void)customController {
  self.addressTextField.delegate = self;
  self.portTextField.delegate = self;
  self.modelTextField.delegate = self;
  self.typePicker = [[UIPickerView alloc] init];
  self.typePicker.delegate = self;
  self.typePicker.dataSource = self;
  self.typePicker.showsSelectionIndicator = YES;
  self.modelTextField.inputView = self.typePicker;
  self.printerSetting = [PrinterSetting sharedPrinterSetting];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customController];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
  AFNetOperate *AFNet = [[AFNetOperate alloc] init];
  AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
  [manager DELETE:[AFNet log_out]
      parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [AFNet.activeView stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
          [self dismissViewControllerAnimated:YES completion:nil];
        } else {
          [AFNet alert:responseObject[@"content"]];
        }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AFNet.activeView stopAnimating];
        [AFNet alert:[NSString
                         stringWithFormat:@"%@", error.localizedDescription]];
      }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  NSArray *documentDictionary = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *document = [documentDictionary firstObject];
  NSString *path =
      [document stringByAppendingPathComponent:@"print.ip.address.archive"];
  if ([NSKeyedUnarchiver unarchiveObjectWithFile:path]) {
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.addressTextField.text = [dictionary objectForKey:@"print_ip"]
                                     ? [dictionary objectForKey:@"print_ip"]
                                     : @"";
    self.portTextField.text = [dictionary objectForKey:@"print_port"]
                                  ? [dictionary objectForKey:@"print_port"]
                                  : @"";
  } else {
    NSString *plistPath =
        [[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    NSMutableDictionary *URLDictionary =
        [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *printAddress = [URLDictionary objectForKey:@"print"];
    self.addressTextField.text = [printAddress objectForKey:@"base"];
    self.portTextField.text = [printAddress objectForKey:@"port"];
  }
  self.modelTextField.text = [self.printerSetting getPrinterModel];
  self.pickerElements = [self.printerSetting get_all_printer_model];
  [self.typePicker reloadAllComponents];
}

- (IBAction)resetModel:(id)sender {
  [self.printerSetting resetPrinterModel];
  self.modelTextField.text = @"";
}

- (IBAction)saveAction:(id)sender {
  NSDictionary *dictionary = [NSDictionary
      dictionaryWithObjectsAndKeys:self.addressTextField.text, @"print_ip",
                                   self.portTextField.text, @"print_port", nil];
  NSArray *documentDictionary = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *document = [documentDictionary firstObject];
  NSString *path =
      [document stringByAppendingPathComponent:@"print.ip.address.archive"];
  [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
  if (self.modelTextField.text.length > 0) {
    [self.printerSetting setPrinterModel:self.modelTextField.text];
  }
  [self.addressTextField resignFirstResponder];
  [self.portTextField resignFirstResponder];
  [self.modelTextField resignFirstResponder];
  AudioServicesPlaySystemSound(1012);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                  message:@"设置成功"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil];
  [NSTimer
      scheduledTimerWithTimeInterval:1.0f
                              target:self
                            selector:@selector(dismissAlert:)
                            userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       alert, @"alert", nil]
                             repeats:NO];
  [alert show];
}

- (IBAction)touchScreen:(id)sender {
  [self.addressTextField resignFirstResponder];
  [self.portTextField resignFirstResponder];
  [self.modelTextField resignFirstResponder];
}

- (void)dismissAlert:(NSTimer *)timer {
  UIAlertView *alert = [[timer userInfo] objectForKey:@"alert"];
  [alert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
