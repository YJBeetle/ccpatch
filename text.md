# AI

## Feature

1. 
	* Find SUBROUTINE has "aInJsonValueRes"
	  ("in Json::Value::resolveReference(key, end): requires objectValue")
	* Find first instruction looks like
		```
		TEST	xx, xx
		JZ	xxx
		```
	* Change to
		```
		MOV	xx, 0x1
		JZ	xxx
		```

## Version

### Win 23.0.3

* 0x14030DCED (0x30D0ED): 84 C0 -> B0 01
  or find: 0F B6 41 08 **84 C0** 74 0A 3C 07 -> 0F B6 41 08 **B0 01** 74 0A 3C 07

### Mac 23.0.4

* 0x49C5AC: 84 DB -> B3 01
  or find: 66 41 8B 5E 08 **84 DB** 74 09 80 FB 07 -> 66 41 8B 5E 08 **B3 01** 74 09 80 FB 07

# PS

## Feature

1. 
	* Find SUBROUTINE has "aInJsonValueRes" ("in Json::Value::resolveReference(key, end): requires objectValue")
	* Find first instruction looks like
		```
		TEST	xx, xx
		JZ	xxx
		```
	* Change to
		```
		MOV	xx, 0x1
		JZ	xxx
		```

## Version

