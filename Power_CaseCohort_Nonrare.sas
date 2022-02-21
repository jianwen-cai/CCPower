/*==============================================================

PROGRAM : Power_CaseCohort_Nonrare.sas 

PURPOSE : SAS Macro codes for Power Calculation of Case-Cohort Study with Nonrare Events

INPUT ARGUMENT : Test size (alpha) 
                 			 Full cohort size (n) 
                 			 Observed failure rate (pD)
                 			 Ratio of sizes of exposure group to control in the population (ratio) 
                 					i.e. ratio=exposure/control=b/a  NOT gamma, equivalently gamma=P(X=1)= b/(a+b) for exposure group 
                 			 Hazard ratio of exposure group to control to be detected (HR) 
                 					i.e. HR=exp(theta) NOT theta, equivanlently theta=logHR
                 			 Premature drop-out rate (pC)          --- Input dot(.) in case unspecified
                 			 Subcohort sampling probability (p0) --- Input dot(.) in case unspecified
                 			 Failure sampling probability (q0)      --- Input dot(.) in case unspecified    

OUTPUT : Lower and upper bounds of powers of the test statistics proposed by Drs. Cai and Zeng (2007) 
				with the powers for rare events given in Drs.Cai and Zeng (2004)  
         		over different Subcohort sampling probabilities (p0) or Failure sampling probabilities (q0) from 0.1 to 1.0 by 0.1
         		or Premature drop-out rates (pC) from 0 to 1 by 0.1 if not specified by input.
         	  * Note that this program provides the powers satisfying that the lower bounds of size of risk sets are positive.
        		                
REFERENCE : Cai, J. and Zeng, D. (2007)
            		Power Calculation for Case-Cohort Studies with Nonrare Events
            		BIOMETRICS 10, 1111-1118
 
==============================================================*/

%macro Power_CaseCohort_Nonrare(alpha, n, pD, ratio, HR, pC, p0, q0);
options center nonumber ls=105 ps=59 nodate SPOOL; 
data Ds;
	D=round(&n.*&pD. );   /* D : Total number of failure */
	call symput('D', D);
run;

data power_data ;
	beta=1;   /* Assume same censoring patterns in two groups */
	gamma=&ratio./(1+&ratio.);   /* gamma = Proportion of the first group (exposure group) */
	theta=log(&HR.);    /* HR = Hazard ratio of exposure group to control to be detected */
	Z_a=probit(&alpha.);

	if &pC.=. then do;         /* (II) When pC is not specified by input */
		do pC_value=0 to 1 by 0.1;		/* Produce powers by pC (0.1~1 by 0.1) */
			nC=&n.*pC_value ;    /* nC : Total number of dropouts */
			if &p0=. then do;
				do p=0.1 to 1 by 0.1;
					if &q0.=. then do; /* (4) Produce powers by p (0.1~1 by 0.1) and q (0.1~1 by 0.1) */
						do q=0.1 to 1 by 0.1;
							output;
						end;
					end;
					else do;               /* (3) Input q and produce powers by p (0.1~1 by 0.1) */
						q=&q0.;
						output;
					end;
				end;
			end;
			else do;
				p=&p0.;
				if &q0=. then do;      /* (2) Input p and produce powers by q (0.1~1 by 0.1) */
					do q=0.1 to 1 by 0.1;
						output;
					end;
				end;
				else do;                   /* (1) Input p and q and produce a power */
					q=&q0.;
					output;
				end;
			end;		
		end;
	end;
	else do;                   /* (I) When pC is specified by input */
		pC_value=&pC.;
		nC=&n.*pC_value ;    /* nC : Total number of dropouts */
		if &p0=. then do;
			do p=0.1 to 1 by 0.1;
				if &q0.=. then do;     /* (4) Produce powers by p (0.1~1 by 0.1) and q (0.1~1 by 0.1) */
					do q=0.1 to 1 by 0.1;
						output;
					end;
				end;
				else do;                   /* (3) Input q and produce powers by p (0.1~1 by 0.1) */
					q=&q0.;
					output;
				end;
			end;
		end;
		else do;
			p=&p0.;
			if &q0=. then do;          /* (2) Input p and produce powers by q (0.1~1 by 0.1) */
				do q=0.1 to 1 by 0.1;
					output;
				end;
			end;
			else do;                       /* (1) Input p and q and produce a power */
				q=&q0.;
				output;
			end;
		end;
	end;
	label	p='Subcohort sampling probability (p)'
			q='Failure sampling probability (q)' 
			pC_value='Premature drop-out rate      (pC)' 
			nC='The number of premature drop-out (nC)';
run;

