# This is a nested loop 

FUNCT INT main<-(){
	INT i -> 0, INT j -> 0;

	WHILE(I < 2){
		j -> 1;
    		WHILE(j <= 3){
			PRINT(j);
      			j -> j + 1;
		}
		i -> i + 1;
	}
}

