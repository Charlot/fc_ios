//
//  YikuViewController.m
//  Material
//
//  Created by exmooncake on 15-6-18.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "YikuViewController.h"
#import "UITextField+Extended.h"
#import "KeychainItemWrapper.h"
#import "Movement.h"
#import "DBManager.h"
#import "ShiftingDetailViewController.h"
#import "MovementAPI.h"

@interface YikuViewController ()
@property(weak, nonatomic) IBOutlet UITextField *fromPositionTextField;
@property(weak, nonatomic) IBOutlet UITextField *fromWhTextField;
@property(weak, nonatomic) IBOutlet UITextField *partNrTextField;
@property(weak, nonatomic) IBOutlet UITextField *qtyTextField;
@property(weak, nonatomic) IBOutlet UITextField *packageTextField;
@property(weak, nonatomic) IBOutlet UITextField *toPositionTextField;
@property(weak, nonatomic) IBOutlet UITextField *toWhTextField;
@property(nonatomic, strong) UIAlertView *backAlertView;

@property(nonatomic, strong) Movement *movement;
@property NSString *userName;
- (IBAction)confirmAction:(id)sender;

@end

@implementation YikuViewController

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
  self.packageTextField.nextTextField = self.partNrTextField;
  self.partNrTextField.nextTextField = self.qtyTextField;
  self.qtyTextField.nextTextField = self.fromWhTextField;
  self.fromWhTextField.nextTextField = self.fromPositionTextField;

  self.toWhTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
  self.toPositionTextField.inputView =
      [[UIView alloc] initWithFrame:CGRectZero];
  self.fromWhTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
  self.fromPositionTextField.inputView =
      [[UIView alloc] initWithFrame:CGRectZero];
  self.packageTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
  self.partNrTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];

  //    [self.toWhTextField addTarget:self action:@selector(textFieldDidChange:)
  //    forControlEvents:UIControlEventAllEditingEvents];
  //
  //    [self.toPositionTextField addTarget:self
  //    action:@selector(textFieldDidChange:)
  //    forControlEvents:UIControlEventAllEditingEvents];
  //
  //    [self.packageTextField addTarget:self
  //    action:@selector(textFieldDidChange:)
  //    forControlEvents:UIControlEventAllEditingEvents];}

  self.navigationItem.hidesBackButton = YES;
  UIBarButtonItem *cancelShifting =
      [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                       style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(popBack)];
  self.navigationItem.leftBarButtonItem = cancelShifting;
}

- (void)popBack {
  NSLog(@"this is back");

  [self.backAlertView show];
  //  [self.navigationController popViewControllerAnimated:YES];
}

