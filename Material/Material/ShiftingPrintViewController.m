//
//  ShiftingPrintViewController.m
//  Material
//
//  Created by ryan on 11/24/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "ShiftingPrintViewController.h"
#import "MovementAPI.h"

@interface ShiftingPrintViewController ()

@end

@implementation ShiftingPrintViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.hidesBackButton = YES;
}
// Do any additional setup after loading the view.
//  [self.navigationItem.backBarButtonItem setEnabled:NO];
//  self.navigationItem.leftBarButtonItem =
//      [[UIBarButtonItem alloc] initWithTitle:@"返回"
//                                       style:UIBarButtonItemStylePlain
//                                      target:self
//                                      action:@selector(done:)];
//  [self.navigationItem.leftBarButtonItem setEnabled:NO];
//}
//
//- (void)done:(id)sender {
//  //  [self dismissViewControllerAnimated:YES completion:nil];
//  [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

- (IBAction)printAction:(id)sender {
  [[[UIActionSheet alloc] initWithTitle:@"是否打印"
                               delegate:self
                      cancelButtonTitle:@"返回移库清单"
                 destructiveButtonTitle:nil
                      otherButtonTitles:@"确定", nil] showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    [self performSegueWithIdentifier:@"toHistoryVC" sender:self];
    NSLog(@"click cancel");
  } else {
    [self verifyText];
    NSLog(@"click yes");
  }
}

- (void)verifyText {
    
  if (self.numberTextField.text.length > 0) {
    MovementAPI *api = [[MovementAPI alloc] init];
    [api printAction:self.movement_list_id
              copies:self.numberTextField.text
             optView:self.view
               block:^(NSString *content, NSError *error) {
                 if (error == nil) {
                   [self performSegueWithIdentifier:@"toHistoryVC" sender:self];
                 }
               }];
  } else {
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@""
                                   message:@"请填写打印份数"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil];
    [alert show];
  }
}

@end
