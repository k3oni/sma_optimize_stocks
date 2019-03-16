function today_dec_date

today=systime()
print, today
tyy=strmid(today,20,4)
tdd=strmid(today,8,2)
tmm=strmid(today,4,3)
case tmm of 
	'Jan' : tmm=1
	'Feb' : tmm=2
	'Mar' : tmm=3
	'Apr' : tmm=4
	'May' : tmm=5
	'Jun' : tmm=6
	'Jul' : tmm=7
	'Aug' : tmm=8
	'Sep' : tmm=9
	'Oct' : tmm=10
	'Nov' : tmm=11
	'Dec' : tmm=12
endcase
today=dec_dates(tyy,tmm,tdd)
return, double(today[0])


end