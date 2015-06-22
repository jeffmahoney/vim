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
