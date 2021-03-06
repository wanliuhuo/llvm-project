; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

declare double @llvm.exp.f64(double) nounwind readnone speculatable
declare void @use(double)

; exp(a) * exp(b) no reassoc flags
define double @exp_a_exp_b(double %a, double %b) {
; CHECK-LABEL: @exp_a_exp_b(
; CHECK-NEXT:    [[TMP:%.*]] = call double @llvm.exp.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.exp.f64(double [[B:%.*]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[TMP]], [[TMP1]]
; CHECK-NEXT:    ret double [[MUL]]
;
  %tmp = call double @llvm.exp.f64(double %a)
  %tmp1 = call double @llvm.exp.f64(double %b)
  %mul = fmul double %tmp, %tmp1
  ret double %mul
}

; exp(a) * exp(b) reassoc, multiple uses
define double @exp_a_exp_b_multiple_uses(double %a, double %b) {
; CHECK-LABEL: @exp_a_exp_b_multiple_uses(
; CHECK-NEXT:    [[TMP:%.*]] = call double @llvm.exp.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.exp.f64(double [[B:%.*]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul reassoc double [[TMP]], [[TMP1]]
; CHECK-NEXT:    call void @use(double [[TMP1]])
; CHECK-NEXT:    ret double [[MUL]]
;
  %tmp = call double @llvm.exp.f64(double %a)
  %tmp1 = call double @llvm.exp.f64(double %b)
  %mul = fmul reassoc double %tmp, %tmp1
  call void @use(double %tmp1)
  ret double %mul
}

; exp(a) * exp(b) reassoc, both with multiple uses
define double @exp_a_exp_b_multiple_uses_both(double %a, double %b) {
; CHECK-LABEL: @exp_a_exp_b_multiple_uses_both(
; CHECK-NEXT:    [[TMP:%.*]] = call double @llvm.exp.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.exp.f64(double [[B:%.*]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul reassoc double [[TMP]], [[TMP1]]
; CHECK-NEXT:    call void @use(double [[TMP]])
; CHECK-NEXT:    call void @use(double [[TMP1]])
; CHECK-NEXT:    ret double [[MUL]]
;
  %tmp = call double @llvm.exp.f64(double %a)
  %tmp1 = call double @llvm.exp.f64(double %b)
  %mul = fmul reassoc double %tmp, %tmp1
  call void @use(double %tmp)
  call void @use(double %tmp1)
  ret double %mul
}

; exp(a) * exp(b) => exp(a+b) with reassoc
define double @exp_a_exp_b_reassoc(double %a, double %b) {
; CHECK-LABEL: @exp_a_exp_b_reassoc(
; CHECK-NEXT:    [[TMP:%.*]] = call double @llvm.exp.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.exp.f64(double [[B:%.*]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul reassoc double [[TMP]], [[TMP1]]
; CHECK-NEXT:    ret double [[MUL]]
;
  %tmp = call double @llvm.exp.f64(double %a)
  %tmp1 = call double @llvm.exp.f64(double %b)
  %mul = fmul reassoc double %tmp, %tmp1
  ret double %mul
}

; exp(a) * exp(b) * exp(c) * exp(d) => exp(a+b+c+d) with reassoc
define double @exp_a_exp_b_exp_c_exp_d_fast(double %a, double %b, double %c, double %d) {
; CHECK-LABEL: @exp_a_exp_b_exp_c_exp_d_fast(
; CHECK-NEXT:    [[TMP:%.*]] = call double @llvm.exp.f64(double [[A:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.exp.f64(double [[B:%.*]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul reassoc double [[TMP]], [[TMP1]]
; CHECK-NEXT:    [[TMP2:%.*]] = call double @llvm.exp.f64(double [[C:%.*]])
; CHECK-NEXT:    [[MUL1:%.*]] = fmul reassoc double [[MUL]], [[TMP2]]
; CHECK-NEXT:    [[TMP3:%.*]] = call double @llvm.exp.f64(double [[D:%.*]])
; CHECK-NEXT:    [[MUL2:%.*]] = fmul reassoc double [[MUL1]], [[TMP3]]
; CHECK-NEXT:    ret double [[MUL2]]
;
  %tmp = call double @llvm.exp.f64(double %a)
  %tmp1 = call double @llvm.exp.f64(double %b)
  %mul = fmul reassoc double %tmp, %tmp1
  %tmp2 = call double @llvm.exp.f64(double %c)
  %mul1 = fmul reassoc double %mul, %tmp2
  %tmp3 = call double @llvm.exp.f64(double %d)
  %mul2 = fmul reassoc double %mul1, %tmp3
  ret double %mul2
}
