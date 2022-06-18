import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import buscarProducto from '@salesforce/apex/LWCQuoteController.buscarProducto';

export default class BusquedaDeProducto extends LightningElement {

    @track productRecord;
    @track productoBuscado;
    @track prod;

    showTost(title, message, variant){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    cambiarProductoBuscado(event){
        this.productoBuscado = event.target.value;
        //console.log('cambia palabra'+ this.productoBuscado);
    }

    searchProduct(event){
        //console.log("funciona El botón buscar");
        buscarProducto({codigoProducto: this.productoBuscado})
        .then(result =>{
            console.log("respuesta recibida de apex: "+result);
        })
        .catch(error =>{
            console.log(error);
        })
    }
}