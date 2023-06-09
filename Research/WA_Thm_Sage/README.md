# Wedderburn-Artin Theorem Implementation
This folder contains source code for an implementation of the Wedderburn-Artin Theorem. The codebase can compute the bases of
irreducible simple ideals of rational group rings, and their generating idempotent.

## Issue Tracker
- More Testing.
- IrreducibleIdeals(CyclicGroup(6)) is in an infinite loop.

## Running the code
- On the command line, changed directory to: matrix-multiplication/other_approaches/WA_Thm_Sage
- On the command line, run sage using: 'sage'.
- In sage, all files can be run using: load('<filename>.sage')

## Files
- main.sage
  - This calls Bremner.sage.
  - Groups/structure constants are generated from sage's group libraries.
  - Has a simple UI.
  - Subroutines are loaded here, file paths can be changed at the top.
- Bremner.sage
  - This contains all subroutines for the implementation.
- parsers.sage
  - This contains the parsing algorithms.
  - Called by Bremner.sage.
  - Deprecated.
- new_parsers.sage
  - New parsing algorithms for polynomials with rational coefficients.
  - Currently used by Bremner.sage.
- factoring.sage
  - Workspace file for testing.
  - Not utilized by the rest of the codebase.
- StructureConstants.txt
  - Contains handwritten structure constants.
  - Deprecated.
- test.sage
  - Testing file for Bremner.sage subroutines.
