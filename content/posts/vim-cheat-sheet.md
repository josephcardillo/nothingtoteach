---
title: "VIM Cheat Sheet"
date: 2021-06-14T06:40:37-04:00
author: Joe Cardillo
draft: true
---
When I first started learning about Linux and working with the command line, nano was my go-to, in-terminal text editor. It wasn't complicated to use, which was nice, and it allowed me to focus more on what I was learning without needing to Google a bunch of stuff just to use VIM.

Over time, though, I've been converted. There are a lot of helpful cheat sheets out there, but I wanted to create my own that I could keep updated as I learn more useful key-strokes and commands.

If you'd like to learn VIM by doing, I'd reccommend going through `vimtutor` in your terminal. Just type `vimtutor` in iTerm2 and it'll walk you through seven lessons where you learn by doing. It claims you can complete it in thirty minutes, though it definitely took me longer because I was taking notes. (Using VIM.)

## VIM Cheat Sheet

### Text movement

`w` - Move forward to the beginning of the next word
`b` - Move backward to the beginning of a word
`$` - Go to end of line
`0` - Go to beginning of line

`gg` - Go to first line of document
`G` - Go to last line of document
`#G` - Go to line number #
`CTRL-G` - Show line location in file, and filestatus

`CTRL-B`- Move back one full screen
`CTRL-F` - Move forward one full screen
`CTRL-D` - Move forward 1/2 screen
`CTRL-U` - Move back (up) 1/2 screen

`%` - Moves cursor to matching paranthesis or bracket. (Cursor must be in front of cursor/bracket.)

### Text editing

`i` - Enter insert mode at current cursor location
`a` - Append (insert) after character under cursor

`c` - (c number motion)
`ce` - Change until end of a word
`cc` - Change until end of a line
`rx` - Replace character at the cursor with 'x'
`p` - Put previously deleted text after the cursor

`d` - Delete (d number motion)
`dd` - Delete a whole line
`x` - Delete character under cursor

`o` - Open a line below the cursor in Insert mode
`a` - Insert text after the cursor
`R` - To replace more than one character. Like Insert mode, except every typed character deletes an existing character.

`:s/old/new` - replaces first occurrence of 'old' with 'new' in line
`:#,#s/old/new/g` - #,# are the line numbers of the range of lines where the substitution is to be done.
`:%s/old/new/g` - change every occurrence in the whole file.
`:%s/old/new/gc` - find every occurrence in the whole file, with a prompt whether to substitute or not.

### Undo & redo

`u` - Undo last action
`U` - Undo all changes on a line
`CTRL-R` - Undo the undo's

### Text searching

`/` - To search for a phrase
`:set ic` - Ignore case when searching
NOTE:  If you want to ignore case for just one search command, use  \c in the phrase:  /<search_term>\c <ENTER>
`:set hls inc` - To highlight matches
`:set noic` - Disable ignoring case
`:nohlsearch` - To remove highlighting of searches
`n` - Search phrase again
`N` - Search in opposite direction
`?` - To search phrase in opposite direction
`CTRL-O` - Go back to where you came from. repeat to go bck further. CTRL-I goes forward.
`*` - Search forward for the word nearest the cursor
`#` - Search backward for the word nearest the cursor

### Executing shell commands & saving files

`:!` - to execute external shell command
`:w FILENAME` - save current file with given FILENAME
`v` - visual selection mode
`v motion :w FILENAME` - saves selected text to FILENAME
`:r FILENAME` - Pastes (or reads) output of FILENAME above cursor. This can also read output of an external command.

## Getting help

`:help <ENTER>`
or
`:help <COMMAND> <ENTER>`
`CTRL-W CTRL-W` - Switch between help menu and file I'm editing

## Auto completion (useful for finding commands in `:help`)

1) Make sure Vinm is not in compatible mode: `set nocp`
2) Type the start of a command
3) Press CTRL-D amd VIM will show a list of commands that start with the letter or text you're typing
4) Tab will auto-complete the command if it exists