data NoErrSet ErrSet;
	set power_data;
	nk_L = &n.-nC-&D. ; 
	err_ind=0;
	if ((nk_L <= 0) & (&pC. ^=.)) then do;
		err_nk = "Lower bound of size of risk sets is not positive for the given" ;
		err_ind = 1; 
		output ErrSet;		
	end;
	else if (nk_L > 0) then output NoErrSet;
	call symput('err_indicator', err_ind); 
	label nk_L='Lower bound of risk set (nk_L)'
		    err_nk='ERROR MESSAGE';
run;

/**** (1) With error ****/
%IF &err_indicator.=1 %THEN %DO;
title  " < ERROR >";
title3 "Full cohort size (n) =  &n.";
title4 "Failure proportion (pD) = &pD.";
title5 "Total # of failure (D) =&D. ";
title6 "Ratio of exposure to control (ratio) = &ratio.";
title7 "Hazard Ratio (HR) = &HR.";
proc print data=ErrSet label noobs;
	var err_nk pC_value nC ;
run;
title ' ';
%END;

/**** (2) Without error ****/
%ELSE %DO;
proc sort data=NoErrSet (drop=err_ind err_nk);
	by p q pC_value;
run;

proc iml;
	use NoErrSet;
	read all into Power[colname=varname]; 
	close NoErrSet;
	
	n_power = nrow(Power) ;
	k = t(0:&D.);		/* (D+1) possibilities of extreme sequences in the paper, k=0~D */
	do i=1 to n_power ;	
		id = J((&D.+1), 1, i);
		nk_L = Power[i,9] ;	/* the 9-th column : nk_L=n-nC-D */
		nk_inv = J((&D.+1), &D., 1/nk_L);	/* (D+1) * D matrix*/
		sum1 = J((&D.+1), &D., 0);
		do j=1 to &D.;			/* index k in the paper, k=1~D */ 
			nk_inv[(j+1):(&D.+1),j] = 1/(&n.-j+1);
			if (j=1) then sum1[,j] = nk_inv[,j];
			else sum1[,j] = sum1[,(j-1)]+nk_inv[,j];
		end;
		sum1_sq = (1-sum1)##2;	/* (D+1)*D */
		J1 = J(&D., 1, 1); 				/* D*1 */
		sum2 = sum1_sq*J1;			/* (D+1)*1 */

		id_k_sum2 = id||k||sum2;
		if (i=1) then create sum_all from id_k_sum2;
		append from id_k_sum2;
	end;
	close sum_all;
quit;

data NoErrSet;
	set  NoErrSet;
	id = _n_;
run;
data Chi_all;
	merge NoErrSet sum_all(rename=(col1=id col2=k col3=sum2)) ;
	by id;
	Chi = &pD./p-( (1-p)/p - (1-p)*(1-q)/q )/&n.*sum2;
	if Chi <=0 then Chi=0;
run;
proc sql;
	create table Chi_LU as
	select distinct id, beta, gamma, theta, Z_a, pC_value, nC, p, q, nk_L, min(Chi) as Chi_L, max(Chi) as Chi_U 
	from Chi_all 
	group by id ;
quit; 

data power_LU;
	set Chi_LU;

	numer=sqrt(&n.*beta*gamma*(1-gamma))*theta*&pD.;
	if Chi_U=0 then Z_L= Z_a + numer/sqrt(Chi_U+1E-20) ;  
	else 					Z_L=Z_a + numer/sqrt(Chi_U);
 	if Chi_L=0 then Z_U= Z_a + numer/sqrt(Chi_L+1E-20) ; 
	else 					Z_U=Z_a + numer/sqrt(Chi_L); 
	Power_L=probnorm(Z_L);
	Power_U=probnorm(Z_U);
	
	den_Rare=p+(1-p)*&pD. ;
	if den_Rare=0 then Z_Rare= Z_a + sqrt(&n.*p)*theta*sqrt( beta*gamma*(1-gamma)*&pD./(p+(1-p)*&pD.+1E-20) ); 
	else						 Z_Rare= Z_a + sqrt(&n.*p)*theta*sqrt( beta*gamma*(1-gamma)*&pD./(p+(1-p)*&pD.) ); 
	Power_Rare=probnorm(Z_Rare);

	label Power_L='Lower Bound Power'
    	    Power_U='Upper Bound Power'
		    Power_Rare='Rare Disease Power'
		  	p='Subcohort Sampling Probability (p)'
		  	q='Failure Sampling Probability (q)' 
		  	pC_value='Premature drop-out rate      (pC)' ;
run;	

title  " < Power for Case-Cohort design with Nonrare Events (Test size=&alpha.) >";
title3 "Full cohort size (n) =  &n.";
title4 "Failure proportion (pD) = &pD.";
title5 "Total # of failure (D) =&D. ";
title6 "Ratio of exposure to control (ratio) = &ratio.";
title7 "Hazard Ratio (HR) = &HR.";
proc print data=power_LU label noobs;
	var p q pC_value Power_L Power_U Power_Rare; 
run; 
title ' ';
%END;
%mend;
