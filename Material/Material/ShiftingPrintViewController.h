//
//  ShiftingPrintViewController.h
//  Material
//
//  Created by ryan on 11/24/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiftingPrintViewController : UIViewController <UITextFieldDelegate>
- (IBAction)printAction:(id)sender;
@property(strong, nonatomic) IBOutlet UITextField *numberTextField;

@end
