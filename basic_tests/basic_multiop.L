#TESTS FOR: Variable Declaration + Operations + Print

FUNCT INT main <-(){
    INT a;
    INT b;
    INT c;
    INT d;
    INT e;

    a -> 100;
    b -> 50;
    d -> -1;
    e -> 150;
    c -> d*(a + b) + e;
    PRINT(c); #EXPECTED: 0s
}