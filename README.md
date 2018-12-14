# CGA Trans Flag

This is a tiny piece of x86 assembly which, on DOS, will render a trans flag using CGA Palette 1.

![Trans Flag](https://pbs.twimg.com/media/DjoNofLWwAAcMAg.jpg:orig)

From [this tweet of mine](https://twitter.com/willkirkby/status/1025147091511922689).

### Building

The provided Makefile depends on NASM (I've tested using NASM 2.13 but older versions should work fine).  
Just run ``make`` from a shell and you should be good to go.

This Makefile was kindly provided by [@Foone](https://twitter.com/Foone).

### Usage

Run ``trans.com`` on a system with CGA compatible graphics, or inside your favorite DOS emulator (DOSBox et al). Exit the program by pressing ESC.

### Why?

Because I realised that CGA Palette 1 roughly matches the trans pride colors, and that was enough for me to spend an evening browsing [sizecoding.org](http://www.sizecoding.org/wiki/Main_Page) to learn assembly.