//
//  ArchivosCVC.m
//  CeroCorrupcionTabasco
//
//  Created by Carlos Manuel Hidalgo Ruiz on 7/15/19.
//  Copyright © 2019 Carlos Hidalgo. All rights reserved.
//

#import "ArchivosCVC.h"
#import "Opciones.h"
#import "Singleton.h"
#import "ArchivoCVCell.h"
#import "VerImagenVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PreloaderVC.h"

@interface ArchivosCVC () <ArchivoCVCellDelegate, PreloaderVCDelegate>

@end

@implementation ArchivosCVC{
    NSMutableArray *Combo;
}
@synthesize collectionView, archivos, Singleton, Indicator, IdDenuncia, imgArchivo, TypeMedia, sessionConfiguration, session, IdArchivo ;

static NSString * const reuseIdentifier = @"cellImageArchivo";
static NSString * const reuseIdentifier2 = @"cellImageArchivo2";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgArchivo = [UIImage imageNamed: @""];

    [self customSetup];
}

- (void)customSetup
{
    self.title = self.Titulo;
    
    self.Singleton  = [Singleton sharedMySingleton];

    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration: self.sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    self.Singleton.IdDenuncia = self.IdDenuncia;
    
    [self.Singleton getUrlArchivosDenuncia];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    NSMutableArray *arrPList = [self.Singleton getOpciones];
    
    NSLog(@"Mutable Array Entrada ==> %@",[self.Singleton getOpciones]);
    
    if ([arrPList count] > 0){
        self.archivos = arrPList;
        [self.collectionView reloadData];
    }else{
        [self getDataOptions:self.Singleton.urlArchivosDenuncia];
    }

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.archivos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    Opciones *opt = self.archivos[indexPath.row];
    
    NSString *ident = reuseIdentifier;
    if ([opt.VString1 isEqualToString:@"docx"] || [opt.VString1 isEqualToString:@"xlsx"] || [opt.VString1 isEqualToString:@"txt"] || [opt.VString1 isEqualToString:@"pdf"] ) {
        ident = reuseIdentifier2;
    }

    ArchivoCVCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    cell.delegate = self;
    
    UIImage *image11 = opt.Imagen;
    CGRect starFrame1 = cell.frame;
    UIImageView *starImage2 = [[UIImageView alloc] initWithFrame:starFrame1];
    starImage2.image= image11;
    [cell setBackgroundView:starImage2];
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 15.0;
    cell.layer.borderWidth = 5.0;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.IdArchivo = opt.Key;
    cell.Archivo = opt.Value;
    cell.Imagen = opt.Imagen;
    cell.esVideo.hidden = YES;
    cell.esAudio.hidden = YES;
    cell.esDocument.hidden = YES;
    cell.extensionArchivo = opt.VString1;

    if ([opt.VString1 isEqualToString:@"mp4"]) {
        cell.esVideo.hidden = NO;
    }
    if ([opt.VString1 isEqualToString:@"mp3"]) {
        cell.esAudio.hidden = NO;
    }
    if ([opt.VString1 isEqualToString:@"docx"] || [opt.VString1 isEqualToString:@"xlsx"] || [opt.VString1 isEqualToString:@"txt"] || [opt.VString1 isEqualToString:@"pdf"] ) {
        cell.esDocument.hidden = YES;
    }

    return cell;
}



-(void)getDataOptions:(NSString *)Url {
    
    [UIView animateWithDuration:1.0 animations:^{
        [self LlamarPreloader:0];
    }];
    
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
                NSLog(@"Respode Mis Denuncias %@",responseBody);
                
                self.archivos = [NSMutableArray array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self closeWindows];
                    [self getArchivos:responseBody];
                });
            }else{
                NSLog(@"Error for @DevCH: 102");
                [self closeWindows];
            }
            
        }else{
            NSLog(@"Mi Error: %@", error.description);
            [self closeWindows];
        }
    }];
    [task resume];
}



