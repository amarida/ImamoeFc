.ifndef add_score
add_score = 1

.macro AddScore addr
	clc
	lda score_b0
	adc addr
	sta score_b0

	lda score_b1
	adc #0
	sta score_b1
.endmacro

.endif
