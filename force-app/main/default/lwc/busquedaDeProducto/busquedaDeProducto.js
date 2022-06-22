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
    @track priceBookEntryId;
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
                    this.informacion = Object.values(result)[0];
                    this.productId = this.informacion['Id'];
                    this.nombreProducto  = this.informacion['Name'];
                    this.productCode = this.informacion['ProductCode'];
                    this.priceBookEntryId = this.informacion['PricebookEntries'][0]['Id'];
                    this.listPrice = this.informacion['PricebookEntries'][0]['UnitPrice']
                    this.cantidadDisponible = this.informacion['Inventarios_Custom__r'][0]['Cantidad_dis__c'];
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
        console.log(typeof(this.priceBookId)+' '+this.priceBookEntryId);
        console.log(typeof(this.recordId)+' '+this.recordId);

        if(this.quantity <= this.cantidadDisponible){
            crearQli({
                productId: this.productId,
                cantidadApart: this.quantity,
                unitPrice: this.listPrice,
                pbeId: this.priceBookEntryId,
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
            this.mostrarTabla = false;
            this.productoBuscado = '';
            this.quantity = '';
            const input = this.template.querySelector('.input');
            input.value = '';
        }else{
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'La cantidad a apartar no puede ser mayor a la cantidad disponible',
                variant:'error',
            });
            this.dispatchEvent(event);
        }
    }
}