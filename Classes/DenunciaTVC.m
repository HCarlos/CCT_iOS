//
//  DenunciaPersonalTableViewController.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 6/28/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "DenunciaTVC.h"
#import "Opciones.h"
#import "Singleton.h"
#import "PopupVCViewController.h"
#import "VerImagenVC.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreLocation/CoreLocation.h>

@interface DenunciaTVC () <PopupVCDelegate>
@end

@implementation DenunciaTVC{
    CLLocationManager *locationManager;
}
@synthesize arrSegue, arrTitlePopup, opciones, IdTipoDenuncia, Singleton, txtTipoGobierno, txtMunicipio, txtDependencia;
@synthesize alertController, TipoDateTime, TypeMedia;
@synthesize dataToDownload, downloadSize, progressBar, sessionConfiguration, session;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    self->locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self->locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self->locationManager requestAlwaysAuthorization] ;
        [self->locationManager requestWhenInUseAuthorization];
    }
    [self->locationManager startUpdatingLocation];
    
    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration: self.sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];

    [self.Indicator setHidden:YES];
    [self.Indicator hidesWhenStopped];
    

    self.Singleton  = [Singleton sharedMySingleton];
    [self.Singleton setPlist];
    
    [self limpiarSingleton];

    self.IdTipoDenuncia = [self.Singleton getIdTipoDenuncia];
    [self setTitle:self.IdTipoDenuncia == 0 ? @"Denuncia Normal" : @"Denuncia Anónima"];

    [self setAccesory];
    
    //[self textViewDidChange:self.txtLugarHechos];
    
    [self initDate];
    [self initTime];

    [self selectDate];
    [self selectTime];
    
    self.arrSegue      = [NSArray arrayWithObjects:@"Child0",@"Municipios",@"DependenciaGobierno",@"Areas", nil];
    self.arrTitlePopup = [NSArray arrayWithObjects:@"un Tipo de Gobierno",@"un Municipio",@"una Dependencia",@" una Subdependencia ó Area", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateInputCallback:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)aTextField
{
    return [self validateInputWithString:aTextField.text];
}

- (BOOL)validateInputWithString:(NSString *)aString
{
    NSString * const regularExpression = @"^([+-]{1})([0-9]{3})$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:aString
                                                        options:0
                                                          range:NSMakeRange(0, [aString length])];
    return numberOfMatches > 0;
}

- (void)validateInputCallback:(id)sender
{
    if ([self validateInputWithString:self.txtCelular.text]) {
        [self.txtCelular becomeFirstResponder];
    }
}

#pragma Se habilita de Fecha
- (void) initDate{
    NSDate *aGo = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    self.txtFecha.text = [dateFormatter stringFromDate:aGo];
}

- (void) initTime{
    NSDate *aGo = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"h:mm a"];
    self.txtHora.text = [dateFormatter stringFromDate:aGo];
}

- (void) selectDate{
    self.TipoDateTime = 0;
    UIDatePicker* datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"es"]];
    [datePicker addTarget:self action:@selector(updateDate:) forControlEvents:UIControlEventValueChanged];
    [self.txtFecha setInputView:datePicker];
}

- (void) selectTime{
    self.TipoDateTime = 1;
    UIDatePicker* datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"es"]];
    [datePicker addTarget:self action:@selector(updateTime:) forControlEvents:UIControlEventValueChanged];
    [self.txtHora setInputView:datePicker];
}

- (NSString *)formatDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (NSString *)formatTime:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

-(void)updateDate:(id)sender{
    UIDatePicker* datePicker = (UIDatePicker*) self.txtFecha.inputView;
    self.txtFecha.text = [self formatDate:datePicker.date];
}

-(void)updateTime:(id)sender{

    UIDatePicker* datePicker = (UIDatePicker*) self.txtHora.inputView;
    self.txtHora.text = [self formatTime:datePicker.date];
}

