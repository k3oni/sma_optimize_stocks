pro backtest

;before running make sure that only SPY, DIA, and NDAQ exist in the data folder
;otherwise the run time will be way longer than necessary

totalbackdays=1000
futuredays=10


diaup=0 & diadown=0
spyup=0 & spydown=0
ndaqup=0 & ndaqdown=0


for ii=0,totalbackdays/futuredays do begin

days=totalbackdays-(float(ii)*futuredays)

sma_optimize_stocks,backtestdays=days,outdays=futuredays

restore, '~/Data/Stocks/output.sav'
;variable names = smaordered_healthy_names,smaordered_healthy_ss, smaordered_tgts


ndaqprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'NDAQ')]
spyprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'SPY')]
diaprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'DIA')]


;print outputs
if ii gt 0 then begin
	;accuracy=(predicted move) / ( actual move ) 
	ndaqaccuracy=100.*( abs(ndaqprediction-prendaqprice) ) / abs(ndaqprice-prendaqprice)
	spyaccuracy=100.*( abs(spyprediction-prespyprice) ) / abs(ndaqprice-prendaqprice)
	diaaccuracy=100.*( abs(diaprediction-prediaprice) ) / abs(ndaqprice-prendaqprice)
	
	if (ndaqprice-prendaqprice)/(ndaqprediction-prendaqprice) gt 0 then ndaqup=ndaqup+1 else ndaqdown=ndaqdown+1
	if (spyprice-prespyprice)/(spyprediction-prespyprice) gt 0 then spyup=spyup+1 else spydown=spydown+1
	if (diaprice-prediaprice)/(diaprediction-prediaprice) gt 0 then diaup=diaup+1 else diadown=diadown+1

	
	if ii eq 1 then ndaqaccuracies=ndaqaccuracy else if abs(ndaqprice-prendaqprice) ne 0 then ndaqaccuracies=[ndaqaccuracies,ndaqaccuracy]
	if ii eq 1 then spyaccuracies=spyaccuracy else if abs(ndaqprice-prendaqprice) ne 0 then spyaccuracies=[spyaccuracies,spyaccuracy]
	if ii eq 1 then diaaccuracies=ndaqaccuracy else if abs(ndaqprice-prendaqprice) ne 0 then diaaccuracies=[diaaccuracies,diaaccuracy]

print, 'Back test days = ',days
print, 'NDAQ accuracy % = ',ndaqaccuracy
print, 'SPY accuracy % = ',spyaccuracy
print, 'DIA accuracy % = ',diaaccuracy


endif


ndaqprediction=smaordered_tgts[where(smaordered_healthy_names eq 'NDAQ')]
spyprediction=smaordered_tgts[where(smaordered_healthy_names eq 'SPY')]
diaprediction=smaordered_tgts[where(smaordered_healthy_names eq 'DIA')]

prendaqprice=ndaqprice
prespyprice=spyprice
prediaprice=diaprice

if ii gt 0 then begin
print,'---------------------------------------------'

print, 'NDAQ moves predicted / actual % = ',mean(ndaqaccuracies,/nan)
print, 'SPY moves predicted / actual % = ',mean(spyaccuracies,/nan)
print, 'DIA moves predicted / actual % = ',mean(diaaccuracies,/nan)
print
print, 'Average abs. moves predicted / actual % = ',mean( [mean(diaaccuracies),mean(spyaccuracies),mean(ndaqaccuracies)],/nan)

print,'---------------------------------------------'


print, 'NDAQ direction accuracy= ',float(ndaqup)/(float(ndaqup+ndaqdown))
print, 'SPY direction accuracy = ',float(spyup)/(float(spyup+spydown))
print, 'DIA direction accuracy = ',float(diaup)/(float(diaup+diadown))
print
print, 'Average direction accuracy = ',mean( [float(diaup)/(float(diaup+diadown)),float(spyup)/(float(spyup+spydown)),float(ndaqup)/(float(ndaqup+ndaqdown))])

endif


endfor



end