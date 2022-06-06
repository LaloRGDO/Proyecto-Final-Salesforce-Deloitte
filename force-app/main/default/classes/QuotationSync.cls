public interface QuotationSync {
    boolean confirmProductExistByCode(String productCode);
    double searchProductByCode(String productCode);
}
