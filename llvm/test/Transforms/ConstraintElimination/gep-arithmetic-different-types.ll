; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare void @llvm.assume(i1 noundef) #0

define i1 @gep_constant_positive_index(ptr %A, ptr %upper) {
; CHECK-LABEL: @gep_constant_positive_index(
; CHECK-NEXT:    [[ADD_I8_4:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i64 4
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_4]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[ADD_I16_4:%.*]] = getelementptr inbounds i16, ptr [[A]], i64 4
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I16_4]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I16_2:%.*]] = getelementptr inbounds i16, ptr [[A]], i64 2
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I16_2]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], true
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %add.i8.4 = getelementptr inbounds i8, ptr %A, i64 4
  %c.0 = icmp ult ptr %add.i8.4, %upper
  call void @llvm.assume(i1 %c.0)

  %add.i16.4 = getelementptr inbounds i16, ptr %A, i64 4
  %c.1 = icmp ult ptr %add.i16.4, %upper

  %add.i16.2 = getelementptr inbounds i16, ptr %A, i64 2
  %t.1 = icmp ult ptr %add.i16.2, %upper
  %res.1 = xor i1 %c.1, %t.1
  ret i1 %res.1
}

define i1 @gep_constant_positive_index_chained(ptr %A, ptr %upper) {
; CHECK-LABEL: @gep_constant_positive_index_chained(
; CHECK-NEXT:    [[ADD_I8_4:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i64 4
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_4]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[ADD_I8_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 1
; CHECK-NEXT:    [[ADD_I16_1:%.*]] = getelementptr inbounds i16, ptr [[ADD_I8_1]], i64 1
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I16_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I16_2:%.*]] = getelementptr inbounds i16, ptr [[ADD_I8_1]], i64 2
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I16_2]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 true, [[C_1]]
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %add.i8.4 = getelementptr inbounds i8, ptr %A, i64 4
  %c.0 = icmp ult ptr %add.i8.4, %upper
  call void @llvm.assume(i1 %c.0)

  %add.i8.1 = getelementptr inbounds i8, ptr %A, i64 1

  %add.i16.1 = getelementptr inbounds i16, ptr %add.i8.1, i64 1
  %t.1 = icmp ult ptr %add.i16.1, %upper
  %add.i16.2 = getelementptr inbounds i16, ptr %add.i8.1, i64 2
  %c.1 = icmp ult ptr %add.i16.2, %upper
  %res.1 = xor i1 %t.1, %c.1
  ret i1 %res.1
}

define i1 @gep_var_positive_index(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_var_positive_index(
; CHECK-NEXT:    [[IDX_POS:%.*]] = icmp sge i8 [[IDX:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[IDX_POS]])
; CHECK-NEXT:    [[ADD_I16_IDX:%.*]] = getelementptr inbounds i16, ptr [[A:%.*]], i8 [[IDX]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I16_IDX]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[ADD_I32_IDX:%.*]] = getelementptr inbounds i32, ptr [[A]], i8 [[IDX]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX:%.*]] = getelementptr inbounds i8, ptr [[A]], i8 [[IDX]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], true
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %idx.pos = icmp sge i8 %idx, 0
  call void @llvm.assume(i1 %idx.pos)
  %add.i16.idx = getelementptr inbounds i16, ptr %A, i8 %idx
  %c.0 = icmp ult ptr %add.i16.idx, %upper
  call void @llvm.assume(i1 %c.0)

  %add.i32.idx = getelementptr inbounds i32, ptr %A, i8 %idx
  %c.1 = icmp ult ptr %add.i32.idx, %upper
  %add.i8.idx = getelementptr inbounds i8, ptr %A, i8 %idx
  %t.1 = icmp ult ptr %add.i8.idx, %upper
  %res.1 = xor i1 %c.1, %t.1
  ret i1 %res.1
}

define i1 @gep_add_nsw_positive_index(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_add_nsw_positive_index(
; CHECK-NEXT:    [[IDX_POS:%.*]] = icmp sge i8 [[IDX:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[IDX_POS]])
; CHECK-NEXT:    [[IDX_3:%.*]] = add nsw i8 [[IDX]], 3
; CHECK-NEXT:    [[ADD_I8_IDX_3:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i8 [[IDX_3]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_IDX_3]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_1:%.*]] = add nsw i8 [[IDX]], 1
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], true
; CHECK-NEXT:    [[ADD_I16_IDX_1:%.*]] = getelementptr inbounds i16, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult ptr [[ADD_I16_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_2]]
; CHECK-NEXT:    ret i1 [[RES_2]]
;
  %idx.pos = icmp sge i8 %idx, 0
  call void @llvm.assume(i1 %idx.pos)
  %idx.3 = add nsw i8 %idx, 3
  %add.i8.idx.3 = getelementptr inbounds i8, ptr %A, i8 %idx.3
  %c.0 = icmp ult ptr %add.i8.idx.3, %upper
  call void @llvm.assume(i1 %c.0)

  %idx.1 = add nsw i8 %idx, 1
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i8 %idx.1
  %c.1 = icmp ult ptr %add.i32.idx.1, %upper
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i8 %idx.1
  %t.1 = icmp ult ptr %add.i8.idx.1, %upper
  %res.1 = xor i1 %c.1, %t.1

  %add.i16.idx.1 = getelementptr inbounds i16, ptr %A, i8 %idx.1
  %c.2 = icmp ult ptr %add.i16.idx.1, %upper
  %res.2 = xor i1 %res.1, %c.2
  ret i1 %res.2
}


