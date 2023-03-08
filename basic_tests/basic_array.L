FUNCT INT main <-(){
    INT a[20];
    INT b;
    INT c;
    b -> 3;
    c -> 5;
    a[0] -> b + c;
    PRINT(a[0]);
    
    a[1] -> 100;
    PRINT(a[1]);

    a[2] -> 200;
    PRINT(a[2]);

    a[3] -> a[0] * (a[1] + c);
    PRINT(a[3]);
}