#Test for nested loops 

FUNCT INT main <-(){
    INT i;
    INT j;

    i -> 0; 

    WHILE(i < 2){
        j -> 1;
        WHILE( j <= 3){
            PRINT(j);
            j -> j + 1;
        }
        i -> i + 1;
    }
}