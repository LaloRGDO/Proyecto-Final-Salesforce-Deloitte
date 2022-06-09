trigger TriggerActualizarCantidadApartada on QuoteLineItem (after insert, after update) {
    QuotationHelper.ActualizarCantidadApartadaHelper(Trigger.new);
}