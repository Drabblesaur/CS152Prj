FUNCT factorial <- (INT k){
    beginBody
        beginLocal
            INT k;
        endLocal
        IF(k<=1){
            return 1;
        }
    endBody
    return k*factorial(k-1);
}

FUNCT main <- (){
    beginBody
        beginLocal
            INT n;
            INT fac;
        endLocal
        READ n;
        fac <- factorial(n);
        PRINT(fac);
    endBody
    return 0;
}