-(void)getArchivos:(NSDictionary *)responseBody{
    
    self->Combo = (NSMutableArray *)responseBody;
    for (int i=0; i<self->Combo.count; i++) {
        int Key = [ [[self->Combo objectAtIndex:i]objectForKey:@"idarchivo"] intValue];
        NSString *Value = [[self->Combo objectAtIndex:i]objectForKey:@"archivo"];
        NSString *ext = [Value componentsSeparatedByString:@"."][1];
        
        if ([ext isEqualToString:@"jpg"]) {
            NSString *urlImg = [NSString stringWithFormat:@"%@%@",self.Singleton.urlMediaData,Value];
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImg]];
            UIImage *img = [UIImage imageWithData: data];
            [self.archivos addObject:[Opciones newDataObjectWhitImage:Key value:Value VString1:ext Imagen:img]];
//            [self.archivos addObject:[Opciones newDataObjectMedia:Key value:Value VString1:ext Imagen:img Data:data]];
        }else if ([ext isEqualToString:@"mp4"]) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@", self.Singleton.urlMediaData,Value];
            NSURL *url = [NSURL URLWithString:urlString];
            //NSData * data = [[NSData alloc] initWithContentsOfURL: url];
            AVURLAsset* asset = [AVURLAsset URLAssetWithURL:url options:nil];
            AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
            [imageGenerator setAppliesPreferredTrackTransform:TRUE];
            UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
            UIImage *img = image;
            [self.archivos addObject:[Opciones newDataObjectWhitImage:Key value:Value VString1:ext Imagen:img]];
//            [self.archivos addObject:[Opciones newDataObjectMedia:Key value:Value VString1:ext Imagen:img Data:data]];
        }else if ([ext isEqualToString:@"mp3"]) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@", self.Singleton.urlMediaData,Value];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageNamed:@"audio"];
            [self.archivos addObject:[Opciones newDataObjectMedia:Key value:Value VString1:ext Imagen:img Data:data]];
        }else{
            NSString *urlString = [NSString stringWithFormat:@"%@%@", self.Singleton.urlMediaData,Value];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageNamed:@"document"];
//            [self.archivos addObject:[Opciones newDataObjectWhitImage:Key value:Value VString1:ext Imagen:img]];
            [self.archivos addObject:[Opciones newDataObjectMedia:Key value:Value VString1:ext Imagen:img Data:data]];
        }
    }
    
    [self.Singleton clearAllOpciones];
    [self.Singleton insertOpciones:self.archivos];
    NSLog(@"Mutable Array Salida ==> %@",[self.Singleton getOpciones]);
    self.archivos = [self.Singleton getOpciones];
    [self.collectionView reloadData];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Opciones *opt = self.archivos[indexPath.row];
    self.imgArchivo = opt.Imagen;
    self.Singleton.IdArchivo = opt.Key;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"verImagen2"]) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:sender];
        Opciones *opt = self.archivos[indexPath.row];
        VerImagenVC *mvc = segue.destinationViewController;
        mvc.imagen = opt.Imagen;
        mvc.nombreArchivo = opt.Value;
        mvc.extensionArchivo = opt.VString1;
        mvc.Data = opt.Data;
    }
}


#pragma Siubida de Imagenes y Video

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (self.TypeMedia == 0 || self.TypeMedia == 1){
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.imgArchivo = chosenImage;
        
    }else if (self.TypeMedia == 2){
        NSURL *chosenMovie = [info objectForKey:UIImagePickerControllerMediaURL];
        NSURL *fileURL = [self grabFileURL:@"devch_video.mp4"];
        NSData *movieData = [NSData dataWithContentsOfURL:chosenMovie];
        self.Singleton.urlVideo = fileURL;
        [movieData writeToURL:fileURL atomically:YES];
        self.imgArchivo = [UIImage imageNamed:@"video_on"];
        UISaveVideoAtPathToSavedPhotosAlbum([chosenMovie path], nil, nil, nil);
        
    }else if (self.TypeMedia == 3){
        NSURL *fileURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.Singleton.urlVideo = fileURL;
        self.imgArchivo = [UIImage imageNamed:@"video_on"];
        
    }else{
        // TODO
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self subirArchivo];
 
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
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) selecionarAudio{
    NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeAudio, (NSString *)kUTTypeMP3, (NSString *)kUTTypeMIDIAudio, (NSString *)kUTTypeMPEG4Audio, nil];
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:mediaTypes inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    self.TypeMedia = 5;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    if (self.TypeMedia == 4){
        NSURL *fileURL = [urls objectAtIndex:0];
        self.Singleton.urlArchivo = fileURL;
        self.imgArchivo = [UIImage imageNamed:@"document.png"];
    }else{
        NSURL *fileURL = [urls objectAtIndex:0];
        self.Singleton.urlArchivo = fileURL;
        self.imgArchivo = [UIImage imageNamed:@"audio.png"];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self subirArchivo];

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

- (IBAction)btnRefresh:(id)sender {
   [self getDataOptions:self.Singleton.urlArchivosDenuncia];
}



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


