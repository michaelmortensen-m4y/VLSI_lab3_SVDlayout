onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_svd/clk
add wave -noupdate /tb_svd/reset
add wave -noupdate /tb_svd/test_x
add wave -noupdate /tb_svd/test_y
add wave -noupdate /tb_svd/test_w
add wave -noupdate /tb_svd/test_v
add wave -noupdate /tb_svd/test_s
add wave -noupdate /tb_svd/test_d
add wave -noupdate /tb_svd/uut/x
add wave -noupdate /tb_svd/uut/y
add wave -noupdate /tb_svd/uut/w
add wave -noupdate /tb_svd/uut/v
add wave -noupdate /tb_svd/uut/s
add wave -noupdate /tb_svd/uut/d
add wave -noupdate /tb_svd/uut/clk
add wave -noupdate /tb_svd/uut/reset
add wave -noupdate /tb_svd/uut/x_sig
add wave -noupdate /tb_svd/uut/y_sig
add wave -noupdate /tb_svd/uut/w_sig
add wave -noupdate /tb_svd/uut/v_sig
add wave -noupdate /tb_svd/uut/xw40
add wave -noupdate /tb_svd/uut/yv40
add wave -noupdate /tb_svd/uut/yw40
add wave -noupdate /tb_svd/uut/xv40
add wave -noupdate /tb_svd/uut/xw20
add wave -noupdate /tb_svd/uut/yv20
add wave -noupdate /tb_svd/uut/yw20
add wave -noupdate /tb_svd/uut/xv20
add wave -noupdate /tb_svd/uut/xv20neg
add wave -noupdate /tb_svd/uut/xw20_reg
add wave -noupdate /tb_svd/uut/yv20_reg
add wave -noupdate /tb_svd/uut/yw20_reg
add wave -noupdate /tb_svd/uut/xv20neg_reg
add wave -noupdate /tb_svd/uut/xw20_next
add wave -noupdate /tb_svd/uut/yv20_next
add wave -noupdate /tb_svd/uut/yw20_next
add wave -noupdate /tb_svd/uut/xv20neg_next
add wave -noupdate /tb_svd/uut/s_reg
add wave -noupdate /tb_svd/uut/d_reg
add wave -noupdate /tb_svd/uut/s_next
add wave -noupdate /tb_svd/uut/d_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 195
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 5
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {201 ns}