// Just For testing
//- (void)textFieldDidChange:(UITextField *)theTextField
//{
//
//
//    NSArray *subviews = [self.view subviews];
//    for (id objInput in subviews) {
//        if ([objInput isKindOfClass:[UITextField class]]) {
//            UITextField *tmpTextFile = objInput;
//            if ([objInput isFirstResponder]) {
////                tmpTextFile.text = data;
//                [tmpTextFile.nextTextField becomeFirstResponder];
//
//                NSLog( @"text changed: %@", theTextField.text);
//                break;
//            }
//        }
//    }
//}

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

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.backAlertView =
      [[UIAlertView alloc] initWithTitle:@""
                                 message:@"是否取消此次移库？"
                                delegate:self
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:@"取消", nil];
  self.userName = @"";
  KeychainItemWrapper *keyChain =
      [[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                          accessGroup:nil];
  if ([keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
    self.userName = [NSString
        stringWithFormat:@"%@",
                         [keyChain objectForKey:(__bridge id)kSecAttrAccount]];
  }
  self.movement = [[Movement alloc] init];

  //  if (self.MovementID.length == 0) {
  //    [self createIDMovement];
  //  }
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
  if (next) {
    [next becomeFirstResponder];
    NSLog(@"next resonder");
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
//          验证唯一码
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
  [api
      getNStoragePackageInfo:package_id
                    withView:self.view
                       block:^(NSMutableArray *dataArray, NSError *error) {
                         if (error == nil) {
                           NSDictionary *dictData = [dataArray mutableCopy];
                           self.partNrTextField.text = [NSString
                               stringWithFormat:@"%@",
                                                [dictData
                                                    objectForKey:@"part_id"]];
                           self.qtyTextField.text = [NSString
                               stringWithFormat:@"%@",
                                                [dictData objectForKey:@"qty"]];
                             
                             self.fromWhTextField.text = [NSString
                                                          stringWithFormat:@"%@",
                                                          [dictData
                                                           objectForKey:@"fromWh"]];
                             self.fromPositionTextField.text = [NSString
                                                       stringWithFormat:@"%@",
                                                       [dictData objectForKey:@"fromPosition"]];
                             
                           [self.partNrTextField resignFirstResponder];
//                           [self.fromWhTextField becomeFirstResponder];
                         }
                       }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)confirmAction:(id)sender {
  if (self.toWhTextField.text.length > 0) {
    if (self.toPositionTextField.text.length > 0) {
      if (self.fromWhTextField.text.length > 0) {

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
  if (alertView == self.backAlertView) {
    if (buttonIndex == 0) {
      MovementAPI *api = [[MovementAPI alloc] init];
      [api deleteMovementList:self.movementListID
                     withView:self.view
                        block:^(NSString *contentString, NSError *error) {
                          if (error == nil) {
                            [self.navigationController
                                popViewControllerAnimated:NO];
                          } else {
                            [self.navigationController
                                popViewControllerAnimated:NO];
                          }
                        }];
    }
  } else {
    NSString *strToWh = self.toWhTextField.text;
    NSString *strToPosition = self.toPositionTextField.text;
    NSString *strPackage = self.packageTextField.text;
    NSString *strQty = self.qtyTextField.text;
    NSString *strPartNr = self.partNrTextField.text;
    NSString *strFromWh = self.fromWhTextField.text;
    NSString *strFromPosition = self.fromPositionTextField.text;
    //    strToWh = @"3EX";
    //    strToPosition = @"SCT 28 03 01";
    //    strPackage = @"rwwe";
    //    strFromWh = @"3EX";
    //    strPartNr = @"411000895";
    if (buttonIndex == 1) {

      NSMutableDictionary *dict = [[NSMutableDictionary alloc]
          initWithObjectsAndKeys:self.movementListID, @"movement_list_id",
                                 strToWh, @"toWh", strToPosition, @"toPosition",
                                 strFromWh, @"fromWh", strFromPosition,
                                 @"fromPosition", strQty, @"qty", strPartNr,
                                 @"partNr", strPackage, @"packageId", nil];
      AFNetOperate *AFNet = [[AFNetOperate alloc] init];
      AFHTTPRequestOperationManager *manager =
          [AFNet generateManager:self.view];
      [manager POST:[AFNet ValidateMovement]
          parameters:dict
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AFNet.activeView stopAnimating];
            if ([responseObject[@"result"] integerValue] == 1) {
              [AFNet alertSuccess:responseObject[@"content"]];
              [dict setValue:self.userName forKey:@"user"];
              self.movement = [[Movement alloc] initWithObject:dict];
              //              [self createMovement:self.movement];
              [self clearData];
            } else {
              [AFNet alert:responseObject[@"content"]];
              NSLog(@"%@", responseObject[@"content"]);
            }

          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AFNet.activeView stopAnimating];
            [AFNet
                alert:[NSString stringWithFormat:@"%@",
                                                 [error localizedDescription]]];
          }];

      /*
       1.0 原来代码
       */

      //      AFNetOperate *AFNet = [[AFNetOperate alloc] init];
      //      AFHTTPRequestOperationManager *manager =
      //          [AFNet generateManager:self.view];
      //      [manager POST:[AFNet move]
      //          parameters:@{
      //            @"movement_list_id": self.MovementID,
      //            @"toWh" : strToWh,
      //            @"toPosition" : strToPosition,
      //            @"fromWh" : strFromWh,
      //            @"fromPosition" : strFromPosition,
      //            @"qty" : strQty,
      //            @"partNr" : strPartNr,
      //            @"uniqueId" : @"",
      //            @"packageId" : strPackage,
      //            @"fifo" : @""
      //          }
      //          success:^(AFHTTPRequestOperation *operation, id
      //          responseObject) {
      //            [AFNet.activeView stopAnimating];
      //            if ([responseObject[@"result"] integerValue] == 1) {
      //              [AFNet alertSuccess:responseObject[@"content"]];
      //            } else {
      //              [AFNet alert:responseObject[@"content"]];
      //            }
      //
      //          }
      //          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      //            [AFNet.activeView stopAnimating];
      //            [AFNet
      //                alert:[NSString stringWithFormat:@"%@",
      //                                                 [error
      //                                                 localizedDescription]]];
      //          }];
    }
  }
}

- (void)clearData {
  NSArray *subviews = [self.view subviews];
  //                int i =0 ;
  for (id objInput in subviews) {
    if ([objInput isKindOfClass:[UITextField class]]) {
      UITextField *theTextField = objInput;
        if (theTextField.tag == self.toWhTextField.tag || theTextField.tag == self.toPositionTextField.tag ) {
        }else{
      theTextField.text = @"";
        }
      //                        NSLog(@"time is %d", i);
      //                        i++;
    }
  }
  [self.packageTextField becomeFirstResponder];
}

///**
// *  获取移库清单号
// */
//- (void)createIDMovement {
//
//  AFNetOperate *AFNet = [[AFNetOperate alloc] init];
//  AFHTTPRequestOperationManager *manager = [AFNet generateManager:self.view];
//  [manager POST:[AFNet CreateMovementList]
//      parameters:@{
//        @"user_id" : self.userName,
//        @"remarks" : @""
//      }
//      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"the request %@", responseObject);
//        [AFNet.activeView stopAnimating];
//        if ([responseObject[@"result"] integerValue] == 1) {
//
//          NSDictionary *dic = responseObject[@"content"];
//          self.MovementID = [dic objectForKey:@"id"];
//          NSLog(@"the movement id is %@", self.MovementID);
//        } else {
//          [AFNet alert:responseObject[@"content"]];
//        }
//
//      }
//      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [AFNet.activeView stopAnimating];
//        NSLog(@"%@", error.description);
//        [AFNet alert:[NSString
//                         stringWithFormat:@"%@", [error
//                         localizedDescription]]];
//      }];
//}

/**
 *  sqlite3 存储 movenment
 *
 *  @param m m description
 */
- (void)createMovement:(Movement *)m {

  NSString *query;
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *created_at = [NSString
      stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];

  query = [NSString
      stringWithFormat:
          @"insert into movements (toWh, "
          @"toPosition, fromWh, fromPosition, packageId, partNr, "
          @"qty, movement_list_id, user, "
          @"created_at) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', "
          @"'%@', '%@')",
          m.toWh, m.toPosition, m.fromWh, m.fromPosition, m.packageId, m.partNr,
          m.qty, m.movement_list_id, m.user, created_at];
  NSLog(@"===== query is %@", query);
  DBManager *db = [[DBManager alloc] initWithDatabaseFilename:@"wmsdb.sql"];
  [db executeQuery:query];
  if (db.affectedRows != 0) {
    [self clearData];
    NSLog(@"操作成功");
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toMovementListDetailVC"]) {
    //        for push
    ShiftingDetailViewController *detail = segue.destinationViewController;
    detail.movement_list_id = self.movementListID;
    detail.delegate = self;
    detail.fromState = @"local";
    //    for modal
    //    UINavigationController *navigationController =
    //        segue.destinationViewController;
    //    ShiftingDetailViewController *detailController =
    //        [[navigationController viewControllers] objectAtIndex:0];
    //
    //    detailController.movement_list_id = self.movementListID;
    //    detailController.delegate = self;
    //    NSLog(@"the send movement list id %@", self.movementListID);
  }
}

#pragma mark shiftingdetail delegate
- (void)backToYikuVC:(ShiftingDetailViewController *)viewController
      MovementListID:(NSString *)mlid {
  self.movementListID = mlid;
  NSLog(@"the back movement list id %@", mlid);
  //  [self dismissViewControllerAnimated:YES completion:nil];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)failureToMain:(ShiftingDetailViewController *)viewController {
  //    self dismissViewControllerAnimated:<#(BOOL)#>
  //    completion:<#^(void)completion#>
  [self dismissViewControllerAnimated:YES completion:nil];

  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)MovementListReviewAction:(id)sender {
  [self performSegueWithIdentifier:@"toMovementListDetailVC" sender:self];
}
@end
