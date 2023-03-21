# Tests for if-else statements 

FUNCT INT main <-(){
    INT a; 
    INT b;
    INT c;

    a -> 100; 
    b -> 50; 

    IF(a < b){
        c -> 50;
    }ELSE{
        c -> 100;
    }
    PRINT(c);
}