define i1 @gep_shl_nsw_positive_index(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_shl_nsw_positive_index(
; CHECK-NEXT:    [[IDX_POS:%.*]] = icmp sge i8 [[IDX:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[IDX_POS]])
; CHECK-NEXT:    [[IDX_2:%.*]] = shl nsw i8 [[IDX]], 2
; CHECK-NEXT:    [[ADD_I8_IDX_2:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i8 [[IDX_2]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_IDX_2]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_1:%.*]] = shl nsw i8 [[IDX]], 1
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], true
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %idx.pos = icmp sge i8 %idx, 0
  call void @llvm.assume(i1 %idx.pos)
  %idx.2 = shl nsw i8 %idx, 2
  %add.i8.idx.2 = getelementptr inbounds i8, ptr %A, i8 %idx.2
  %c.0 = icmp ult ptr %add.i8.idx.2, %upper
  call void @llvm.assume(i1 %c.0)

  %idx.1 = shl nsw i8 %idx, 1
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i8 %idx.1
  %c.1 = icmp ult ptr %add.i32.idx.1, %upper
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i8 %idx.1
  %t.1 = icmp ult ptr %add.i8.idx.1, %upper
  %res.1 = xor i1 %c.1, %t.1
  ret i1 %res.1
}

define i1 @gep_zext_add_nuw_nsw_index(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_zext_add_nuw_nsw_index(
; CHECK-NEXT:    [[IDX_3:%.*]] = add nuw nsw i8 [[IDX:%.*]], 3
; CHECK-NEXT:    [[IDX_3_EXT:%.*]] = zext i8 [[IDX_3]] to i16
; CHECK-NEXT:    [[ADD_I8_IDX_3:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i16 [[IDX_3_EXT]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_IDX_3]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_1:%.*]] = add nuw nsw i8 [[IDX]], 1
; CHECK-NEXT:    [[IDX_1_EXT:%.*]] = zext i8 [[IDX_1]] to i16
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], true
; CHECK-NEXT:    [[ADD_I16_IDX_1:%.*]] = getelementptr inbounds i16, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult ptr [[ADD_I16_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_2]]
; CHECK-NEXT:    ret i1 [[RES_2]]
;
  %idx.3 = add nuw nsw i8 %idx, 3
  %idx.3.ext = zext i8 %idx.3 to i16
  %add.i8.idx.3 = getelementptr inbounds i8, ptr %A, i16 %idx.3.ext
  %c.0 = icmp ult ptr %add.i8.idx.3, %upper
  call void @llvm.assume(i1 %c.0)

  %idx.1 = add nuw nsw i8 %idx, 1
  %idx.1.ext = zext i8 %idx.1 to i16
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i16 %idx.1.ext
  %c.1 = icmp ult ptr %add.i32.idx.1, %upper
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i16 %idx.1.ext
  %t.1 = icmp ult ptr %add.i8.idx.1, %upper
  %res.1 = xor i1 %c.1, %t.1

  %add.i16.idx.1 = getelementptr inbounds i16, ptr %A, i16 %idx.1.ext
  %c.2 = icmp ult ptr %add.i16.idx.1, %upper
  %res.2 = xor i1 %res.1, %c.2

  ret i1 %res.2
}

define i1 @gep_zext_add_nuw_index(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_zext_add_nuw_index(
; CHECK-NEXT:    [[IDX_2:%.*]] = add nuw i8 [[IDX:%.*]], 2
; CHECK-NEXT:    [[IDX_2_EXT:%.*]] = zext i8 [[IDX_2]] to i16
; CHECK-NEXT:    [[ADD_I8_IDX_2:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i16 [[IDX_2_EXT]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_IDX_2]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_1:%.*]] = add nuw i8 [[IDX]], 1
; CHECK-NEXT:    [[IDX_1_EXT:%.*]] = zext i8 [[IDX_1]] to i16
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], [[T_1]]
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %idx.2 = add nuw i8 %idx, 2
  %idx.2.ext = zext i8 %idx.2 to i16
  %add.i8.idx.2 = getelementptr inbounds i8, ptr %A, i16 %idx.2.ext
  %c.0 = icmp ult ptr %add.i8.idx.2, %upper
  call void @llvm.assume(i1 %c.0)

  %idx.1 = add nuw i8 %idx, 1
  %idx.1.ext = zext i8 %idx.1 to i16
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i16 %idx.1.ext
  %c.1 = icmp ult ptr %add.i32.idx.1, %upper
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i16 %idx.1.ext
  %t.1 = icmp ult ptr %add.i8.idx.1, %upper
  %res.1 = xor i1 %c.1, %t.1
  ret i1 %res.1
}

