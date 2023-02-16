FUNCT INT factorial <- (INT k;){
        IF(k <= 1){
            RETURN 1;
        };
    RETURN k * factorial(k -- 1);
}

FUNCT INT main <- (){
        INT n;
        INT fac;
        READ(n);
        fac -> factorial(n);
        PRINT(fac);
}

