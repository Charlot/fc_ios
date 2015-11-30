//
//  CreateMovementListItemViewController.h
//  Material
//
//  Created by ryan on 11/29/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateMovementListItemViewController;
@protocol CreateMovementListItemViewControllerDelegate <NSObject>

- (void)backToShiftingDetail:
            (CreateMovementListItemViewController *)viewController
              MovementListID:(NSString *)mlid;

@end

@interface CreateMovementListItemViewController
    : UIViewController <CaptuvoEventsProtocol, UITextFieldDelegate,
                        UIAlertViewDelegate>
@property(nonatomic, weak)
    id<CreateMovementListItemViewControllerDelegate> delegate;

@property NSString *movementListID;
@property NSString *userName;

@end
