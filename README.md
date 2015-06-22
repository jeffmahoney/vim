VIM scripts
===========
difftools.vim:
-------------
* Contains 3 commands:
* Size: Resizes the @@ lines to reflect the current chunk.

  With the cursor located within the chunk, use the :Size command.
  
* Diff: Shows the differences between what a patch reject expects the
        context to be and what the context actually is.

  With the cursor located on the line of the source file where the context begins, use the :Diff command.
  
* Applied: Shows the differences between what a patch reject expects the result to be and what the file contents are.

  With the cursor located on the line of the source file where the context begins, use the :Applied command.
