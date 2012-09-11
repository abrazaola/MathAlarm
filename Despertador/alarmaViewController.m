//
//  alarmaViewController.m
//  Despertador
//
//  Created by Aitor Brazaola on 23/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "alarmaViewController.h"
#import "Alarma.h"

@interface alarmaViewController ()

@end

@implementation alarmaViewController
@synthesize titulo, hora, operando1, operando2, operacion, resultado, alarmaActual, BotonApagar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initConAlarma:(Alarma *)a
{
    self = [super init];
    
    if (self) {
        //Pongo la alarma que me pasan como alarma actual
        alarmaActual=a;
        [titulo setText:[a title]];
        
        NSString *rutaMusica=[[NSBundle mainBundle]pathForResource:[a sonido] ofType:@"caf"];
        if(rutaMusica)
        {
            NSURL *urlMusica=[NSURL fileURLWithPath:rutaMusica];
            audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:urlMusica error:nil];
            //Le pongo delegado a mi misma clase y que repita infinitamente
            [audioPlayer setDelegate:self];
            [audioPlayer setNumberOfLoops:-1];
            
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Pongo Titulo al boton apagar
    [BotonApagar setTitle:NSLocalizedString(@"Apagar", @"ApagarAlarma") forState:UIControlStateNormal];
    
    //Pongo la hora de la alarma que me pasan
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    [hora setText:[dateFormatter stringFromDate:[alarmaActual date]]];
    
    //Configuro el textfield
    [resultado setKeyboardType:UIKeyboardTypeNumberPad];
    
    //Configuro el contenido de los labels con el de la alarma que me pasan
    [titulo setText:[alarmaActual title]];
    
    //Configuracion de el sonido
    [audioPlayer play];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //Pongo el campo resultado como first responder
    [resultado becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self generarOperacion];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - Metodos de la clase
-(void)generarOperacion
{
    // Creo el primer operando
    op1=(arc4random() % 20) + 1;
    op2=(arc4random() % 20) + 1;
    //Se puede usar tambien antes de rand()%10;
    //srandom(time(NULL));
    
    //Los convierto a NSStrings
    NSString *op1String=[[NSString alloc]initWithFormat:@"%i", op1];
    NSString *op2String=[[NSString alloc]initWithFormat:@"%i", op2];
    
    //Se los paso a los labels
    [operando1 setText:op1String];
    [operando2 setText:op2String];
    
    //Hago el calculo interno de el resultado correcto
    resultadoNum=op1+op2;
}


-(IBAction)apagar:(id)sender
{
    int resultadoEnLaCaja=[[resultado text]intValue];
    
    if (resultadoEnLaCaja==resultadoNum) {
        //Dissmiss del modal y paro la musica
        [audioPlayer stop];        
                
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        //Muestro la alerta de operacion incorrecta
        UIAlertView *alertaReintentar=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Incorrecto", @"ResultadoIncorrecto") message:NSLocalizedString(@"El resultado introducido no es correcto.", @"ResultadoIncorrectoMensaje") delegate:self cancelButtonTitle:NSLocalizedString(@"Inténtalo de nuevo", @"MensajeIntenteloDeNuevo") otherButtonTitles:nil];
        
        [alertaReintentar show];
        
        [resultado setText:@""];
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self apagar:nil];
    
    return YES;
}

@end
