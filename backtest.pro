pro backtest

;before running make sure that only SPY, DIA, and NDAQ exist in the data folder
;otherwise the run time will be way longer than necessary

totalbackdays=5000
futuredays=10

smmax=200 & smmin=20


diaup=0 & diadown=0
spyup=0 & spydown=0
ndaqup=0 & ndaqdown=0
ndaqaccuracies=[]
spyaccuracies=[]
diaaccuracies=[]

ndaqinaccuracies=[]
spyinaccuracies=[]
diainaccuracies=[]

for ii=0,totalbackdays/futuredays do begin

days=totalbackdays-(float(ii)*futuredays)

sma_optimize_stocks,backtestdays=days,outdays=futuredays, smmin=smmin, smmax=smmax

restore, '~/Data/Stocks/output.sav'
;variable names = smaordered_healthy_names,smaordered_healthy_ss, smaordered_tgts


ndaqprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'NDAQ')]
spyprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'SPY')]
diaprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'DIA')]


if ii gt 0 then begin
	;accuracy=(predicted move) / ( actual move ) 
	ndaqaccuracy=100.*( (ndaqprediction-prendaqprice) ) / (ndaqprice-prendaqprice)
	spyaccuracy=100.*( (spyprediction-prespyprice) ) / (spyprice-prespyprice)
	diaaccuracy=100.*( (diaprediction-prediaprice) ) / (diaprice-prediaprice)
	
	if (ndaqprice-prendaqprice)/(ndaqprediction-prendaqprice) gt 0 then ndaqup=ndaqup+1 else ndaqdown=ndaqdown+1
	if (spyprice-prespyprice)/(spyprediction-prespyprice) gt 0 then spyup=spyup+1 else spydown=spydown+1
	if (diaprice-prediaprice)/(diaprediction-prediaprice) gt 0 then diaup=diaup+1 else diadown=diadown+1

	;only store the accuracy in price swing when the denominator is nonzero
if (ndaqprice-prendaqprice)/(ndaqprediction-prendaqprice) gt 0 then ndaqaccuracies=[ndaqaccuracies,ndaqaccuracy] else ndaqinaccuracies=[ndaqinaccuracies,ndaqaccuracy]
if (spyprice-prespyprice)/(spyprediction-prespyprice) gt 0 then spyaccuracies=[spyaccuracies,spyaccuracy] else spyinaccuracies=[spyinaccuracies,spyaccuracy]
if (diaprice-prediaprice)/(diaprediction-prediaprice) gt 0 then diaaccuracies=[diaaccuracies,diaaccuracy] else diainaccuracies=[diainaccuracies,diaaccuracy]

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

if n_elements(ndaqaccuracies) gt 1 and n_elements(spyaccuracies) gt 1 and n_elements(diaaccuracies) gt 1 and $
	n_elements(ndaqinaccuracies) gt 1 and n_elements(spyinaccuracies) gt 1 and n_elements(diainaccuracies) gt 1  then begin
print,'---------------------------------------------'
print, 'Moves in the predicted direction:'
print, 'NDAQ moves predicted / actual % = ',mean(ndaqaccuracies,/nan)
print, 'SPY moves predicted / actual % = ',mean(spyaccuracies,/nan)
print, 'DIA moves predicted / actual % = ',mean(diaaccuracies,/nan)
print
print, 'Average moves predicted / actual % = ',mean( [mean(diaaccuracies),mean(spyaccuracies),mean(ndaqaccuracies)],/nan)
print,'---------------------------------------------'
print, 'Moves in the unpredicted direction:'
print, 'NDAQ moves predicted / actual % = ',mean(ndaqinaccuracies,/nan)
print, 'SPY moves predicted / actual % = ',mean(spyinaccuracies,/nan)
print, 'DIA moves predicted / actual % = ',mean(diainaccuracies,/nan)
print
print, 'Average moves predicted / actual % = ',mean( [mean(diainaccuracies),mean(spyinaccuracies),mean(ndaqinaccuracies)],/nan)

print,'---------------------------------------------'
print, 'Moves in any direction:'
print, 'NDAQ moves predicted / actual % = ',mean([ndaqaccuracies,ndaqinaccuracies],/nan)
print, 'SPY moves predicted / actual % = ',mean([spyaccuracies,spyinaccuracies],/nan)
print, 'DIA moves predicted / actual % = ',mean([diaaccuracies,diainaccuracies],/nan)
print
print, 'Average moves predicted / actual % = ',mean( [mean([ndaqaccuracies,ndaqinaccuracies],/nan),mean([spyaccuracies,spyinaccuracies],/nan),mean([diaaccuracies,diainaccuracies],/nan)],/nan)

print,'---------------------------------------------'


print, 'NDAQ direction accuracy= ',float(ndaqup)/(float(ndaqup+ndaqdown))
print, 'SPY direction accuracy = ',float(spyup)/(float(spyup+spydown))
print, 'DIA direction accuracy = ',float(diaup)/(float(diaup+diadown))
print
print, 'Average direction accuracy = ',mean( [float(diaup)/(float(diaup+diadown)),float(spyup)/(float(spyup+spydown)),float(ndaqup)/(float(ndaqup+ndaqdown))])

endif


endfor



end
