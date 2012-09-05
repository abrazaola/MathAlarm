//
//  nuevaAlarmaViewController.m
//  Despertador
//
//  Created by Aitor Brazaola on 16/05/12.
//  Copyright (c) 2012 Tecniofi. All rights reserved.
//

#import "nuevaAlarmaViewController.h"
#import "listaAlarmasViewController.h"
#import "Alarma.h"
#import "editarTextoViewController.h"
#import "sonidosViewController.h"

@interface nuevaAlarmaViewController ()

@end

@implementation nuevaAlarmaViewController
@synthesize editingAlarma, datePicker, uiTableView, tituloVentana, celdaEstado, arrayAlarmas;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navigationItem=[self navigationItem];
        [navigationItem setTitle:tituloVentana];
        
        [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelar)] animated:YES];
        [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(guardar)] animated:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Creo el sonidosVC y le paso la alarma a editar el sonido
    sonidosVC=[[sonidosViewController alloc]init];
    [sonidosVC setEditingAlarma:editingAlarma];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    //Creo una nueva alarma SOLO si no existe
    if (!editingAlarma) {
        editingAlarma=[[Alarma alloc]init];
    }
    //Poner fecha al datePicker
    [datePicker setDate:[editingAlarma date]];
    
    //Poner nombre a la ventana de nuevo
    [navigationItem setTitle:tituloVentana];
    
    //Preguntar si existe instancia de la edicion del titulo y asignarselo a la alarma
    if(editarVC)
    {
        [editingAlarma setTitle:[editarVC cadena]];
    }
    
    //Refrescar la tabla
    [uiTableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self preservarHora];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Metodos de la clase
-(void)preservarHora
{
    //Algoritmo para quitar los segundos a la hora
    NSDate *dateBruto=[datePicker date];
    
    NSTimeInterval time=round([dateBruto timeIntervalSinceReferenceDate]/60.0)*60.0;
    NSDate *dateSinSegundos=[NSDate dateWithTimeIntervalSinceReferenceDate:time];
    
    [editingAlarma setDate:dateSinSegundos];
    
    //NSLog(@"%@", [dateSinSegundos description]);
}
-(void)guardar
{
    //Compruebo se el user ha dejado el valor de titulo vacio.
    if([[editingAlarma title]isEqualToString:@""])
    {
        UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"ErrorCadenaVacia") message:NSLocalizedString(@"El campo titulo es obligatorio.", @"Titulo en blanco") delegate:self cancelButtonTitle:NSLocalizedString(@"Aceptar", @"BotonAceptarError") otherButtonTitles: nil];
        [alerta show];
    }
    else 
    {
        //Le pongo la fecha que queda en el datepicker
        [self preservarHora];
        
        //Compruebo si no se le ha seteado el sonido, si no tiene sonido le asigno el que tiene por defecto el controlador de vistas de seleccion de sonido.
        if([editingAlarma sonido]==nil)
        {
            [editingAlarma setSonido:[sonidosVC sonidoElegido]];
        }
        
        //Registro la notificación SOLO si su estado es activo
        if([editingAlarma estado])
        {
            [editingAlarma registrarNotificacion];
        }
        else 
        {
            [editingAlarma cancelarNotificacion];
        }
        //Añado la alarma a el array
        [arrayAlarmas addObject:editingAlarma];
        
        //Hago dissmiss de el modal controller
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(void)cancelar
{
    //Cancelo la vista modal
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Acciones de la interfaz

-(IBAction)cambiarEstado:(id)sender
{
    //Solo cambia el estado de la alarma, de registrar la notificación se encargará el VC al salir de la vista en caso de ver que la alarma esta activa
    UISwitch *interruptor=(UISwitch *)[celdaEstado viewWithTag:1];
    [editingAlarma setEstado:[interruptor isOn]];
}

#pragma mark - Delegado de el textview

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    
    return YES;
}

#pragma mark - Data source de la tabla

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
        {
            //Celda etiqueta
            UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            
            // Configure the cell...
            [[cell textLabel]setText:NSLocalizedString(@"Etiqueta", @"CeldaEtiqueta")];
            [[cell detailTextLabel]setText:[editingAlarma title]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            return cell;
        }
            break;
            case 1:
        {
            //Celda Sonidos
            UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            
            if ([editingAlarma sonido]==nil) {
                //Si la alarma esta recien creada y no contiene sonido alguno
                [[cell detailTextLabel]setText:[sonidosVC sonidoElegido]];
            } else {
                //Si lo contiene que lo muestre
                [[cell detailTextLabel]setText:[editingAlarma sonido]];
            }
            [[cell textLabel]setText:NSLocalizedString(@"Sonido", @"CeldaSonidos")];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            return cell;
        }
            break;
            case 2:
        {
            //Celda estado
            UILabel *labelEstado=(UILabel *)[celdaEstado viewWithTag:2];
            [labelEstado setText:NSLocalizedString(@"Estado", @"CeldaEstado")];
            
            UISwitch *interruptor=(UISwitch *)[celdaEstado viewWithTag:1];
            [interruptor setOn:[editingAlarma estado]];
            
            return celdaEstado;
        }
            
        default:
        {
            return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        }
            break;
    }
   }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
        {
            //Modificar titulo
            
            //Creo una ventana de edicion de titulo
            editarVC=[[editarTextoViewController alloc]init];
            //Le pongo el titulo de la alarma
            [editarVC setTituloVentana:[editingAlarma title]];
            //Le indico la cadena a modificar
            [editarVC setCadena:[editingAlarma title]];
            
            [[self navigationController]pushViewController:editarVC animated:YES];
        }
            break;
        case 1:
        {
            //Modificar sonido
            
            //Seteo la alarma a editar en la ventana de edicion de sonidos
            [sonidosVC setEditingAlarma:editingAlarma];
            //Preguntar si existe el sonido elegido en la alarma porque si existe necesito que lo sepa para modificarlo
            if ([editingAlarma sonido]) {
                [sonidosVC setSonidoElegido:[editingAlarma sonido]];
            }
            //Lanzo el vc
            [[self navigationController]pushViewController:sonidosVC animated:YES];
            //Guardo la alarma modificada por el VC en mi editingAlarma
            editingAlarma=[sonidosVC editingAlarma];
        }
            break;
        default:
            break;
    }
}

@end
