$Id: readme.txt,v 1.1 2005-06-19 19:25:29 dale Exp $
------------------------------------------------------------------------------------------------------------------------
This is a simple example on using DKLang Package in MDI application.
While it seems to be a quite general task, there's a trick to make it
live.

The point is that each MDI child is created owned by the parent form
(fMain). VCL requires that all owned components have unique names
across their owner, so you would never be able to have two (or more)
instances of a form owned by fMain if they aren't renamed.

VCL offers a cheap solution for this: it renames the second instance
of fMDIChild to fMDIChild_1, third to fMDIChild_2 and so on.

But we want all of the forms being translated from the same section
of the language file, don't we? So our answer to VCL's behaviour is
that we set fMDIChild.lcMain.SectionName to 'fMDIChild', and now that
works.  
