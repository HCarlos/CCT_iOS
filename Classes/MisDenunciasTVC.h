//
//  MisDenunciasTableViewController.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 7/3/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MisDenunciasTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnRefresh;

- (IBAction)btnRefresh:(id)sender;

@end

NS_ASSUME_NONNULL_END
