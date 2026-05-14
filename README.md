# KUE-CHIP2 Web Emulator

A single-file browser-based KUE-CHIP2 toolkit.

## Features

- KUE-CHIP2 instruction-level emulator
- Assembler
- Disassembler
- 512-byte memory model
  - Program region: `000h-0FFh`
  - Data region: `100h-1FFh`
- Registers and flags display
- Step execution / continuous execution
- IBUF / OBUF handling

## GitHub Pages

This repository includes a GitHub Actions workflow for GitHub Pages deployment.
After pushing to GitHub, enable Pages with **Source: GitHub Actions** in repository settings, or run the deployment script below.

## Local usage

Open `index.html` in a browser.
