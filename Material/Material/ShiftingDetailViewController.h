//
//  ShiftingDetailViewController.h
//  Material
//
//  Created by ryan on 11/19/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateMovementListItemViewController.h"

@class ShiftingDetailViewController;

@protocol ShiftingDetailViewControllerDelegate <NSObject>
- (void)backToYikuVC:(ShiftingDetailViewController *)viewController
      MovementListID:(NSString *)mlid;
- (void)failureToMain:(ShiftingDetailViewController *)viewController;
@end

@interface ShiftingDetailViewController
    : UIViewController <UITableViewDataSource, UITableViewDelegate,
                        CreateMovementListItemViewControllerDelegate>
@property(nonatomic, weak) id<ShiftingDetailViewControllerDelegate> delegate;

@property(nonatomic, strong) NSString *movement_list_id;
/**
 *  web or local
 */
@property(nonatomic, strong) NSString *fromState;
- (IBAction)MovementAction:(id)sender;
@end
