// apexWireMethodToProperty.js
import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';

export default class apexWireMethodToProperty extends LightningElement{
    @wire(getContactList) contacts;
}