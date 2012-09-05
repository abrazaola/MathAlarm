//
//  HoraViewController.m
//  Despertador
//
//  Created by Aitor Brazaola on 12/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "HoraViewController.h"
#import "instruccionesViewController.h"
#import "Alarma.h"

@interface HoraViewController ()

@end

@implementation HoraViewController

#pragma mark - Metodos de el reloj

-(void)actualizarHora
{
    dateFormatter=[[NSDateFormatter alloc]init];
    hourFormatter=[[NSDateFormatter alloc]init];
    
    [hourFormatter setDateFormat:@"hh:mm:ss"];
    
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    hora=[hourFormatter stringFromDate:[NSDate date]];
    //hora=@"88:88:88";
    fecha=[dateFormatter stringFromDate:[NSDate date]];
    //fecha=@"888888888888888";
    
    //Pongo a los labels los valores
    [labelHora setText:hora];
    [labelFecha setText:fecha];
}

-(void)actualizarLED
{
    //Compruebo si hay alarmas activas y enciendo el led
    BOOL hayAlarmas=FALSE;
    int i=0;
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *arrayAlarmas=[delegate arrayAlarmas];
    
    while (!hayAlarmas&&i<[arrayAlarmas count]) {
        Alarma *a=(Alarma *)[arrayAlarmas objectAtIndex:i];
        
        if ([a estado]) {
            hayAlarmas = YES;
        }
        i++;
    }
    if (hayAlarmas) {
        [indicadorAlarma setHidden:NO];
    }
}

#pragma mark - IBActions
-(IBAction)borrarNotificaciones:(id)sender;
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    UIAlertView *mensaje=[[UIAlertView alloc]initWithTitle:@"Borrar Notificaciones" message:@"Notificaciones borradas" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [mensaje show];
}
#pragma mark - Ciclo de vida de la vista

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navigationItem=[self navigationItem];
        [navigationItem setTitle:NSLocalizedString(@"Reloj", @"RelojNavigation")];
        
        [self actualizarHora];
        
        timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(actualizarHora) userInfo:nil repeats:YES];
        //Fondo de pantalla
        
        [[self view]setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v"]]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Pongo la fuente LCD
    [labelHora setFont:[UIFont fontWithName:@"Digital-7" size:100]];
    [labelFecha setFont:[UIFont fontWithName:@"Digital-7" size:20]];
    
    //DEBUG
    //[borrarNotificaciones setHidden:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [[self view]setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v"]]];
            } else {
                [[self view]setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_h"]]];
                    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [indicadorAlarma setHidden:YES];
    
    [self actualizarLED];
    //Hacer la comprobacion de si se ha abierto la app por primera vez, en ese caso lanzar la ventana modal de las instrucciones
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setBool:YES forKey:@"firstStart"];
    
    if ([defaults boolForKey:@"firstStart"] == NO)
    {
        instruccionesVC=[[instruccionesViewController alloc]init];
        [self presentModalViewController:instruccionesVC animated:YES];

        [defaults setBool:YES forKey:@"firstStart"];
    }
    
}

@end
