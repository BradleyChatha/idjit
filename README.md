Relevent forum post: https://forum.dlang.org/thread/fvbzrxecrkbdmiltgdsv@forum.dlang.org

This is a barebones project for playing around with DMD-FE and MIR.

## Building

You *should* just be able to run `meson build; cd build; ninja` and things should work.

The only extra steps that should be needed are:

* Make sure you've cloned the submodules as well
* Make sure you have [dstep](https://github.com/jacob-carlborg/dstep) on your PATH.

## Example

This repo comes with a very barebones example of using MIR in D.

The main thing to keep in mind is that the `DLIST_XXX` functions aren't defined (for now at least) so you'll
have to manually go through any of the linked lists, which isn't too hard.

The main difficulty comes from ever needing to modify the list yourself, because those functions aren't one-liners like
the iterator functions are.

If you're interested in what the DLIST functions are, see: https://github.com/vnmakarov/mir/blob/5dbe37c920c92ef0975d49aafe0e183f26018e42/mir-dlist.h