define i1 @gep_zext_add_nsw_index(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_zext_add_nsw_index(
; CHECK-NEXT:    [[IDX_2:%.*]] = add nsw i8 [[IDX:%.*]], 2
; CHECK-NEXT:    [[IDX_2_EXT:%.*]] = zext i8 [[IDX_2]] to i16
; CHECK-NEXT:    [[ADD_I8_IDX_2:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i16 [[IDX_2_EXT]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_IDX_2]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_1:%.*]] = add nsw i8 [[IDX]], 1
; CHECK-NEXT:    [[IDX_1_EXT:%.*]] = zext i8 [[IDX_1]] to i16
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], [[T_1]]
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %idx.2 = add nsw i8 %idx, 2
  %idx.2.ext = zext i8 %idx.2 to i16
  %add.i8.idx.2 = getelementptr inbounds i8, ptr %A, i16 %idx.2.ext
  %c.0 = icmp ult ptr %add.i8.idx.2, %upper
  call void @llvm.assume(i1 %c.0)

  %idx.1 = add nsw i8 %idx, 1
  %idx.1.ext = zext i8 %idx.1 to i16
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i16 %idx.1.ext
  %c.1 = icmp ult ptr %add.i32.idx.1, %upper
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i16 %idx.1.ext
  %t.1 = icmp ult ptr %add.i8.idx.1, %upper
  %res.1 = xor i1 %c.1, %t.1
  ret i1 %res.1
}

