pro backtest

;before running make sure that only DIA, stock, and NDAQ exist in the data folder
;otherwise the run time will be way longer than necessary

;for other tickers, simply Ctrl+F and replace all for one or multiple of these tickers


id='SPY'

totalbackdays=15*360
futuredays=10

smax=50 & smin=10 ;max and min for SMAs



files=file_search('~/Data/Stocks/DataBak/','*.csv',count=cnt)

if cnt gt 0 then for nn=0,n_elements(files)-1 do file_move,files[nn],strcompress('~/Data/Stocks/Data/'+strmid(files[nn],33,strlen(files[nn])-1),/rem)


files=file_search('~/Data/Stocks/Data/','*.csv')

for nn=0,n_elements(files)-1 do begin

if strmid(files[nn],30,strlen(files[nn])-1) ne strcompress(id+'.csv',/rem) then file_move,files[nn],strcompress('~/Data/Stocks/DataBak/'+strmid(files[nn],30,strlen(files[nn])-1),/rem)

endfor
for ii=0,totalbackdays/futuredays do begin


days=totalbackdays-(float(ii)*futuredays)

sma_optimize_stocks,backtestdays=days,outdays=futuredays, smmin=smin, smmax=smax

restore, '~/Data/Stocks/output.sav'
;variable names = smaordered_healthy_names,smaordered_healthy_ss, smaordered_tgts, smaordered_healthy_rsis


stockprice=smaordered_healthy_ss[where(smaordered_healthy_names eq 'stock')]

if ii eq 1 then prices=stockprice else if ii gt 1 then  prices=[prices,stockprice]




stockprediction=smaordered_tgts[where(smaordered_healthy_names eq 'stock')]

prestockprice=stockprice



if ii eq 0 then predictions=stockprediction else predictions=[predictions,stockprediction]


endfor

;predictions=predictions[0:n_elements(predictions)-1]
cgcleanup

;copy back data

files=file_search('~/Data/Stocks/DataBak/','*.csv')

for nn=0,n_elements(files)-1 do file_move,files[nn],strcompress('~/Data/Stocks/Data/'+strmid(files[nn],33,strlen(files[nn])-1),/rem)

;!p.multi=[0,1,2]

cgps_open,strcompress('/Users/kevin/Dropbox/Stocks/'+id+'_backtest.pdf',/rem);,/nomatch


cgplot,predictions,yrange=[min([min(predictions),min(prices)]),max([max(predictions),max(prices)])],title=id,xrange=[0,n_elements(predictions)],color='dodger blue',charsize=0.8,aspect=2.5,xtitle=strcompress('(trading days since today - '+string(totalbackdays)+') /'+string(futuredays)),ytitle='Price ($)'
cgoplot,prices



bads=where(deriv(predictions)/deriv(prices) lt 0 )
;print, bads
goods=indgen(n_elements(prices))
remove,bads,goods

cgplot,deriv(predictions),color='dodger blue',charsize=0.8,aspect=2.5,title=string( sigfig(float(n_elements(goods))/float(n_elements(prices)),3) )+'% correct predicted direction, abs. predicted deriv. / abs. actual deriv.='+string(sigfig(mean(abs(deriv(predictions)))/mean(abs(deriv(prices))),3)),xrange=[0,n_elements(predictions)],xtitle=strcompress('(trading days since today - '+string(totalbackdays)+') /'+string(futuredays)),ytitle='Derivative ($/period)'
cgoplot,deriv(prices)
cgoplot,[0,n_elements(prices)-1],[0,0]

for ii=0,n_elements(bads)-1 do cgoplot,[bads[ii],bads[ii]],[-100,100],color='red';,linestyle=1
for ii=0,n_elements(goods)-1 do cgoplot,[goods[ii],goods[ii]],[-100,100],color='green';,linestyle=1
;cgtext, 0.7*float(totalbackdays)/float(futuredays),0.8*max(deriv(predictions)), string( sigfig(float(n_elements(goods))/float(n_elements(prices)),3) )+'% correct predicted direction',charsize=0.9
print, 'Directional accuracy = ',float(n_elements(goods))/float(n_elements(prices))

;replot for clarity 
cgoplot,deriv(predictions),color='dodger blue',charsize=0.8,aspect=2.5,xtitle=strcompress('(trading days since today - '+string(totalbackdays)+') /'+string(futuredays)),ytitle='Derivative ($/period)'
cgoplot,deriv(prices)
cgoplot,[0,n_elements(prices)-1],[0,0]



cgplot,predictions/prices,yrange=[min(predictions/prices),max(predictions/prices)],aspect=2.5,charsize=0.8,xtitle=strcompress('(trading days since today - '+string(totalbackdays)+') /'+string(futuredays)),ytitle='Predicted / Actual'
cgoplot,[0,n_elements(prices)-1],[mean(predictions/prices),mean(predictions/prices)]
cgps_close,/pdf






end
