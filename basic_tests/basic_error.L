#TESTS FOR: Variable Declaration + Addition + Print

FUNCT INT main <-(){
    INT a;
    INT b;
    a -> 100;
    b -> 50;
    c -> a + b; #c was not initialized
    PRINT(c);
}