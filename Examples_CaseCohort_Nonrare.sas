***** < Eight combinations in terms of input arguments >

** CASE  (I) When pC is specified by input ;
** CASE (II) When pC is not specified by input ;

** CASE (1) Input p0 and q0 and produce a power ;
** CASE (2) Input p0 and produce powers by q (0.1~1 by 0.1) ;
** CASE (3) Input q0 and produce powers by p (0.1~1 by 0.1) ;
** CASE (4) Produce powers by p (0.1~1 by 0.1) and q (0.1~1 by 0.1) ;

/* I-1) CASE (I) & CASE (1) : All arguments to be input */
/*  Example on p4~5 in Cai and Zeng (2007) 
         - Atherosclerosis Risk in Communities (ARIC) study (ARIC Investigator, 1989) 
         - Used in the manual "Description for Power_CaseChort_Nonrare.doc"    */
%Power_CaseCohort_Nonrare(.05, 6901, .1264, 4, exp(.4), 0, .1335, .3); 
%Power_CaseCohort_Nonrare(.05, 6901, .1264, 4, exp(.4), 0, .1335, .5);
%Power_CaseCohort_Nonrare(.05, 6901, .1264, 4, exp(.4), 0, .1335, .8); 
 
%Power_CaseCohort_Nonrare(.05, 1000, .2, 1, 1, .2, .2, .5);  
%Power_CaseCohort_Nonrare(.05, 1000, .2, 1, 1.5, 0, .1, .5);
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1, 0, .1, .5);
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.25, .2, .2, .5);
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, .2, .1, 1);

%Power_CaseCohort_Nonrare(.05, 2000, .2, 1, 1, .2, .2, .5);  
%Power_CaseCohort_Nonrare(.05, 2000, .2, 1, 1.5, 0, .1, .5);
%Power_CaseCohort_Nonrare(.05, 2000, .4, 1, 1, 0, .1, .5); 
%Power_CaseCohort_Nonrare(.05, 2000, .4, 1, 1.25, .2, .2, .5);
%Power_CaseCohort_Nonrare(.05, 2000, .4, 1, 1.5, .2, .1, 1);

/* I-2) CASE (I) & CASE (2) : Only q0 is not input */
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, 0.2, .1, .);

/* I-3) CASE (I) & CASE (3) : Only p0 is not input 
		- Used in the manual "Description for Power_CaseChort_Nonrare.doc"     */
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, 0.2, ., .5); 

/* I-4) CASE (I) & CASE (4) : p0 and q0 are not input */ 
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, 0.2, ., .);

/* II-1) CASE (II) & CASE (1) : Only pC is not input */
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, ., .1, .5);

/* II-2) CASE (II) & CASE (2) : pC and q0 are not input 
		- Used in the manual "Description for Power_CaseChort_Nonrare.doc"     */
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, ., .1, .); 

/* II-3) CASE (II) & CASE (3) : pC and p0 are not input */
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, ., ., .5);  

/* II-4) CASE (II) & CASE (4) : pC, p0, and q0 are not input 
		- Used in the manual "Description for Power_CaseChort_Nonrare.doc"     */
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, ., ., .); 

/* Error example 
		- Used in the manual "Description for Power_CaseChort_Nonrare.doc"     */
%Power_CaseCohort_Nonrare(.05, 1000, .4, 1, 1.5, .8, .1, .5); 
