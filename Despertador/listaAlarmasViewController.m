//
//  alarmasViewController.m
//  Despertador
//
//  Created by Aitor Brazaola on 16/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "listaAlarmasViewController.h"
#import "nuevaAlarmaViewController.h"
#import "Alarma.h"
#import "alarmaViewController.h"
#import "AppDelegate.h"

@interface listaAlarmasViewController ()

@end

@implementation listaAlarmasViewController
@synthesize arrayAlarmas, celdaAlarma;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        navigationItem=[self navigationItem];
        [navigationItem setTitle:NSLocalizedString(@"Alarmas", @"AlarmasNavigation")];
        
        //Configuro el tamaño de las celdas
        [[self tableView]setRowHeight:92];
        
        //Permito que la tabla se pueda ser seleccionable durante la edicion y no sin ella
        [[self tableView]setAllowsSelection:NO];
        [[self tableView]setAllowsSelectionDuringEditing:YES];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Creo el array(Me lo pasan creado de el appDelegate
    //arrayAlarmas=[[NSMutableArray alloc]init];
    
    //Inicio el timer que comprueba si alguna alarma ha de saltar
    [self performSelector:@selector(iniciarTimer)];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    //Pongo el boton editar
    [navigationItem setLeftBarButtonItem:[self editButtonItem]];
    
    //Pongo el boton añadir
    [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(nuevaAlarma)] animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self tableView]reloadData];
    //Desactivo el modo edicion en caso de que se vuelva de la edicion o creacion de una alarma
        if([[self tableView]isEditing])
    {
        [self setEditing:NO];
    }
}

#pragma mark - Acciones con la alarma

-(void)nuevaAlarma
{
    //Construyo la vista y le paso la alarma, titulo y el array.
    nuevaAlarmaVC=[[nuevaAlarmaViewController alloc]init];
    
    //Pongo a nil la editing alarma para que la cree el
    [nuevaAlarmaVC setEditingAlarma:nil];
    [nuevaAlarmaVC setArrayAlarmas:arrayAlarmas];
    [nuevaAlarmaVC setTituloVentana:NSLocalizedString(@"Nueva alarma", @"NavigationNuevaAlarma")];
    
    //Anido la vista en un navigation Controller
    naviNuevaAlarma=[[UINavigationController alloc]initWithRootViewController:nuevaAlarmaVC];
    //Le pongo el color negro a la barra
    [[naviNuevaAlarma navigationBar]setBarStyle:UIBarStyleBlack];
    
    //Lanzo el modal del navigation controller
    [self presentModalViewController:naviNuevaAlarma animated:YES];
}

-(void)comprobarAlarmas
{
    //Me recorro el array de alarmas hasta encontrar una que coincida con al menos 15 segundos de margen.
    for (int i=0; i<[arrayAlarmas count]; i++)
    {
        Alarma *a=[arrayAlarmas objectAtIndex:i];
        NSDate *horaActual=[NSDate date];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm"];
        
        NSLog(@"Hora de la alarma: %@", [formatter stringFromDate:[a date]]);
        NSLog(@"Hora actual. %@", [formatter stringFromDate:horaActual]);
        
        if( ([[formatter stringFromDate:[a date]]isEqualToString:[formatter stringFromDate:horaActual]])    &&[a estado])
        {
            NSLog(@"He lanzado la ventana de alarma!!!");
            //Creo la vista de alarma disparada
            alarmaVC=[[alarmaViewController alloc]initConAlarma:a];
            //Detengo el timer
            [timer invalidate];
            //Arranco de nuevo el timer tras 60 seg.
            [self performSelector:@selector(iniciarTimer) withObject:nil afterDelay:60];

            [self presentModalViewController:alarmaVC animated:YES];
        }
    }
}

-(void)iniciarTimer
{
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(comprobarAlarmas) userInfo:nil repeats:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayAlarmas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"celdaIdentifier";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"celdaAlarma" owner:self options:nil];
        cell = celdaAlarma;
        self.celdaAlarma = nil;
    }
    
    //Configuro el accesory view cuando la tabla está en modo edicion
    [cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //Preparo el objeto Alarma del que voy a sacar los datos
    Alarma *a=[arrayAlarmas objectAtIndex:[indexPath row]];
    
    //Titulo de la celda
    UILabel *labelTitulo=(UILabel *)[cell viewWithTag:2];
    [labelTitulo setText:[a title]];
    
    //LabelHora de la celda
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    UILabel *labelHora=(UILabel *)[cell viewWithTag:1];
    
    //Pongo a la celda el sonido que tiene la alarma
    UILabel *labelSonido=(UILabel *)[cell viewWithTag:4];
    [labelSonido setText:[a sonido]];
    
    //Led de la celda
    UIImageView *led=(UIImageView *)[cell viewWithTag:3];
    if ([a estado]) {
        //Poner el led verde
        [led setImage:[UIImage imageNamed:@"ledsverde"]];
            } else {
                //Poner el led rojo
                [led setImage:[UIImage imageNamed:@"ledrojo"]];
                    }
    
    //Configuro que se oculte en modo edicion [no funciona, tengo que hacer un boton editar a mano]
    if([self isEditing])
    {
        [led setHidden:YES];
    }
    else {
        [led setHidden:NO];
    }
    
    [labelHora setText:[dateFormatter stringFromDate:[a date]]];
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Obtengo la alarma que le corresponde a esa celda para quitar la notificación que le corresponde.
        Alarma *a=(Alarma *)[arrayAlarmas objectAtIndex:[indexPath row]];
        NSLog(@"Ya he cojido la alarma de el array que me corresponde quitar la posicion %i de la table del array de %i posiciones con fecha %@", [indexPath row],[arrayAlarmas count], [a date]);
        
        [a cancelarNotificacion];
        //Notificacion quitada

        //Borro la alarma del array
        [arrayAlarmas removeObjectAtIndex:[indexPath row]];
        //NSLog(@"Alarma borrada %@", [a date]);
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        [self performSelector:@selector(nuevaAlarma)];
    }   
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Desactivo la edicion por gesto
    if ([tableView isEditing]) {
        return UITableViewCellEditingStyleDelete;
            } else {
                return UITableViewCellEditingStyleNone;
                    }
}

#pragma mark - Table view delegate

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    //Hago la llamada a el setEditing mayor
    [super setEditing:editing animated:animated];
    
    //Hago un reload para que se recarguen las celdas sin el switch
    //[self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Construyo la vista y le paso la alarma
    nuevaAlarmaVC=[[nuevaAlarmaViewController alloc]init];
    [nuevaAlarmaVC setEditingAlarma:[arrayAlarmas objectAtIndex:[indexPath row]]];
    
    //Anido la vista en un navigation Controller
    naviNuevaAlarma=[[UINavigationController alloc]initWithRootViewController:nuevaAlarmaVC];
    //Le pongo el titulo en negro
    [[naviNuevaAlarma navigationBar]setBarStyle:UIBarStyleBlack];
    
    //Lanzo el modal del navigation controller
    [nuevaAlarmaVC setTituloVentana:NSLocalizedString(@"Editar alarma", @"NavigationEditarAlarma")];
    [self presentModalViewController:naviNuevaAlarma animated:YES];
}

@end
