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



@interface DenunciaTVC () <PopupVCDelegate>
@end

@implementation DenunciaTVC
@synthesize arrSegue, opciones, Singleton, txtTipoGobierno, txtMunicipio, txtDependencia;

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setAccesory];

    self.Singleton  = [Singleton sharedMySingleton];
    [self.Singleton setPlist];
    
    [self selectDate];
    
    self.arrSegue =[NSArray arrayWithObjects:@"Child0",@"Municipios",@"DependenciaGobierno", nil];
    
}

- (void) selectDate{

    UIDatePicker* datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.txtFecNac setInputView:datePicker];

}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"dd'-'MM'-'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

-(void)updateTextField:(id)sender
{
    UIDatePicker* datePicker = (UIDatePicker*) self.txtFecNac.inputView;
    self.txtFecNac.text = [self formatDate:datePicker.date];
    
}

- (IBAction)btnSend:(id)sender {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cero Corrupción Tabasco"
                                                                   message:@"El siguiente paso será enviar la info."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.Singleton.IdTipoGobierno==0 && (indexPath.row == 1 || indexPath.row == 2) && indexPath.section == 0){
        return YES;
    } else {
        return NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat height = 0.0;
    int tg = self.Singleton.IdTipoGobierno;
    int mu = self.Singleton.IdMunicipio;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSInteger sec = indexPath.section;
    if (sec == 0){
        if (row >= 0 && row <=2){
            if (tg == 0 && row == 0)
                height = 80;
            else if (tg == 1 && (row == 0 || row == 2))
                height = 80;
            else if (tg == 2 && (row == 0 || row == 1 ) && mu <= 0)
                height = 80;
            else if (tg == 2 && (row == 0 || row == 1 || row == 2 ) && mu > 0)
                height = 80;
        }
    }else{
        height = 80;
    }
    return height;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:arrSegue[ [self.Singleton getIdTarget] ]]) {
        PopupVCViewController *mvc = (PopupVCViewController *) segue.destinationViewController;
        mvc.IdTarget = [self.Singleton getIdTarget];
        [mvc setDelegate:self];
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
        
        break;
    case 1:
        self.Singleton.IdMunicipio = key;
        self.txtMunicipio.text = value;

        self.Singleton.IdDependencia = 0;
        self.txtDependencia.text = @"";

        break;
    case 2:
        self.Singleton.IdDependencia = key;
        self.txtDependencia.text = value;
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    NSLog(@"Entro en el teclado");
    return NO; // We do not want UITextField to insert line-breaks.
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
    [[self txtFecNac]setInputAccessoryView:toolbar];
    
    [[self txtDependencia]setInputAccessoryView:toolbar];
    [[self txtTipoGobierno]setInputAccessoryView:toolbar];

    [self.txtApp addTarget:self.txtApm action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.txtApm addTarget:self.txtNombre action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.txtNombre addTarget:self.txtEMail action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.txtEMail addTarget:self.txtFecNac action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
}

@end
