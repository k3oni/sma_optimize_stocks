pro sma_optimize_stocks, download=download, crypto=crypto, backtestdays=backtestdays

;Hi Reddit! 

;Updated: March 16, 2019

;----- Keywords:
;download: binary switch to re-download data or not
;
;crpyto: binary switch to re-download cryptocurrency data (running with /download and not /crypto will also delete past crypto)
;
;backtestdays: will change today's date to today - backtestdays, useful for historical back-testing and defining a strategy

;DISCLAIMER: this script was created as a personal endeavor and not in collaboration or correspondence with any financial or 
;educational institution. There is no assurance or warranty on how well the models or SMA-based predictions will correspond
;to reality. Use this program at your own risk, and use your own judgement when defining an investment strategy!!!
;I am not responsible if you YOLO your entire portfolio into a stock suggested by this routine and lose everything, although
;I will gladly accept donations if this script ends up earning you a fortune. 

;------------------------------------------------------------------------------------------------------------


starttime=systime(/JULIAN)

data_path='/Users/kevin/Data/Stocks/Data/'
outpath='/Users/kevin/Dropbox/Stocks/'

if keyword_set(download) then spawn, './download_stocks.sh' else print, 'Download keyword not set. Keeping existing data...'

if keyword_set(crypto) then spawn, './download_crypto.sh'


back_time=1.

;----------------------- end user input

;enable backtesting
if not keyword_set(backtestdays) then backtestdays=0.

today=today_dec_date()-(backtestdays/365.25)
print,today



close, 5


sigmas=[]
names=[]
ss=[]	;where to store closing stocks
ds=[]	;where to store first derivatives of rates of change
d2s=[]	;where to store second derivatives of rates of change
ends=[]	;stock worth at end date
currs=[]
percs=[] ;model percent changes
;n=[4,2,1,2,1,2,2,1]
files=file_search(data_path,'*.csv',count=n_stocks)

n=fltarr(n_stocks)


for stock = 0, n_stocks-1 do begin

;read data
data_file=files[stock]


name_pos=strpos(data_file,'/',/reverse_search)
name_endpos=strpos(data_file,'.',/reverse_search)
name=strmid(data_file,name_pos+1,name_endpos-name_pos-1)


print, 'On file: ',files[stock]
print,name

data=read_csv(data_file);,types=["String","Double","Double","Double","Double","Double","Double"],
;dates=data.field1 & closes=data.field2 & volumes=data.field3 & opens=data.field4 & highs=data.field5 & lows=data.field6

;help, /structure, data
if name eq 'ETH' or name eq 'BTC' or name eq 'LTC' or name eq 'ETC' or name eq 'DOGE' or name eq 'BCH' or name eq 'BTG' then begin
		dates=data.field01 & closes=data.field06 
endif else begin 
		dates=data.field1 & closes=data.field5 
endelse;& volumes=data.field7 & opens=data.field2 & highs=data.field3 & lows=data.field4

if typename(closes) eq 'STRING' then closes[where(closes eq 'null')]='0'

;if typename(closes) eq 'STRING' then print, closes

closes=float(closes)
;closes[where(closes le 0.)]=!values.f_nan

missing=where(closes le 0.)
if n_elements(missing) gt 1 then remove,missing, dates,closes


;remove the most recent entry for date-sorting purposes
IF typename(dates[0]) eq 'STRING' then  remove,0,dates,closes
;convert to decimal dates
;PRINT, DATES
yyyys=float(strmid(dates,0,4)) & mms=float(strmid(dates,5,2)) & dds=float(strmid(dates,8,2))
new_dates=dec_dates(yyyys,mms,dds)
dates=double(new_dates)




closes_new=[]
for jjj=0,n_elements(closes)-1 do begin
	a=strnumber(closes[jjj],val)
	if a then closes_new=[closes_new,double(closes[jjj])]
	
endfor
closes=closes_new


;this is necessary for backtesting
closes = closes[where( dates le today)]  & dates=dates[where( dates le today)] 


;calculate RSI
gains=[] & losses=[]
for lll=2,15 do begin
	chng=closes[n_elements(closes)-lll] - closes[n_elements(closes)-lll-1]
	if chng ge 0 then gains=[gains,chng] ;puts zero into gains
	if chng lt 0 then losses=[losses,-chng]
endfor
if gains eq !NULL then gains=[0.,0.]
if losses eq !null then losses=[0.,0.]


currchng=closes[n_elements(closes)-1]-closes[n_elements(closes)-2]
	currgain=0. & currloss=0. ;start out at zero so that only one is actually added
	if currchng ge 0 then currgain=currchng else currloss=-currchng
	
rsi=100. - (100. /  ( 1.+ (   ( ( 13.*mean(gains,/nan)) + currgain ) / ( (13. * mean(losses,/nan) ) + currloss )   )  )   )

;make an array of NaN data
nanarr=fltarr(200)
nanarr[*]=!values.f_nan

