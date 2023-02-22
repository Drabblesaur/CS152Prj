FUNCT INT adder (INT a, INT b){
    INT c;
    c = a + b;
    RETURN c;
}

FUNCT INT main (){
    INT a;
    INT b;
    INT c;
    a = 1;
    b = 2;
    c = adder(a, b);
    PRINT c;
}