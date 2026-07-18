package main

import "core:fmt"
import "core:os"

import rl "vendor:raylib"
import "vendor:stb/easy_font"
// chip8 emulator

CHIP8_WIDTH :: 64
CHIP8_HEIGHT :: 32
DISPLAY_SCALE :: 10

Chip8 :: struct {
	opcode:      u16,
	memory:      [4096]u8,
	// 0x000-0x1FF - Chip 8 interpreter (contains font set in emu)
	// 0x050-0x0A0 - Used for the built in 4x5 pixel font set (0-F)
	// 0x200-0xFFF - Program ROM and work RAM
	v:           [16]u8, // registers v0-vf
	i:           u16, // index register
	pc:          u16,
	graphics:    [CHIP8_WIDTH * CHIP8_HEIGHT]u8,
	delay_timer: u8,
	sound_timer: u8,
	stack:       [16]u16,
	sp:          u16, // stack pointer
	key:         [16]u8, // keys
	draw_flag:   bool,
}

chip8: Chip8

// Fonts
Chip8_Glyphs :: [16][5]u8 {
	//0
	{0b11110000, 0b10010000, 0b10010000, 0b10010000, 0b11110000},
	//1
	{0b00100000, 0b01100000, 0b00100000, 0b00100000, 0b01110000},
	//2
	{0b11110000, 0b00010000, 0b11110000, 0b10000000, 0b11110000},
	//3
	{0b11110000, 0b00010000, 0b11110000, 0b00010000, 0b11110000},
	//4
	{0b10010000, 0b10010000, 0b11110000, 0b00010000, 0b00010000},
	//5
	{0b11110000, 0b10000000, 0b11110000, 0b00010000, 0b11110000},
	//6
	{0b11110000, 0b10000000, 0b11110000, 0b10010000, 0b11110000},
	//7
	{0b11110000, 0b00010000, 0b00100000, 0b01000000, 0b01000000},
	//8
	{0b11110000, 0b10010000, 0b11110000, 0b10010000, 0b11110000},
	//9
	{0b11110000, 0b10010000, 0b11110000, 0b00010000, 0b11110000},
	//A
	{0b11110000, 0b10010000, 0b11110000, 0b10010000, 0b10010000},
	//B
	{0b11100000, 0b10010000, 0b11100000, 0b10010000, 0b11100000},
	//C
	{0b11110000, 0b10000000, 0b10000000, 0b10000000, 0b11110000},
	//D
	{0b11100000, 0b10010000, 0b10010000, 0b10010000, 0b11100000},
	//E
	{0b11110000, 0b10000000, 0b11110000, 0b10000000, 0b11110000},
	//F
	{0b11110000, 0b10000000, 0b11110000, 0b10000000, 0b10000000},
}
glyphs:=Chip8_Glyphs

chip8_init :: proc() {
	// initialization of chip8
	chip8.pc = 0x200
	for i := 0 ; i<16 ; i+=1 do chip8.v[i] = 0

	// Copy the glyphs into memory
	for digit := 0; digit < 16; digit += 1 {
		for row := 0; row < 5; row += 1 do chip8.memory[0x50 + digit * 5 + row] = glyphs[digit][row]
	}
}

chip8_rom_load :: proc () {
	data, err := os.read_entire_file("./rom/1-chip8-logo.ch8", context.allocator)
	if err != nil {
		fmt.println("Failed to load ROM: ", err)
		return
	}
	defer delete (data)

	for i := 0; i < len(data); i += 1 {
		chip8.memory[0x200 + i] = data[i]
	}
}

main :: proc() {
	chip8_init()
	chip8_rom_load()

	rl.InitWindow(
		CHIP8_WIDTH * DISPLAY_SCALE,
		CHIP8_HEIGHT * DISPLAY_SCALE,
		"Bee's Chip8 emulator",
	)
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		if chip8.draw_flag {
			chip8.draw_flag = false

			rl.BeginDrawing()
			rl.ClearBackground(rl.BLACK)
			// Your pixel drawing code goes here later
			rl.EndDrawing()
		} else {
			// Important: still call Begin/EndDrawing even if you skip graphics
			rl.BeginDrawing()
			rl.ClearBackground(rl.BLACK)
			rl.EndDrawing()
		}
	}
}
