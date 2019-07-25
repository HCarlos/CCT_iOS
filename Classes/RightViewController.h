//
//  RightViewController.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/28/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "SplashVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RightViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtom;
@property (nonatomic, strong) NSArray *arrSegue;
@property (strong, nonatomic) Singleton *Singleton;
@property (strong, nonatomic) IBOutlet UIView *vista;
@property (weak, nonatomic) IBOutlet UIButton *btnDN;
@property (weak, nonatomic) IBOutlet UIButton *btnDA;

@property (nonatomic) UIViewAnimationOptions animation1;
@property (nonatomic) UIViewAnimationOptions animation2;

- (IBAction)btnDN:(id)sender;
- (IBAction)btnDA:(id)sender;



@end

NS_ASSUME_NONNULL_END