//
//#pragma Modifica el Text Leng wrap
//- (void)textViewDidChange:(UITextView *)textView
//{
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    textView.frame = newFrame;
//    
//    
//    CGRect viewFrame = self.txtLugarHechos.frame;
//    viewFrame.size.height = self.txtLugarHechos.frame.size.height;
//    viewFrame.origin.y= self.txtLugarHechos.frame.size.height-30;
//    self.txtLugarHechos.frame = viewFrame;
//    
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 8, 320, 20);
    //label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(-1.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = sectionTitle;
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat height = 0.0;
    int tg = self.Singleton.IdTipoGobierno;
    int mu = self.Singleton.IdMunicipio;
    int de = self.Singleton.IdDependencia;
    
    NSInteger row = indexPath.row;
    NSInteger sec = indexPath.section;
    if (sec == 0){
        if (row >= 0 && row <=3){
            if (tg == 0 && row == 0)
                height = 80;
            else if (tg == 2 && (row == 0 || row == 1 ) && mu <= 0)
                height = 80;
            else if (tg == 2 && (row == 0 || row == 1 || row == 2 ) && mu > 0)
                height = 80;
            else if (tg == 2 && (row == 0 || row == 1 || row == 2 || row == 3) && de > 0)
                height = 80;

            else if (tg == 1 && (row == 0 || row == 2 ))
                height = 80;
            else if (tg == 1 && (row == 0 || row == 2 ) && de <= 0)
                height = 80;
            else if (tg == 1 && (row == 0 || row == 2 || row == 3 ) && de > 0)
                height = 80;


        }
    }else if (sec == 1 && self.IdTipoDenuncia == 1){
           height = 0.0;
    }else if (sec == 3){
        height = 160;
    }else if (sec == 4){
        height = 240;
    }else if (sec == 5){
        height = 140;
    }else{
        height = 80;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 44;
    if (section == 1 && self.IdTipoDenuncia == 1)
        height = 0.1;
    return height;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"DEPEDENCIAS DE GOBIERNO";
            break;
        case 1:
            sectionName = self.IdTipoDenuncia == 0 ? @"DATOS GENERALES" : @"";
            break;
        case 2:
            sectionName = @"CUÁNDO SUCEDIERON LOS HECHOS?";
            break;
        case 3:
            sectionName = @"LUGAR DONDE OCURRIERON LOS HECHOS *";
            break;
        case 4:
            sectionName = @"ESCRIBE TU DENUNCIA *";
            break;
        case 5:
            sectionName = @"ARCHIVO";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:arrSegue[ [self.Singleton getIdTarget] ]]) {
        PopupVCViewController *mvc = (PopupVCViewController *) segue.destinationViewController;
        mvc.IdTarget = [self.Singleton getIdTarget];
        NSString *lblTitle = @"Seleccione ";
        mvc.Titulo = [lblTitle stringByAppendingString: self.arrTitlePopup[ [self.Singleton getIdTarget] ] ] ;
        [mvc setDelegate:self];
    }
    
    if ([[segue identifier] isEqualToString:@"verImagen"]) {
        VerImagenVC *mvc = (VerImagenVC *) segue.destinationViewController;
        mvc.imagen = self.imgArchivo.image;
    }
}

