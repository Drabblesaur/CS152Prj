#TESTS FOR: Using variable 'c' without it being declared first

FUNCT INT main <-(){
    INT a;
    INT b;
    a -> 100;
    b -> 50;
    c -> a + b;
    PRINT(c);
}