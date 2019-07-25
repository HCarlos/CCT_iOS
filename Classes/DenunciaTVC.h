//
//  DenunciaPersonalTableViewController.h
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/28/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "Opciones.h"
#import "PopupVCViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DenunciaTVC : UITableViewController<UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *opciones;
@property (nonatomic, strong) NSArray *arrSegue;
@property (strong, nonatomic) Singleton *Singleton;

// Varios
-(void)HideKeyBoard;
-(void)setAccesory;


@property (strong, nonatomic) IBOutlet UITableView *tblDenPer;

// Primer Bloque

// segundo Bloque
@property (weak, nonatomic) IBOutlet UITextField *txtApp;
@property (weak, nonatomic) IBOutlet UITextField *txtApm;
@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtEMail;
@property (weak, nonatomic) IBOutlet UITextField *txtFecNac;
- (void) selectDate;

//Viculos al VC
@property (weak, nonatomic) IBOutlet UITextField *txtTipoGobierno;
@property (weak, nonatomic) IBOutlet UITextField *txtMunicipio;
@property (weak, nonatomic) IBOutlet UITextField *txtDependencia;


- (IBAction)btnGetTipoGobierno:(id)sender;
- (IBAction)btnMunicipios:(id)sender;
- (IBAction)btnGetDependencias:(id)sender;



// Metodos









@property (weak, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSend:(id)sender;

-(BOOL)textFieldShouldReturn:(UITextField*)textField;

@end

NS_ASSUME_NONNULL_END