#pragma Métodos del Protocolo
-(void)cerrarVentana{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)key:(int)key value:(NSString*)value{
    
    switch( [self.Singleton getIdTarget] ){
    case 0:
        self.Singleton.IdTipoGobierno = key;
        self.txtTipoGobierno.text = value;

        self.Singleton.IdMunicipio = 0;
        self.txtMunicipio.text = @"";
            
        self.Singleton.IdDependencia = 0;
        self.txtDependencia.text = @"";
        
        self.Singleton.IdArea = 0;
        self.txtArea.text = @"";

        break;
            
    case 1:
        self.Singleton.IdMunicipio = key;
        self.txtMunicipio.text = value;

        self.Singleton.IdDependencia = 0;
        self.txtDependencia.text = @"";

        self.Singleton.IdArea = 0;
        self.txtArea.text = @"";

        break;
    case 2:
        self.Singleton.IdDependencia = key;
        self.txtDependencia.text = value;

        self.Singleton.IdArea = 0;
        self.txtArea.text = @"";

        break;
            
    case 3:
        self.Singleton.IdArea = key;
        self.txtArea.text = value;
        break;

    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


- (IBAction)btnGetTipoGobierno:(id)sender {
    [self.Singleton setTarget:0];
}

- (IBAction)btnMunicipios:(id)sender {
    [self.Singleton setTarget:1];
}

- (IBAction)btnGetDependencias:(id)sender {
    [self.Singleton setTarget:2];
}

- (IBAction)btnArea:(id)sender {
    [self.Singleton setTarget:3];
}




#pragma Accesorios del teclado
-(void)HideKeyBoard{
    if ([self.view endEditing:NO]) {
        [self.view endEditing:YES ];
    } else {
        [self.view endEditing:NO];
    }
    
}

-(void)siguiente{
    
}

-(void)setAccesory{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    // UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Siguiente" style:UIBarButtonItemStyleDone target:self action:@selector(HideKeyBoard)];

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIImage *image = [UIImage imageNamed:@"keyboard.png"];
    
    UIBarButtonItem *closebuttom = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(HideKeyBoard)];
    
    //UIBarButtonItem *closebuttom = [[UIBarButtonItem alloc] initWithTitle:@"Ocultar" style:UIBarButtonItemStyleDone target:self action:@selector(HideKeyBoard)];
    
    [closebuttom setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:226.0/255.0 green:210.0/255.0 blue:186.0/255.0 alpha:1.0 ], NSForegroundColorAttributeName,nil]
                               forState:UIControlStateNormal];
    
    [toolbar setItems:[NSArray arrayWithObjects:space,closebuttom, nil]];
    
    [[self txtApm]setInputAccessoryView:toolbar];
    [[self txtApp]setInputAccessoryView:toolbar];
    [[self txtNombre]setInputAccessoryView:toolbar];
    [[self txtEMail]setInputAccessoryView:toolbar];
    [[self txtCelular]setInputAccessoryView:toolbar];

    [[self txtFecha]setInputAccessoryView:toolbar];
    [[self txtHora]setInputAccessoryView:toolbar];

    [[self txtLugarHechos]setInputAccessoryView:toolbar];
    [[self txtHechos]setInputAccessoryView:toolbar];

    [self.txtApp addTarget:self.txtApm action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.txtApm addTarget:self.txtNombre action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.txtNombre addTarget:self.txtEMail action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.txtEMail addTarget:self.txtCelular action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.txtCelular addTarget:self.txtFecha action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.txtFecha addTarget:self.txtHora action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.txtLugarHechos.delegate = self;
    self.txtHechos.delegate = self;
    
    self.txtLugarHechos.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
    self.txtHechos.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);

}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self AlertSimple:@"No se puede tener acceso a tu Localización" Tipo:0];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = locations.lastObject;
    if (locations.count > 0) {
        self.Singleton.Longitud = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
        self.Singleton.Latitud = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
        self.Singleton.Altitud = [NSString stringWithFormat:@"%f", newLocation.altitude];
    }
}


#pragma Siubida de Imagens y Video

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (self.TypeMedia == 0 || self.TypeMedia == 1){
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.imgArchivo.image = chosenImage;

    }else if (self.TypeMedia == 2){
        NSURL *chosenMovie = [info objectForKey:UIImagePickerControllerMediaURL];
        NSURL *fileURL = [self grabFileURL:@"devch_video.mp4"];
        NSData *movieData = [NSData dataWithContentsOfURL:chosenMovie];
        self.Singleton.urlVideo = fileURL;
        [movieData writeToURL:fileURL atomically:YES];
        self.imgArchivo.image = [UIImage imageNamed:@"video_on.png"];
        self.imgArchivo.highlighted = [UIImage imageNamed:@"video_ff.png"];
        UISaveVideoAtPathToSavedPhotosAlbum([chosenMovie path], nil, nil, nil);

    }else if (self.TypeMedia == 3){
        NSURL *fileURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.Singleton.urlVideo = fileURL;
        self.imgArchivo.image = [UIImage imageNamed:@"video_on.png"];
        self.imgArchivo.highlighted = [UIImage imageNamed:@"video_ff.png"];
        // NSLog(@"VideoURL = %@", fileURL);
        
    }else{
            // TODO
    }

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSURL*)grabFileURL:(NSString *)fileName {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:fileName];
    return documentsURL;
}

