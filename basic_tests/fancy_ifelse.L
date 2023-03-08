# Tests for if-else statements 

FUNCT INT main <-(){
    INT a -> 100; 
    INT b -> 50;
    INT c;

    IF(a < b){
        c -> 50;
    }ELSE{
        c -> 100;
    };
    PRINT(c);
}