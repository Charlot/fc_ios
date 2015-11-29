//
//  CreateMovementListItemViewController.h
//  Material
//
//  Created by ryan on 11/29/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateMovementListItemViewController
    : UIViewController <CaptuvoEventsProtocol, UITextFieldDelegate,
                        UIAlertViewDelegate>
@property NSString *movementListID;
@property NSString *userName;

@end
