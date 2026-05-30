package main

import "core:fmt"
import rl "vendor:raylib"
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
    draw_flag: bool
}

chip8: Chip8

main :: proc() {
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