-(void)subirArchivo{
    
    
    self.Singleton.UIDD = [NSString stringWithFormat:@"%@", self.Singleton.uniqueIdentifier];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self LlamarPreloader:1];
    }];

    NSString *boundary = @"SportuondoFormBoundary";
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"IdDenuncia"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", self.Singleton.IdDenuncia] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"UIDD"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.UIDD] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.TypeMedia == 0 || self.TypeMedia == 1){
        NSData *imageData = UIImageJPEGRepresentation(self.imgArchivo, 90);
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
            if ([ext isEqualToString:@"mp3"] || [ext isEqualToString:@"m4a"] || [ext isEqualToString:@"m4v"] ){
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
    
    NSURL *url = [NSURL URLWithString:self.Singleton.urlAgregarArchivo];
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
                        [self closeWindows];
                        [self AlertSimple:@"Datos guardados con éxito" Tipo:1];
                    }else{
                        [self closeWindows];
                        [self AlertSimple:@"Ha ocurrido un error, intente más tarde" Tipo:0];
                    }
                });
            }else{
                NSLog(@"Se presenta el error: %@",jsonError.description);
                [self closeWindows];
                [self AlertSimple:@"Faltan datos o no hay conexión con el Servidor." Tipo:0];
            }
            
        }else{
            NSLog(@"Se presenta el EError: %@",error);
            [self closeWindows];
            [self AlertSimple:@"Faltan datos." Tipo:0];
        }
        
        
    }];
    
    [uploadTask resume];
}

-(void)removeFile:(int)IdFile Archivo:(NSString *)archivito{
    
    self.Singleton.IdArchivo = IdFile;
    self.Singleton.Archivo = archivito;
    
    self.Singleton.UIDD = [NSString stringWithFormat:@"%@", self.Singleton.uniqueIdentifier];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self LlamarPreloader:2];
    }];

    NSString *boundary = @"SportuondoFormBoundary";
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"IdArchivo"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d\r\n", self.Singleton.IdArchivo] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"UIDD"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.UIDD] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Archivo"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", self.Singleton.Archivo] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.sessionConfiguration.HTTPAdditionalHeaders = @{
                                                        @"api-key"       : @"55e76dc4bbae25b066cb",
                                                        @"Accept"        : @"application/json",
                                                        @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
                                                        };
    
    self.session = [NSURLSession sessionWithConfiguration: self.sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:self.Singleton.urlQuitarArchivo];
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
                        [self closeWindows];
                        [self AlertSimple:@"Archivo Eliminado con éxito" Tipo:1];
                    }else{
                        [self closeWindows];
                        [self AlertSimple:@"Ha ocurrido un error, intente más tarde" Tipo:0];
                    }
                });
            }else{
                NSLog(@"Se presenta el error: %@",jsonError.description);
                [self closeWindows];
                [self AlertSimple:@"Faltan datos o no hay conexión con el Servidor." Tipo:0];
            }
            
        }else{
            NSLog(@"Se presenta el EError: %@",error);
            [self closeWindows];
            [self AlertSimple:@"Faltan datos." Tipo:0];
        }
        
        
    }];
    
    [uploadTask resume];
}








- (void)quitarArchivo:(int)idarchivo Archivo:(nonnull NSString *)archivo {
    NSLog(@"Archovo ID: %d",idarchivo);
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Cero Corrupción Tabasco"
                                 message:[NSString stringWithFormat:@"¿Desea eliminar el archivo %d?", idarchivo]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* btnTipo0 = [UIAlertAction
                               actionWithTitle:@"Aceptar"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   [self removeFile:idarchivo Archivo:archivo];
                                   
                               }];
    
    UIAlertAction* btnTipo1 = [UIAlertAction
                               actionWithTitle:@"Cancelar"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                                   // [self metodo];
                                   
                               }];
    
    
    
    
    [alert addAction:btnTipo0];
    [alert addAction:btnTipo1];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)LlamarPreloader:(int) tipo{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    PreloaderVC *add =
    [storyboard instantiateViewControllerWithIdentifier:@"PreloaderVC"];
    add.delegate = self;
    switch (tipo) {
        case 1:
            [add.lblLoader setText:@"Subiendo..."];
            break;
        case 2:
            [add.lblLoader setText:@"Quitando..."];
            break;
        default:
            break;
    }
    
    [self presentViewController:add
                       animated:YES
                     completion:nil];
    
}

- (void)closeWindows {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
