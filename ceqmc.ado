** ADO FILE FOR MARGINAL CONTRIBUTION STAND ALONE COMMAND

** VERSION AND NOTES (changes between versions described under CHANGES)
** v1.0 30jun2019 
*! (beta version please report any bugs)

** CHANGES




cap program drop ceqmc

program define ceqmc, rclass 
#delimit;
	syntax [if] [in] [pw aw iw fw/] [,
			/*Incomes*/
			inc(varname)
			tax(varname)
			ben(varname) 
			pline(string)  
			]
			;
			#delimit cr
			
		if "`exp'" !="" {
			local aw = "[aw = `exp']" //weights
			local pw = "[pw = `exp']"
		}
		
		local id_tax=0
		local id_ben=0
		
		tempvar inter
		*See if we are dealing with taxes or transfers
		if wordcount("`tax'")>0{
		local id_tax=1
		gen double `inter'=abs(`tax')
		
		}
		if wordcount("`ben'")>0{
		local id_ben=1
		gen double `inter'=abs(`ben')
		}
		
		
		if `id_tax'==1{
		tempvar o_inc
		gen double `o_inc'=`inc'+`inter'
		local name_int="`tax'";
		local name_inc="`inc'";
		}
		if `id_ben'==1{
		tempvar o_inc
		gen double `o_inc'=`inc'-`inter'
		local name_int="`ben'";
		local name_inc="`inc'";
		
		}
		
		
			*gini final income
		qui	covconc `inc' `pw'
			local g_f=r(gini)
		qui	covconc `o_inc' `pw'
			local g_o=r(gini)
		
			local mc=`g_o'-`g_f'
			return scalar mc_ineq =  `mc' //Marginal Contribution
			
		
		if wordcount("`pline'")>0{
			tempvar pov0_o pov1_o pov2_o
			tempvar pov0_f pov1_f pov2_f
			gen `pov0_o'=(`o_inc'<`pline')
			gen `pov0_f'=(`inc'<`pline')
			
			qui gen `pov1_o' = max((`pline'-`o_inc')/`pline',0) // normalized povety gap of each individual
			qui gen `pov2_o' = `pov1_o'^2 
			qui gen `pov1_f' = max((`pline'-`inc')/`pline',0) // normalized povety gap of each individual
			qui gen `pov2_f' = `pov1_f'^2 
			forvalues f=0/2{
			qui sum `pov`f'_o' `aw'
			local p`f'_o=r(mean)
			qui sum `pov`f'_f' `aw'
			local p`f'_f=r(mean)
			local mc`f'=`p`f'_o'-`p`f'_f'
			return scalar mc_p`f'=`mc`f'' //Marginal Contribution of poverty fgt:`f'
			}
		}
		
		tempname table
			.`table'  = ._tab.new, col(2)  separator(5) lmargin(0) 
			.`table'.width  20 20   
			.`table'.strcolor green green  
			.`table'.numcolor yellow yellow    
			.`table'.numfmt %16s  %16.7f 

	       
	      	.`table'.sep, top

	      	.`table'.titles "***Marginal Contribution of `name_int' With Respect to `name_inc'***" "" 
			
			scalar r1 = "Inequality - Gini"
			scalar r2 = "Headcount"
			scalar r3 = "Poverty Gap"
			scalar r4 = "Squared Poverty Gap"
		 	
			.`table'.row "Indicator" "MC" 
			.`table'.sep, mid
			.`table'.row r1 `mc' 
			.`table'.row r2 `mc0' 
			.`table'.row r3 `mc1' 
			.`table'.row r4 `mc2' 
			
		   .`table'.sep,bot
		end
