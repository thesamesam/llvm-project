; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Fold
;   x s/EXACT (-1 << y)
; to
;   -(x a>>EXACT y)

define i8 @t0(i8 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[DIV_NEG:%.*]] = ashr exact i8 [[X:%.*]], 5
; CHECK-NEXT:    [[DIV:%.*]] = sub nsw i8 0, [[DIV_NEG]]
; CHECK-NEXT:    ret i8 [[DIV]]
;
  %div = sdiv exact i8 %x, -32
  ret i8 %div
}

define i8 @n1(i8 %x) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i8 [[X:%.*]], -32
; CHECK-NEXT:    ret i8 [[DIV]]
;
  %div = sdiv i8 %x, -32 ; not exact
  ret i8 %div
}

define <2 x i8> @t2_vec_splat(<2 x i8> %x) {
; CHECK-LABEL: @t2_vec_splat(
; CHECK-NEXT:    [[DIV_NEG:%.*]] = ashr exact <2 x i8> [[X:%.*]], <i8 5, i8 5>
; CHECK-NEXT:    [[DIV:%.*]] = sub nsw <2 x i8> zeroinitializer, [[DIV_NEG]]
; CHECK-NEXT:    ret <2 x i8> [[DIV]]
;
  %div = sdiv exact <2 x i8> %x, <i8 -32, i8 -32>
  ret <2 x i8> %div
}

define <2 x i8> @t3_vec(<2 x i8> %x) {
; CHECK-LABEL: @t3_vec(
; CHECK-NEXT:    [[DIV_NEG:%.*]] = ashr exact <2 x i8> [[X:%.*]], <i8 5, i8 4>
; CHECK-NEXT:    [[DIV:%.*]] = sub <2 x i8> zeroinitializer, [[DIV_NEG]]
; CHECK-NEXT:    ret <2 x i8> [[DIV]]
;
  %div = sdiv exact <2 x i8> %x, <i8 -32, i8 -16>
  ret <2 x i8> %div
}

define <2 x i8> @n4_vec_mixed(<2 x i8> %x) {
; CHECK-LABEL: @n4_vec_mixed(
; CHECK-NEXT:    [[DIV:%.*]] = sdiv exact <2 x i8> [[X:%.*]], <i8 -32, i8 16>
; CHECK-NEXT:    ret <2 x i8> [[DIV]]
;
  %div = sdiv exact <2 x i8> %x, <i8 -32, i8 16>
  ret <2 x i8> %div
}

define <2 x i8> @n4_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @n4_vec_undef(
; CHECK-NEXT:    ret <2 x i8> poison
;
  %div = sdiv exact <2 x i8> %x, <i8 -32, i8 undef>
  ret <2 x i8> %div
}
