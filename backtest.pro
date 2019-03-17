pro backtest

;before running make sure that only DIA, SPY, and NDAQ exist in the data folder
;otherwise the run time will be way longer than necessary

;for other tickers, simply Ctrl+F and replace all for one or multiple of these tickers

totalbackdays=1000
futuredays=10

smax=50 & smin=10 ;max and min for SMAs


SPYup=0 & SPYdown=0
DIAup=0 & DIAdown=0
NDAQup=0 & NDAQdown=0
NDAQaccuracies=[]
DIAaccuracies=[]
SPYaccuracies=[]

NDAQinaccuracies=[]
DIAinaccuracies=[]
SPYinaccuracies=[]

for ii=0,totalbackdays/futuredays do begin

days=totalbackdays-(float(ii)*futuredays)

sma_optimize_stocks,backtestdays=days,outdays=futuredays, smmin=smin, smmax=smax

restore, '~/Data/Stocks/output.sav'
;variable names = smaordered_healthy_names,smaordered_healthy_ss, smaordered_tgts, smaordered_healthy_rsis


NDAQprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'NDAQ')]
DIAprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'DIA')]
SPYprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'SPY')]


if ii gt 0 then begin
	;accuracy=(predicted move) / ( actual move ) 
	NDAQaccuracy=100.*( (NDAQprediction-preNDAQprice) ) / (NDAQprice-preNDAQprice)
	DIAaccuracy=100.*( (DIAprediction-preDIAprice) ) / (DIAprice-preDIAprice)
	SPYaccuracy=100.*( (SPYprediction-preSPYprice) ) / (SPYprice-preSPYprice)
	
	if (NDAQprice-preNDAQprice)/(NDAQprediction-preNDAQprice) gt 0 then NDAQup=NDAQup+1 else NDAQdown=NDAQdown+1
	if (DIAprice-preDIAprice)/(DIAprediction-preDIAprice) gt 0 then DIAup=DIAup+1 else DIAdown=DIAdown+1
	if (SPYprice-preSPYprice)/(SPYprediction-preSPYprice) gt 0 then SPYup=SPYup+1 else SPYdown=SPYdown+1

	;only store the accuracy in price swing when the denominator is nonzero
if (NDAQprice-preNDAQprice)/(NDAQprediction-preNDAQprice) gt 0 then NDAQaccuracies=[NDAQaccuracies,NDAQaccuracy] else NDAQinaccuracies=[NDAQinaccuracies,NDAQaccuracy]
if (DIAprice-preDIAprice)/(DIAprediction-preDIAprice) gt 0 then DIAaccuracies=[DIAaccuracies,DIAaccuracy] else DIAinaccuracies=[DIAinaccuracies,DIAaccuracy]
if (SPYprice-preSPYprice)/(SPYprediction-preSPYprice) gt 0 then SPYaccuracies=[SPYaccuracies,SPYaccuracy] else SPYinaccuracies=[SPYinaccuracies,SPYaccuracy]

print, 'Back test days = ',days
print, 'NDAQ accuracy % = ',NDAQaccuracy
print, 'DIA accuracy % = ',DIAaccuracy
print, 'SPY accuracy % = ',SPYaccuracy


endif


NDAQprediction=smaordered_tgts[where(smaordered_healthy_names eq 'NDAQ')]
DIAprediction=smaordered_tgts[where(smaordered_healthy_names eq 'DIA')]
SPYprediction=smaordered_tgts[where(smaordered_healthy_names eq 'SPY')]

preNDAQprice=NDAQprice
preDIAprice=DIAprice
preSPYprice=SPYprice

if n_elements(NDAQaccuracies) gt 1 and n_elements(DIAaccuracies) gt 1 and n_elements(SPYaccuracies) gt 1 and $
	n_elements(NDAQinaccuracies) gt 1 and n_elements(DIAinaccuracies) gt 1 and n_elements(SPYinaccuracies) gt 1  then begin
print,'---------------------------------------------'
print, 'Moves in the predicted direction:'
print, 'NDAQ moves predicted / actual % = ',mean(NDAQaccuracies,/nan)
print, 'DIA moves predicted / actual % = ',mean(DIAaccuracies,/nan)
print, 'SPY moves predicted / actual % = ',mean(SPYaccuracies,/nan)
print
print, 'Average moves predicted / actual % = ',mean( [mean(SPYaccuracies,/nan),mean(DIAaccuracies,/nan),mean(NDAQaccuracies,/nan)],/nan)
print,'---------------------------------------------'
print, 'Moves in the unpredicted direction:'
print, 'NDAQ moves predicted / actual % = ',mean(NDAQinaccuracies,/nan)
print, 'DIA moves predicted / actual % = ',mean(DIAinaccuracies,/nan)
print, 'SPY moves predicted / actual % = ',mean(SPYinaccuracies,/nan)
print
print, 'Average moves predicted / actual % = ',mean( [mean(SPYinaccuracies,/nan),mean(DIAinaccuracies,/nan),mean(NDAQinaccuracies,/nan)],/nan)

print,'---------------------------------------------'
print, 'Moves in any direction:'
print, 'NDAQ moves predicted / actual % = ',mean([NDAQaccuracies,NDAQinaccuracies],/nan)
print, 'DIA moves predicted / actual % = ',mean([DIAaccuracies,DIAinaccuracies],/nan)
print, 'SPY moves predicted / actual % = ',mean([SPYaccuracies,SPYinaccuracies],/nan)
print
print, 'Average moves predicted / actual % = ',mean( [mean([NDAQaccuracies,NDAQinaccuracies],/nan),mean([DIAaccuracies,DIAinaccuracies],/nan),mean([SPYaccuracies,SPYinaccuracies],/nan)],/nan)

print,'---------------------------------------------'


print, 'NDAQ direction accuracy= ',float(NDAQup)/(float(NDAQup+NDAQdown))
print, 'DIA direction accuracy = ',float(DIAup)/(float(DIAup+DIAdown))
print, 'SPY direction accuracy = ',float(SPYup)/(float(SPYup+SPYdown))
print
print, 'Average direction accuracy = ',mean( [float(SPYup)/(float(SPYup+SPYdown)),float(DIAup)/(float(DIAup+DIAdown)),float(NDAQup)/(float(NDAQup+NDAQdown))])

endif


endfor



end
