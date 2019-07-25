//
//  PopupVCViewController.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Hidalgo on 7/4/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "PopupVCViewController.h"
#import "Opciones.h"
#import "Singleton.h"
#import "DenunciaPersonalTableViewController.h"
@interface PopupVCViewController ()
@end

@implementation PopupVCViewController{
    NSMutableArray *Combo;
}
@synthesize tableView, btnCloseVC, PopupVC, opciones, IdTarget;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.Singleton  = [Singleton sharedMySingleton];
    [self.Singleton setPlist];
    
    [self.Indicator setHidden:YES];
    [self.Indicator hidesWhenStopped];

    tableView.dataSource = self;
    tableView.delegate = self;
    
    PopupVC.layer.cornerRadius = 15;
    PopupVC.layer.masksToBounds = true;
    
    [self getCallDatos];
    
}

-(void)getCallDatos{
    switch (self.IdTarget){
        case 0:
            [self getTipoGobierno];
            break;
        case 1:
            [self getDataOptions:self.Singleton.urlDependencias];
            break;
    };
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString* txtCel = [[NSString alloc] init];
    txtCel = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:txtCel forIndexPath:indexPath];
    
     Opciones *opt = opciones[indexPath.row];
     cell.textLabel.text = opt.Value;
    
    return cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [opciones count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Opciones *opt = opciones[indexPath.row];
    self.Key = opt.Key;
    self.Value = opt.Value;
    [self setDataReturn];
    
    return indexPath;
}



#pragma Métodos GET y SET de Datos
-(void)getTipoGobierno{
    opciones = [NSMutableArray array];
    [opciones addObject:[Opciones newDataObject:0 value:@"GOBIERNO DEL ESTADO DE TABASCO"]];
    [opciones addObject:[Opciones newDataObject:1 value:@"MUNICIPIOS DE TABASCO"]];
}

-(void)setDataReturn{
    [self.delegate key:self.Key value:self.Value];
    [self.delegate cerrarVentana];
}

-(void)getDataOptions:(NSString *)Url {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.tableView setHidden:YES];
    [self.Indicator setHidden:NO];
    [self.Indicator startAnimating];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: Url]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error)
        {
            NSError *jsonError;
            
            NSDictionary *responseBody = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if(!jsonError)
            {
                self->opciones = [NSMutableArray array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->Combo = (NSMutableArray *)responseBody;
                    for (int i=0; i<self->Combo.count; i++) {
                        int Key = [ [[self->Combo objectAtIndex:i]objectForKey:@"data"] intValue];
                        NSString *Value = [[self->Combo objectAtIndex:i]objectForKey:@"label"];
                        [self->opciones addObject:[Opciones newDataObject:Key value:Value]];
                    }
                    [self.Indicator stopAnimating];
                    [self.Indicator setHidden:YES];
                    [self.tableView setHidden:NO];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    [self->tableView reloadData];

                });

            }else{
                NSLog(@"Error: 101");
            }
            
        }
    }];
    [task resume];
    

}

#pragma Llamada de botones
- (IBAction)btnCloseVC:(id)sender {
    [self.delegate cerrarVentana];
}

@end
