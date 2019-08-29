{smcl}
{* 30jun2019}{...}
{cmd:help ceqmc} (beta version; please report bugs) {right: Rodrigo Aranda}
{hline}

{title:Title}

{p 4 11 2}
{hi: ceqmc} {hline 2} Calculates the Marginal Contribution on inequality and poverty of a single fiscal intervention.


{pstd}

{title:Syntax}

{p 8 11 2}
    {cmd:ceqmc} {ifin} {weight}  [{cmd:,} {inc(varname)} {tax(varname)} {ben(varname)}  {pline(string)}]{break}

{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}

{syntab:Options}
{synopt :{opt pline(string)}}Poverty Line (can be a number or a variable, has to be in the same unit as income and intervention){p_end}

{synoptline}		
{p 4 6 2}
{cmd:pweight} allowed; see {help weights}. 


{title:Description}

{pstd} 
The command {cmd:ceqmc} estimates marginal contributions for Gini, poverty gap and square poverty gap.
To be able to identify the marginal contribution of a fiscal intervention, {cmd: ceqmc} needs {opth inc(varname)} (income of reference) and the intervention whether it is a tax ({opth tax(varname)} or a transfer {opth ben(varname)}). Only one intervention can be measured at a time. 
 The poverty line can be a number or a variable but has to be in the same unit as the income and the intervention variables.
 

{title:Examples}

{pstd}Marginal contribution of a transfer{p_end}
{phang} {cmd:. ceqmc [pw=weight], inc(y0) ben(transf1) z(5000)}{p_end}

{pstd}Marginal contribution of atax{p_end}
{phang} {cmd:. ceqmc [pw=weight], inc(y1) tax(tax1) z(5000)}{p_end}

{title:Saved results}

 {phang} {cmd:.r(mc_ineq) - Marginal Contribution for Gini}{p_end}
 {phang} {cmd:.r(mc_p0) - Marginal Contribution for Headcount}{p_end}
 {phang} {cmd:.r(mc_p1) - Marginal Contribution for Poverty Gap}{p_end}
 {phang} {cmd:.r(mc_p2) - Marginal Contribution for Squared Poverty Gap}{p_end}


{title:Author}

{p 4 4 2}Rodrigo Aranda,  rarandabal@gmail.edu


{title:References}

{phang}
Cite
Lustig, Nora, ed. Commitment to equity handbook: Estimating the impact of fiscal policy on inequality and poverty. Brookings Institution Press, 2018.

