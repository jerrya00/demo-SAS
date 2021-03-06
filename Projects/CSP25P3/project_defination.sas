/* *************************************************
* project _defination.sas
* define project global macro variables
* declare library, user folder and system options
* define the path of the macros,  custome call routins and functions
* *************************************************/

/*get full path to this file*/
%let fullpath=%sysget(SAS_EXECFILEPATH);

/*define the project name*/
%let pname=%scan(&fullpath, -2, %str(\));

/*define the root folder of all projects*/
%let proot=%substr(&fullpath, 1 , %eval(%index(&fullpath,&pname)-1));

/*define the project folder*/
%let pdir=&proot.&pname.\;

/*create the folder libori and lib, if they are not existed*/
data _null_;
	if fileexist("&pdir.libori") =0 then NewDir=dcreate("libori","&pdir");
	if fileexist("&pdir.lib")=0 then NewDir=dcreate("lib","&pdir");
run; 

/* pub: self-defined macro, subroutine and function
	ori: original dataset that input from data
	plib: project lib*/
libname pub "&proot.pub";
libname ori  "&pdir.libori";
libname &pname  "&pdir.lib";
/*must use the name "library", so that SAS can automatically see the SAS formats 
without having to specify FMTSEARCH explicitly in the OPTIONS statement.*/
libname library "&pdir.lib"; 

options user= &pname;
options cmplib = pub.funcs; 
/*protect against overwriting the input data sets */
options datastmtchk =COREKEYWORDS;

/*define the custom autocall macro path*/
filename cmacros "&proot.cmacros";
options mautosource sasautos=(SASAUTOS cmacros);

options xsync noxwait ;

