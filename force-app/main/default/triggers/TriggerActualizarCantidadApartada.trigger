trigger TriggerActualizarCantidadApartada on QuoteLineItem (after insert, after update, before update, before insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            List<QuoteLineItem> qliList = new List<QuoteLineItem>();
            for(QuoteLineItem item: Trigger.new){
                qliList.add(item);
            }
            QuotationHelper.ActualizarCantidadApartadaHelper(qliList, 1);
        }else if(Trigger.isUpdate){
            List<QuoteLineItem> qliList = new List<QuoteLineItem>();
            for(QuoteLineItem item: Trigger.new){
                qliList.add(item);
            }
            QuotationHelper.ActualizarCantidadApartadaHelper(qliList, 1);
        }
    }      
    if(Trigger.isBefore){
        QuotationHelper.ActualizarCantidadApartadaHelper(Trigger.new, 2);
    }
    

}