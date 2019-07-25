//
//  PopupVCViewController.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 7/4/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opciones.h"
#import "Singleton.h"


NS_ASSUME_NONNULL_BEGIN
@class PopupVCViewController;

@protocol PopupVCDelegate
    -(void)cerrarVentana;
    -(void)key:(int)key value:(NSString*)value;
@end

@interface PopupVCViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id <PopupVCDelegate> delegate;
@property (nonatomic) int Key;
@property(nonatomic, retain) NSString    *Value;
@property (nonatomic) int IdTarget;

@property (nonatomic, strong) NSMutableArray *opciones;
@property (strong, nonatomic) Singleton *Singleton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

@property (weak, nonatomic) IBOutlet UIView *PopupVC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnCloseVC;
- (IBAction)btnCloseVC:(id)sender;

-(void)getCallDatos;

-(void)getTipoGobierno;
-(void)getDataOptions:(NSString *)Url;

-(void)setDataReturn;

@end



NS_ASSUME_NONNULL_END
