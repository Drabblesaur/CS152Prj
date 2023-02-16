FUNCT factorial <- (INT k){
        BEGINLOCAL
            INT k;
        ENDLOCAL
        IF(k<=1){
            return 1;
        };
    RETURN k*factorial(k-1);
}

FUNCT main <- (){
        BEGINLOCAL
            INT n;
            INT fac;
        ENDLOCAL
        READ n;
        fac <- factorial(n);
        PRINT(fac);
    return 0;
}