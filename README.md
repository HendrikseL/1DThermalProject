This project is for the 1D thermal resistor newtwrok modelling GH Power's aluminum/water reactor. Full documentation can be found in the accompanying report.

This readme will contain information on the contents of each of the folders in a general sense. For specifics of each function, most if not all functions contain descriptions within their file.

Scripts:  
Main.m       --> Top level of program, execute this script to run the program.  
globalParams --> Contains input data. Includes both user inputs and derived inputs, distinction between the two requires knowledge of the program functionality. Eventually a seperate script will replace this for just user inputs.  
postProcessor--> Contains a post processing script that animates the flow over the user specified saved time steps.  

Folders:  
Elements    --> Contains the objects that correspond to each of the node types.  
Functions   --> Contains functions that are called within the program. the subfolders inside add more specificity into what the functions are used for. Folder names are descriptive and so should be self explanatory. util folder contains functions that are considered utilities and are commonly used throughout the project.  
Lookup Tables --> Contains .csv tables for material properties as well as the functions to read and store the properties in the program.  
Matrix      --> Functions related to the solving and construction of coefficient matrices  
Test        --> contains the unit test script, will look for and run unit tests present in subfolders across the project. This section is very out of date, with only the matrix solver test being maintained.  
