FUNCT INT fibonacci <- (INT k){
	IF (k <= 1){
		RETURN 1;
	};
	RETURN fibonacci(k - 1) + fibonacci(k - 2);
}

FUNCT INT main <- (){
	INT n;
	INT fib_n;
	READ(n);
	fib_n -> fibonacci(n);
	PRINT(fib_n);
}

