transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/ROTL.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/Register32bit_D.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/Register32bit_C.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/Register32bit_B.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/Register32bit_A.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/QuarterRound_ref.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/QuarterRoundFSM_ref.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/mux4to2_xor.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/mux4to2_add.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/mux2to1_D.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/mux2to1_C.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/mux2to1_B.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/mux2to1_A.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/demux_2to1_xor.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/demux_1to2_A.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/BitwiseXOR.vhd}
vcom -93 -work work {C:/Users/dharm/OneDrive/Documents/Tugas Besar Sistem Digital/Tugas-Besar-Sistem-Digital-Chacha20-Encryption/revisi/AdderMod32.vhd}

