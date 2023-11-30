Reset:
	LDB_DIR 0040  ; Load toggle button into B
	LDA_IMM 0  ; Put 0 into A
	ADD_AB  ; Add A and B to set status register
	BEQ Reset
	LDA_IMM 80  ; Load 80 into A register
	STA_DIR 0020  ; Store A into Video Card Register
	BRA Reset