;running a loop over multiple SMAs
	smmax=200
		smmax=min([smmax,n_elements(closes)])
	smmin=10
	for sm=smmax,smmin,-1 do begin
		sma=smooth([closes,nanarr],sm,/nan)
		smad=deriv(sma)
		smadd=deriv(smad)
		smaddd=deriv(smadd)

		sma=sma[n_elements(closes)-1]
		smad=smad[n_elements(closes)-1]/sma
		smadd=smadd[n_elements(closes)-1]/sma
		smaddd=smaddd[n_elements(closes)-1]/sma

		
		if sm eq smmax then smss=sm else smss=[smss,sm]
		if sm eq smmax then smass=sma else smass=[smass,sma]
		if sm eq smmax then smadss=smad else smadss=[smadss,smad]
		if sm eq smmax then smaddss=smadd else smaddss=[smaddss,smadd]
		if sm eq smmax then smadddss=smaddd else smadddss=[smadddss,smaddd]

		weight = 1.0/float(sm) ;here define the weights, a good choice is probably with 1/(sm)
		
		;weight = 1.0 ;uncomment to assign equal weights
		
		if sm eq smmax then weights=weight else weights=[weights,weight]

	
	endfor
	
		;sma=mean(smass)
		;smad=mean(smadss)
		;smadd=mean(smaddss)
		
		
		sma=total(smass*weights)/total(weights)
		smad=total(smadss*weights)/total(weights)
		smadd=total(smaddss*weights)/total(weights)



ss=[ss,closes[n_elements(closes)-1]]  & names=[names,name]  

;sig=stdvends

	
	if stock eq 0 then smas=sma else smas=[smas,sma]
	if stock eq 0 then smads=smad else smads=[smads,smad]
	if stock eq 0 then smadds=smadd else smadds=[smadds,smadd]
	if stock eq 0 then rsis=rsi else rsis=[rsis,rsi]



revcloses=reverse(closes)
revdates=reverse(dates)


endfor
;cgps_close,/pdf


;strategic planning happens here

openw,5,strcompress(outpath+'Stocks_sma_full_avg_strategy_'+string(today)+'.txt',/rem)	;where to save text output



;change this to use a different metric for stock health
healthy=indgen(n_elements(names)-1) ;just take everything, i.e. turn off the health check


healthy_names=names[healthy]

healthy_smas=smas[healthy]

healthy_rsis=rsis[healthy]


healthy_smads=smads[healthy]

healthy_smadds=smadds[healthy]


healthy_ss=ss[healthy]


outdate=10. ;days
tgts=healthy_ss*(1.+(healthy_smads*outdate)+(0.5*healthy_smadds*(outdate*outdate)))
tgtpercs=tgts/healthy_ss

sma_metric=(tgtpercs)

order=reverse(sort(sma_metric))

smaordered_healthy_ss=healthy_ss[order]

smaordered_healthy_names=healthy_names[order]

smaordered_healthy_smas=healthy_smas[order]

smaordered_healthy_smads=healthy_smads[order]
smaordered_healthy_smadds=healthy_smadds[order]
smaordered_healthy_rsis=healthy_rsis[order]

healthy_rsis=rsis[healthy]

smaordered_tgts=tgts[order]
smaordered_tgtpercs=tgtpercs[order]




for ii=0,n_elements(healthy_names)-1 do begin
	;if sigmas[ii] lt 5 then printf,2,'-----------------------------   5.0 sigma line   --------------------------------'
	;if sigmas[ii] lt 3 then printf,2,'-----------------------------   3.0 sigma line   --------------------------------'
;	printf,5, strcompress(string(ii+1)+ ' --- '+smaordered_healthy_names[ii]+' --- current price = '+string(sigfig(smaordered_healthy_ss[ii],4))+' --- 200 sma = '+string(sigfig(smaordered_healthy_sma200s[ii],3))+' --- 100 sma = '+string(sigfig(smaordered_healthy_sma100s[ii],3))+' --- 50 sma = '+string(sigfig(smaordered_healthy_sma50s[ii],3))+' --- 20 sma = '+string(sigfig(smaordered_healthy_sma20s[ii],3))+' --- sma200d = '+string(sigfig(100.*(smaordered_healthy_sma200ds[ii]),3))+'%/day --- sma100d = '+string(sigfig(100.*(smaordered_healthy_sma100ds[ii]),3))+'%/day --- sma50d = '+string(sigfig(100.*(smaordered_healthy_sma50ds[ii]),3))+'%/day --- sma20d = '+string(sigfig(100.*(smaordered_healthy_sma20ds[ii]),3))+'%/day --- w_avg d = '+string(sigfig(100.*(((smaordered_healthy_sma200ds[ii]*200.)+(smaordered_healthy_sma100ds[ii]*100.)+(smaordered_healthy_sma50ds[ii]*50.)+(smaordered_healthy_sma50ds[ii]*20.))/370.),3))+'%/day')

	printf,5, strcompress(string(ii+1)+ ' --- '+smaordered_healthy_names[ii]+' --- price = '+string(sigfig(smaordered_healthy_ss[ii],4))+' --- sma = '+string(sigfig(smaordered_healthy_smas[ii],3))+' --- d/dt = '+string(sigfig(100.*(smaordered_healthy_smads[ii]),3))+'%/day' +' --- d2/d2t = '+string(sigfig(100.*(smaordered_healthy_smadds[ii]),3))+'%/day^2'+' --- '+string(fix(sigfig(outdate,2)))+'day tgt = '+string(sigfig(smaordered_tgts[ii],4))+' = '+string(sigfig(100.*(smaordered_tgtpercs[ii]-1.),3))+'%'+' --- RSI = '+string(sigfig(smaordered_healthy_rsis[ii],3)))
endfor
printf,5,'-------------------------------------------------------------'
printf,5,'----------------------------'
close,5






		endtime=(systime(/JULIAN)-starttime)*86400./60.
		print
print, 'Comleted in ',endtime,' minutes.'


end
