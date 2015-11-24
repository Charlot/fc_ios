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
  // Do any additional setup after loading the view.
}

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
  [self verifyText];
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
