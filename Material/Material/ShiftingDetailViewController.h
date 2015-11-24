//
//  ShiftingDetailViewController.h
//  Material
//
//  Created by ryan on 11/19/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShiftingDetailViewController;

@protocol ShiftingDetailViewControllerDelegate <NSObject>
- (void)backToYikuVC:(ShiftingDetailViewController *)viewController
      MovementListID:(NSString *)mlid;
- (void)failureToMain:(ShiftingDetailViewController *)viewController;
@end

@interface ShiftingDetailViewController
    : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) id<ShiftingDetailViewControllerDelegate> delegate;

@property(nonatomic, strong) NSString *movement_list_id;
- (IBAction)MovementAction:(id)sender;
@end
