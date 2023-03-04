FUNCT INT add<-(INT a, INT b){
    RETURN a + b;
}

FUNCT INT mult<-(INT a, INT b){
    RETURN a * b;
}

FUNCT INT main<-(){
    INT a;
    INT b;
    INT c;
    INT d;

    a -> 100;
    b -> 50;
    c -> add(a, b);
    PRINT(c);

    d -> mult(c, a + b);
    write(d);
}