define i1 @gep_zext_index(ptr %A, ptr %upper, i8 %idx.1, i8 %idx.2) {
; CHECK-LABEL: @gep_zext_index(
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult i8 [[IDX_1:%.*]], [[IDX_2:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_2_EXT:%.*]] = zext i8 [[IDX_2]] to i16
; CHECK-NEXT:    [[ADD_I8_IDX_2:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i16 [[IDX_2_EXT]]
; CHECK-NEXT:    [[IDX_1_EXT:%.*]] = zext i8 [[IDX_1]] to i16
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[ADD_I8_IDX_2]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[ADD_I8_IDX_2]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], true
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %c.0 = icmp ult i8 %idx.1, %idx.2
  call void @llvm.assume(i1 %c.0)


  %idx.2.ext = zext i8 %idx.2 to i16
  %add.i8.idx.2 = getelementptr inbounds i8, ptr %A, i16 %idx.2.ext
  %idx.1.ext = zext i8 %idx.1 to i16
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i16 %idx.1.ext
  %c.1 = icmp ult ptr %add.i32.idx.1, %add.i8.idx.2
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i16 %idx.1.ext
  %t.1 = icmp ult ptr %add.i8.idx.1, %add.i8.idx.2
  %res.1 = xor i1 %c.1, %t.1
  ret i1 %res.1
}

define i1 @gep_zext_shl_nsw_index(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_zext_shl_nsw_index(
; CHECK-NEXT:    [[IDX_2:%.*]] = shl nsw i8 [[IDX:%.*]], 2
; CHECK-NEXT:    [[IDX_2_EXT:%.*]] = zext i8 [[IDX_2]] to i16
; CHECK-NEXT:    [[ADD_I8_IDX_2:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i16 [[IDX_2_EXT]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_IDX_2]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_1:%.*]] = shl nsw i8 [[IDX]], 1
; CHECK-NEXT:    [[IDX_1_EXT:%.*]] = zext i8 [[IDX_1]] to i16
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], [[T_1]]
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %idx.2 = shl nsw i8 %idx, 2
  %idx.2.ext = zext i8 %idx.2 to i16
  %add.i8.idx.2 = getelementptr inbounds i8, ptr %A, i16 %idx.2.ext
  %c.0 = icmp ult ptr %add.i8.idx.2, %upper
  call void @llvm.assume(i1 %c.0)

  %idx.1 = shl nsw i8 %idx, 1
  %idx.1.ext = zext i8 %idx.1 to i16
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i16 %idx.1.ext
  %c.1 = icmp ult ptr %add.i32.idx.1, %upper
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i16 %idx.1.ext
  %t.1 = icmp ult ptr %add.i8.idx.1, %upper
  %res.1 = xor i1 %c.1, %t.1
  ret i1 %res.1
}

define i1 @gep_zext_shl_nuw_index(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_zext_shl_nuw_index(
; CHECK-NEXT:    [[IDX_POS:%.*]] = icmp sgt i8 [[IDX:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[IDX_POS]])
; CHECK-NEXT:    [[IDX_2:%.*]] = shl nuw i8 [[IDX]], 2
; CHECK-NEXT:    [[IDX_2_EXT:%.*]] = zext i8 [[IDX_2]] to i16
; CHECK-NEXT:    [[ADD_I8_IDX_2:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i16 [[IDX_2_EXT]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_IDX_2]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_1:%.*]] = shl nuw i8 [[IDX]], 1
; CHECK-NEXT:    [[IDX_1_EXT:%.*]] = zext i8 [[IDX_1]] to i16
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i16 [[IDX_1_EXT]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], true
; CHECK-NEXT:    ret i1 [[RES_1]]
;
  %idx.pos = icmp sgt i8 %idx, 0
  call void @llvm.assume(i1 %idx.pos)
  %idx.2 = shl nuw i8 %idx, 2
  %idx.2.ext = zext i8 %idx.2 to i16
  %add.i8.idx.2 = getelementptr inbounds i8, ptr %A, i16 %idx.2.ext
  %c.0 = icmp ult ptr %add.i8.idx.2, %upper
  call void @llvm.assume(i1 %c.0)

  %idx.1 = shl nuw i8 %idx, 1
  %idx.1.ext = zext i8 %idx.1 to i16
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i16 %idx.1.ext
  %c.1 = icmp ult ptr %add.i32.idx.1, %upper
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i16 %idx.1.ext
  %t.1 = icmp ult ptr %add.i8.idx.1, %upper
  %res.1 = xor i1 %c.1, %t.1
  ret i1 %res.1
}

%struct.t = type { i8, i8 }

define i1 @gep_add_nsw_positive_index_struct(ptr %A, ptr %upper, i8 %idx) {
; CHECK-LABEL: @gep_add_nsw_positive_index_struct(
; CHECK-NEXT:    [[IDX_POS:%.*]] = icmp sge i8 [[IDX:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[IDX_POS]])
; CHECK-NEXT:    [[IDX_3:%.*]] = add nsw i8 [[IDX]], 2
; CHECK-NEXT:    [[ADD_I8_IDX_3:%.*]] = getelementptr inbounds [[STRUCT_T:%.*]], ptr [[A:%.*]], i8 [[IDX_3]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ult ptr [[ADD_I8_IDX_3]], [[UPPER:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_0]])
; CHECK-NEXT:    [[IDX_1:%.*]] = add nsw i8 [[IDX]], 1
; CHECK-NEXT:    [[ADD_I32_IDX_1:%.*]] = getelementptr inbounds i32, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[ADD_I32_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[ADD_I8_IDX_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp ult ptr [[ADD_I8_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[T_1]], true
; CHECK-NEXT:    [[ADD_I16_IDX_1:%.*]] = getelementptr inbounds i16, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[T_3:%.*]] = icmp ult ptr [[ADD_I16_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], true
; CHECK-NEXT:    [[ADD_I64_IDX_1:%.*]] = getelementptr inbounds i64, ptr [[A]], i8 [[IDX_1]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[ADD_I64_IDX_1]], [[UPPER]]
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[RES_2]], [[C_1]]
; CHECK-NEXT:    ret i1 [[RES_3]]
;
  %idx.pos = icmp sge i8 %idx, 0
  call void @llvm.assume(i1 %idx.pos)
  %idx.3 = add nsw i8 %idx, 2
  %add.i8.idx.3 = getelementptr inbounds %struct.t, ptr %A, i8 %idx.3
  %c.0 = icmp ult ptr %add.i8.idx.3, %upper
  call void @llvm.assume(i1 %c.0)

  %idx.1 = add nsw i8 %idx, 1
  %add.i32.idx.1 = getelementptr inbounds i32, ptr %A, i8 %idx.1
  %t.1 = icmp ult ptr %add.i32.idx.1, %upper
  %add.i8.idx.1 = getelementptr inbounds i8, ptr %A, i8 %idx.1
  %t.2 = icmp ult ptr %add.i8.idx.1, %upper
  %res.1 = xor i1 %t.1, %t.2

  %add.i16.idx.1 = getelementptr inbounds i16, ptr %A, i8 %idx.1
  %t.3 = icmp ult ptr %add.i16.idx.1, %upper
  %res.2 = xor i1 %res.1, %t.3

  %add.i64.idx.1 = getelementptr inbounds i64, ptr %A, i8 %idx.1
  %c.1 = icmp ult ptr %add.i64.idx.1, %upper
  %res.3 = xor i1 %res.2, %c.1

  ret i1 %res.3
}