-(void) tomarFoto{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Cero Corrupción Tabasco"
                                     message:@"No tiene permiso para usar la cámara"
                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* btnFoto = [UIAlertAction
                                  actionWithTitle:@"Aceptar"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      
                                  }];

        [alert addAction:btnFoto];
        
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        self.TypeMedia = 0;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }

    
}

-(void) selecionarFoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.TypeMedia = 1;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void) grabarVideo{
    

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
        picker.mediaTypes = mediaTypes;
        
        self.TypeMedia = 2;

        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        [self AlertSimple:@"No tiene permisos para utilizar la cámara de video." Tipo:0];
    }
}

-(void) seleccionarVideo{
    
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    videoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    self.TypeMedia = 3;
    [self presentViewController:videoPicker animated:YES completion:nil];
}

#pragma Siubida de Archivos y Audio
-(void) selecionarArchivo{
    NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypePDF,(NSString *)kUTTypeText,(NSString *)kUTTypeRTF,(NSString *)kUTTypePlainText,@"com.microsoft.word.docx",@"com.microsoft.excel.xlsx", nil];
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:mediaTypes inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    self.TypeMedia = 4;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void) selecionarAudio{
    NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeAudio, (NSString *)kUTTypeMP3, (NSString *)kUTTypeMIDIAudio, (NSString *)kUTTypeMPEG4Audio, nil];
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:mediaTypes inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    self.TypeMedia = 5;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    if (self.TypeMedia == 4){
        NSURL *fileURL = [urls objectAtIndex:0];
        self.Singleton.urlArchivo = fileURL;
        self.imgArchivo.image = [UIImage imageNamed:@"document.png"];
        self.imgArchivo.highlighted = [UIImage imageNamed:@"document.png"];
    }else{
        NSURL *fileURL = [urls objectAtIndex:0];
        self.Singleton.urlArchivo = fileURL;
        self.imgArchivo.image = [UIImage imageNamed:@"audio.png"];
        self.imgArchivo.highlighted = [UIImage imageNamed:@"audio.png"];
    }
}

- (IBAction)btnSubirArchivo:(id)sender {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@"Escoge una opción"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* btnFoto = [UIAlertAction
                              actionWithTitle:@"Tomar foto"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                  
                                  [self tomarFoto];
                                  
                              }];
    
    UIAlertAction* btnCarrete = [UIAlertAction
                                 actionWithTitle:@"Subir foto de tu carrete"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     
                                     [self selecionarFoto];
                                     
                                 }];
    
    UIAlertAction* btnGrabarVideo = [UIAlertAction
                              actionWithTitle:@"Grabar Video"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                  
                                  [self grabarVideo];
                                  
                              }];
    
    UIAlertAction* btnSeleccionarVideo = [UIAlertAction
                                     actionWithTitle:@"Seleccionar Video"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         
                                         [self seleccionarVideo];
                                         
                                     }];

    
    UIAlertAction* btnSeleccionarArchivo = [UIAlertAction
                                          actionWithTitle:@"Seleccionar Archivo"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              
                                              [self selecionarArchivo];
                                              
                                          }];
    
    UIAlertAction* btnSeleccionarAudio = [UIAlertAction
                                            actionWithTitle:@"Seleccionar Audio"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                
                                                [self selecionarAudio];
                                                
                                            }];
    
    UIAlertAction* btnCancelar = [UIAlertAction
                                     actionWithTitle:@"Cancelar"
                                     style:UIAlertActionStyleCancel
                                     handler:^(UIAlertAction * action) {
                                         
                                     }];

    
    [alert addAction:btnFoto];
    [alert addAction:btnCarrete];
    [alert addAction:btnGrabarVideo];
    [alert addAction:btnSeleccionarVideo];
    [alert addAction:btnSeleccionarArchivo];
    [alert addAction:btnSeleccionarAudio];
    [alert addAction:btnCancelar];

    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)limpiarSingleton{
//    self.Singleton.IdTipoDenuncia = 0;
    self.Singleton.IdTipoGobierno = 0;
    self.Singleton.IdMunicipio = 0;
    self.Singleton.IdDependencia = 0;
    self.Singleton.IdArea = 0;
    self.Singleton.Apellido_Paterno = @"";
    self.Singleton.Apellido_Materno = @"";
    self.Singleton.Nombre = @"";
    self.Singleton.Correo_Electronico = @"";
    self.Singleton.Celular = @"";
    self.Singleton.Fecha = @"";
    self.Singleton.Hora = @"";
    self.Singleton.Lugar_Denuncia = @"";
    self.Singleton.Denuncia = @"";
}

