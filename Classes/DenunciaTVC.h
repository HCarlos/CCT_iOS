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
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h> 
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DenunciaTVC : UITableViewController<UITableViewDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate,  UIVideoEditorControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate>

@property (nonatomic, retain) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, retain) NSURLSession *session;
//@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic, retain) NSMutableData *dataToDownload;
@property (nonatomic) float downloadSize;

@property (nonatomic, strong) NSMutableArray *opciones;
@property (nonatomic, strong) NSArray *arrSegue;
@property (nonatomic, strong) NSArray *arrTitlePopup;
@property (nonatomic, strong) UIAlertController *alertController;
@property (strong, nonatomic) Singleton *Singleton;
@property (nonatomic) int IdTipoDenuncia;
@property (nonatomic) int TipoDateTime;
@property (nonatomic) int TypeMedia;

// Varios
-(void)HideKeyBoard;
-(void)setAccesory;


@property (strong, nonatomic) IBOutlet UITableView *tblDenPer;

// Primera Sección
@property (weak, nonatomic) IBOutlet UITextField *txtTipoGobierno;
@property (weak, nonatomic) IBOutlet UITextField *txtMunicipio;
@property (weak, nonatomic) IBOutlet UITextField *txtDependencia;
@property (weak, nonatomic) IBOutlet UITextField *txtArea;

// Segunda Sección
@property (weak, nonatomic) IBOutlet UITextField *txtApp;
@property (weak, nonatomic) IBOutlet UITextField *txtApm;
@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtEMail;
@property (weak, nonatomic) IBOutlet UITextField *txtCelular;

// Tercera Sección
@property (weak, nonatomic) IBOutlet UITextField *txtFecha;
@property (weak, nonatomic) IBOutlet UITextField *txtHora;

// Cuarta sección
//@property (weak, nonatomic) IBOutlet UITextView *txtLugarHechos;
@property (weak, nonatomic) IBOutlet UITextView *txtLugarHechos;

// Quinta sección
//@property (weak, nonatomic) IBOutlet UITextView *txtHechos;
@property (weak, nonatomic) IBOutlet UITextView *txtHechos;

// Sexta sección
@property (weak, nonatomic) IBOutlet UIImageView *imgArchivo;
- (IBAction)btnSegueImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

//Métodos
- (void) selectDate;
- (void) selectTime;


//Acciones
- (IBAction)btnGetTipoGobierno:(id)sender;
- (IBAction)btnMunicipios:(id)sender;
- (IBAction)btnGetDependencias:(id)sender;
- (IBAction)btnArea:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSubirArchivo;

- (IBAction)btnSubirArchivo:(id)sender;

// Metodos

-(void)AlertSimple:(NSString *) mensaje Tipo:(int)tipo;







@property (weak, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSend:(id)sender;

//-(BOOL)textFieldShouldReturn:(UITextField*)textField;

@end

NS_ASSUME_NONNULL_END
