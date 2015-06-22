VIM scripts
===========
difftools.vim:
-------------
* Contains 3 commands:
* Size: Resizes the @@ lines to reflect the current chunk.

  With the cursor located within the chunk, use the :Size command.
  
* Diff: Shows the differences between what a patch reject expects the
        context to be and what the context actually is.

  With the cursor located on the line of the source file where the context begins, use the :Diff command. Vim must opened with at least two buffers (e.g. vim -o): one for the source file to be patched and one for the reject file in either unified or context format.
  
* Applied: Use and usage identical to Diff, but the comparison is made against the expected destination portion of the reject file.

vqn
---

vqn is a tool intended to be used when working with quilt. It's called in the root of your source directory with the name of the source or reject file you want to work with on the command line.

e.g.
    vqn path/to/src.c
or
    vqn path/to/src.c.rej
    
It will load the source file, the reject file, and the next patch to be applied in the quilt series automatically. Note that quilt push, by default, does not leave reject files behind and you'll need to set
    QUILT_PUSH_ARGS="--leave-rejects"
in your 
  .quiltrc to instruct quilt to do so.
