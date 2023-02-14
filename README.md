# CS152: L Language Description

## Language Name: L Lang

## Extension Name: .L

```
# File Name Examples
hello.L
sadge.L
Basic_Example.L
```

## Compiler Name: TakeL

### Description

Another day another L…

- L Lang is *case sensitive*. All reserved words are expressed in upper case.
- Whitespace is ignored in L Lang.
- Valid identifiers in L Lang must begin with a letter or underscore, may be followed by any letters or underscores, and cannot end in an underscore.
- Identifiers cannot contain ANY whitespace, special characters, or numbers. Examples below.

```
#Valid & Invalid vars examples

#=====VALID=====
INT vars -> 12;
INT _VaLuEs -> 13;
INT Hello____World -> 476;

#=====INVALID=====
INT @Vars -> 12;
INT Hello World -> 13;
INT 2BeorNot2B -> 2;
```

## Basic Features

### Integer scalar variables

Example:

```
INT var_name;
INT age;
INT width, height; # can define n amount of vars in one line.
```

### 1-D Arrays of Ints

Example:

```
INT vals[] -> [1,2,3,4,5];
INT age[5] -> [11,2,53,4,5];
INT sum[5]; #This is what sum would have [0,0,0,0,0]
```

### Assignment Statement

Example:

```
INT nums -> 22;
INT age[5] -> [11,2,53,4,5];
```

### Arithmetic Statements

Example:

```
+  #Addition
INT Sum -> 12+36;

-  #Subtraction
INT Sub -> 36-12;

*  #Multiplication
INT Mult -> 12*3;

/  #Division
INT Div -> 12/6;

MOD #Remainder
INT rem -> 12 MOD 3;
 
```

### Relational Operators

Example:

```
=  #Relational Equal
3=3;

~= # Not equal
2~=3;

>  #Greater than
56>12;

>= #Greater Than or equal to
56>=56;

<  #Less than
12<56;

<= #Less Than or equal to
56<=56;

```

### While / Do While Loops

Example:

```
WHILE(condition){
	#Code goes here
}

# Do While Loop
DO{

	#code goes here

}WHILE(condition)
```

### If-Then-Else Statements

Example:

```
IF(condtion){
	#code goes here
}

ELSE IF(condition){
	#code goes here
}

ELSE(condition){
	#code goes here
} 
```

### Read / Write Statements

Example:

```
PRINT(var);
PRINTLN(var); #Prints with a new Line
```

### Comments

Example:

```

# This is a comment! (Single Line)

#* 

This is a multiline comment 

*#
```

### Functions

Example:

```
return_type Function_Name <-(INT Nums, STR msg){

	return ITEM
}

Function_Name <-();

#example
INT sum <-(INT[] list_nums){}

#Function call (with var)
sum <-(list_nums);

NONE show_val <-(){}

#Function vall (no var)
show_val <-();

```
```
#Full Function Example
INT sum_List <-(INT[] list_nums,INT length){
	startBody;
		startLocal;
			INT sum -> 0;
			INT len -> 0;
		endLocal;
		WHILE(len < length){
			sum -> (sum+list_nums[len]);
		}
	endBody;
	return sum;
}
```

## Symbol Tables

### RESERVED WORDS

| Symbol | Token Name |
| --- | --- |
| INT | INT |
| WHILE | WHILE |
| DO | DO | 
| FOR | FOR |
| IF | IF |
| ELSE IF | ELSE_IF |
| ELSE | ELSE |
| PRINT | PRINT |
| TRUE | TRUE | 
| FALSE | FALSE | 
| FUNCT | FUNCT_CALL |
| BEGINBODY | BEGINBODY |
| ENDBODY | ENDBODY |
| BEGINLOCAL | BEGINLOCAL |
| ENDLOCAL | ENDLOCAL| 

### ARITHMATIC OPERATORS

| Symbol | Token Name |
| --- | --- |
| + | PLUS |
| - | MINUS |
| * | MULT|
| / | DIV |
| ! | FACT|
| MOD | MOD |

### RELATIONAL OPERATORS

| Symbol | Token Name |
| --- | --- |
| = | EQ |
| ~= | NEQ |
| > | GT |
| >= | GTE |
| < | LT |
| <= | LTE |

### IDENTIFIERS AND NUMBERS

| Symbol | Token Name |
| --- | --- |
| identifier (e.g., "_lLang", "BiggesTBird", "TT_TT", "insec") | VAR_NAME XXXX [where XXXX is the identifier itself] |
| number (e.g., "40", "4389", "3", "948082") | NUMBER XXXX [where XXXX is the number itself] |

### OTHER SPECIAL SYMBOLS

| Symbol | Token Name |
| --- | --- |
| -> | ASSIGNMENT |
| <- | FUNCT_PARAMS |
| ; | SEMICOLON |
| , | COMMA |
| [  | LSB |
| ] | RSB |
| {  | LCB |
| } | RCB |
| ( | LPR |
| ) | RPR|