- (IBAction)btnSend:(id)sender {
    
    self.Singleton.Apellido_Paterno = self.txtApp.text;
    self.Singleton.Apellido_Materno = self.txtApm.text;
    self.Singleton.Nombre = self.txtNombre.text;
    self.Singleton.Correo_Electronico = self.txtEMail.text;
    self.Singleton.Celular = self.txtCelular.text;
    self.Singleton.Fecha = self.txtFecha.text;
    self.Singleton.Hora = self.txtHora.text;
    self.Singleton.Lugar_Denuncia = self.txtLugarHechos.text;
    self.Singleton.Denuncia = self.txtHechos.text;
    self.Singleton.UIDD = [NSString stringWithFormat:@"%@", self.Singleton.uniqueIdentifier];
    self.Singleton.Device = self.Singleton.Device;

    if (
        self.Singleton.IdTipoGobierno == 0 ||
        self.Singleton.IdDependencia == 0 ||
        [self.Singleton.Lugar_Denuncia  isEqual: @""] ||
        [self.Singleton.Denuncia  isEqual: @""]
        ){
        [self AlertSimple:@"Campos marcados con Asteriscos (*) deben ser llenados." Tipo:0];
        return;
    }
    
    if ( ![self.Singleton.Correo_Electronico isEqual:@""] ){
        if (![self.Singleton validateEmail:self.Singleton.Correo_Electronico]) {
            [self AlertSimple:@"Correo Electrónico NO válido." Tipo:0];
            return;
        }
    }

//    if ( ![self.Singleton.Celular isEqual:@""] ){
//        if (![self.Singleton validatePhone:self.Singleton.Celular]) {
//            [self AlertSimple:@"Número de Teléfono NO válido." Tipo:0];
//            return;
//        }
//    }
    

    
    
    [UIView animateWithDuration:1.0 animations:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.Indicator setHidden:NO];
        [self.Indicator startAnimating];
        [sender setTitle:@"enviando información..." forState:UIControlStateNormal];
        [sender setAlpha:0.5];
        [sender setEnabled:NO];
    }];
    
    //return;

    NSString *boundary = @"SportuondoFormBoundary";
    NSMutableData *body = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"IdTipoDenuncia"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", self.Singleton.IdTipoDenuncia] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"IdTipoGobierno"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", self.Singleton.IdTipoGobierno] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"IdMunicipio"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", self.Singleton.IdMunicipio] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"IdDependencia"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", self.Singleton.IdDependencia] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"IdArea"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", self.Singleton.IdArea] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Apellido_Paterno"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Apellido_Paterno] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Apellido_Materno"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Apellido_Materno] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Nombre"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Nombre] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Correo_Electronico"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Correo_Electronico] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Celular"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Celular] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Fecha"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Fecha] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Hora"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Hora] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Lugar_Denuncia"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Lugar_Denuncia] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Denuncia"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Denuncia] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"UIDD"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.UIDD] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Device"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Device] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Latitud"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Latitud] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Longitud"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Longitud] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Altitud"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Altitud] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.TypeMedia == 0 || self.TypeMedia == 1){
        NSData *imageData = UIImageJPEGRepresentation(self.imgArchivo.image, 90);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"foto"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

        }
    }
    
    if (self.TypeMedia == 2 || self.TypeMedia == 3){
        NSData *movieData = [NSData dataWithContentsOfURL:self.Singleton.urlVideo];
        if (movieData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"video.mp4\"\r\n", @"foto"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: video/quicktime\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:movieData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }

    if (self.TypeMedia == 4 || self.TypeMedia == 5){
        NSData *fileData = [NSData dataWithContentsOfURL:self.Singleton.urlArchivo];
        if (fileData) {
            //NSString *cad1 = [NSString stringWithFormat:@"%@up_control_images/", self.urlBase]

            NSString *myString = self.Singleton.urlArchivo.absoluteString;
            NSString *ext = [myString componentsSeparatedByString:@"."][3];
            NSLog(@"Ext %@",ext);
            if ([ext isEqualToString:@"pdf"] || [ext isEqualToString:@"PDF"]){
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"archovo_pdf.pdf\"\r\n", @"foto"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/pdf\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:fileData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            if ([ext isEqualToString:@"txt"] || [ext isEqualToString:@"TXT"]){
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"archovo_txt.txt\"\r\n", @"foto"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: text/plain\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:fileData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            if ([ext isEqualToString:@"docx"] || [ext isEqualToString:@"DOCX"] || [ext isEqualToString:@"xlsx"] || [ext isEqualToString:@"XLSX"]){
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"foto",myString] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/xml\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:fileData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            if ([ext isEqualToString:@"mp3"] || [ext isEqualToString:@"m4a"] ){
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"audio.mp3\"\r\n", @"foto"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: audio/mpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:fileData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }

        }
        
        
    }

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"api-key"       : @"55e76dc4bbae25b066cb",
                                                   @"Accept"        : @"application/json",
                                                   @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
                                                   };
    
    self.session = [NSURLSession sessionWithConfiguration: self.sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];

    NSURL *url = [NSURL URLWithString:self.Singleton.urlGuardarDenuncia];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    NSURLSessionDataTask *uploadTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error)
        {

            NSError *jsonError;
            
            NSDictionary *responseBody = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            NSLog(@"%@",responseBody);
            if(!jsonError)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Respode %@",responseBody);
                    NSString *status = [responseBody objectForKey:@"status"];
                    NSLog(@"status %@",status);
                    if ([status  isEqual: @"OK"]){
                        [self postDataRestoreButton:sender];
                        [self AlertSimple:@"Datos guardados con éxito" Tipo:1];
                    }else{
                        [self postDataRestoreButton:sender];
                        [self AlertSimple:@"Ha ocurrido un error, intente más tarde" Tipo:0];
                    }
                });
            }else{
                NSLog(@"Se presenta el error: %@",jsonError.description);
                [self postDataRestoreButton:sender];
                [self AlertSimple:@"Faltan datos o no hay conexión con el Servidor." Tipo:0];
            }
        
        }else{
            NSLog(@"Se presenta el EError: %@",error);
            [self postDataRestoreButton:sender];
            [self AlertSimple:@"Faltan datos." Tipo:0];
        }
        
        
    }];
    
    [uploadTask resume];
    
}

-(void)postDataRestoreButton:(id)sender{
    [UIView animateWithDuration:1.0 animations:^{
        [sender setTitle:@"Enviar" forState:UIControlStateNormal];
        [sender setEnabled:YES];
        [sender setAlpha:1];
        [self.Indicator setHidden:NO];
        [self.Indicator stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

/*
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    self.progressBar.progress=0.0f;
    self.downloadSize=[response expectedContentLength];
    self.dataToDownload=[[NSMutableData alloc]init];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.dataToDownload appendData:data];
    self.progressBar.progress=[ self.dataToDownload length ]/self.downloadSize;
}
*/


-(void)AlertSimple:(NSString *) mensaje Tipo:(int)tipo{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Cero Corrupción Tabasco"
                                 message:mensaje
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* btnTipo0 = [UIAlertAction
                              actionWithTitle:@"Aceptar"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                  
                                  // [self metodo];
                                  
                              }];
    
    
    UIAlertAction* btnTipo1 = [UIAlertAction
                               actionWithTitle:@"Aceptar"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];


    switch (tipo) {
        case 1:
            [alert addAction:btnTipo1];
            break;
        default:
            [alert addAction:btnTipo0];
            break;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}






- (IBAction)btnSegueImage:(id)sender {
}




@end
