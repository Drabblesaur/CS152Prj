FUNCT INT add_Years <-(INT age, INT years){
	RETURN age+years;
}

FUNCT NONE main <-(){
	INT age[5] -> [11,2,50,4,5]; # Array of ages
	INT _years; # years to use
	INT a_N_s; # answer
	INT wrong_, wr0ng, 0wrong, wrong0; 
	INT wr0ng_, 0wrong0;

	a_N_s -> age[0] - 1;
	a_N_s -> age[1] * 2;
	a_N_s -> age[2] / 5;
	a_N_s -> age[3] + 10;
	a_N_s -> age[4] MOD 2;

	IF(a_N_s = 2);
	ELSE IF(a_N_s ~= 10);
	ELSE IF(a_N_s <	5);
	ELSE IF(a_N_s > 20);
	ELSE {
		READ _years;
		a_N_s -> _years;
	}
	
	#* scanner
	skips
	this
	*#

	DO{	
		a_N_s -> add_Years(a_N_s + _years);
		IF(a_N_s <= 10);
		ELSE IF(a_N_s >= 11);
		PRINT(a_N_s);
	}WHILE(a_N_s <= 20);
}
