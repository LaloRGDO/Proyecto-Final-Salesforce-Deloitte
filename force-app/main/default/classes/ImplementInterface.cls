public with sharing class ImplementInterface implements InterfacePractice{

    public void metodo1(){
        System.debug('Este es mi método 1 Yeey');
    }

    public String metodo2(){
        return 'Eduardo';
    }

    public void metodo3(String param1){
        System.debug('Hola '+ param1);
    }
}
