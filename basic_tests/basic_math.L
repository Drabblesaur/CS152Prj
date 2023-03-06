FUNCT INT main <-(){
    INT a;
    INT b;
    INT c;
    a -> 100;
    b -> 5;
    # Addition, answer is 150, since 150 := 100+50
    c -> a + b;
    PRINT(c);
    # Subtraction, answer is 50, since 50 := 100-50
    c -> a - b;
    PRINT(c);
    # Multiplication, answer is 5000, since 5000 := 100 * 50
    c -> a * b;
    PRINT(c);
    # Division, answer is 2, since 2 := 100/50
    c -> a / b;
    PRINT(c);
    # Modulus, answer is 0, since 0 := 100 % 50
    c -> a MOD b;
    PRINT(c);
}
