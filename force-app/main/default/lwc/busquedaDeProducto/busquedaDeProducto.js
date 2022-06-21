import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import buscarProducto from '@salesforce/apex/LWCQuoteController.buscarProducto';
import crearQli from '@salesforce/apex/LWCQuoteController.crearQli';

export default class BusquedaDeProducto extends LightningElement {

    @track productRecord;
    @track productoBuscado = '';
    @track prod;
    @track informacion;
    @track nombreProducto;
    @track listPrice;
    @track productCode;
    @track cantidadDisponible;
    @track cantidadApartada;
    @track mostrarTabla = false;
    @track productId;
    @track quantity = '';
    @track priceBookId;
    @api recordId;

    cambiarProductoBuscado(event){
        this.productoBuscado = event.target.value;
        //console.log('cambia palabra'+ this.productoBuscado);
    }

    agregarCantidad(event){
        this.quantity = parseInt(event.target.value);
    }

    searchProduct(event){
        //console.log(this.productoBuscado);
        if(this.productoBuscado != '' || this.productoBuscado != null){
            buscarProducto({codigoProducto: this.productoBuscado})
            .then(result =>{
                if(result != null){
                    this.mostrarTabla = true;
                    // console.log("respuesta recibida de apex: "+result);
                    // console.log(Object.values(result)[0]['Name']);
                    // console.log(Object.keys(Object.values(result)[0]));
                    this.informacion = Object.values(result)[0];
                    // console.log(this.informacion['Id']);
                    this.productId = this.informacion['Id'];
                    // console.log(this.informacion['Name']);
                    this.nombreProducto  = this.informacion['Name'];
                    // console.log(this.informacion['ProductCode']);
                    this.productCode = this.informacion['ProductCode'];
                    // console.log(typeof(this.informacion['PricebookEntries']));
                    // console.log(this.informacion['PricebookEntries'][0]['UnitPrice']);
                    this.priceBookId = this.informacion['PricebookEntries'][0]['Id'];
                    this.listPrice = this.informacion['PricebookEntries'][0]['UnitPrice'];
                    // console.log(this.informacion['Inventarios_Custom__r'][0]['Cantidad_dis__c']);
                    this.cantidadDisponible = this.informacion['Inventarios_Custom__r'][0]['Cantidad_dis__c'];
                    // console.log(this.informacion['Inventarios_Custom__r'][0]['Cantidad_apart__c']);
                }else{
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message:'Producto no encontrado, por favor verifica que el Codigo esté bien escrito',
                        variant:'error',
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error =>{
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant:'error',
                });
                this.dispatchEvent(event);
            })
        }else{
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Ingresa un Código de producto para poder realizar la búsqueda',
                variant:'error',
            });
            this.dispatchEvent(event);
        }
    }

    atras(event){
        this.mostrarTabla = false;
        this.productoBuscado = '';
        this.quantity = '';
        const input = this.template.querySelector('.input');
        input.value = '';
    }

    guardar(event){
        
        console.log(typeof(this.productId)+' '+this.productId);
        console.log(typeof(this.quantity)+' '+this.quantity);
        console.log(typeof(this.listPrice)+' '+this.listPrice);
        console.log(typeof(this.priceBookId)+' '+this.priceBookId);
        console.log(typeof(this.recordId)+' '+this.recordId);


        crearQli({
            productId: this.productId,
            cantidadApart: this.quantity,
            unitPrice: this.listPrice,
            pbeId: this.priceBookId,
            QuoteId: this.recordId
        })
        .then(result=>{
            console.log(result);
            const event = new ShowToastEvent({
                title: 'New Quote Line Item created',
                message: 'Se ha agregado correctamente el Quote Line Item',
                variant:'success',
            });
            this.dispatchEvent(event);
        })
        .catch(error=>{
            console.log(error);
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Error al agregar el Quote Line Item',
                variant:'error',
            });
            this.dispatchEvent(event);
        })
    }
}