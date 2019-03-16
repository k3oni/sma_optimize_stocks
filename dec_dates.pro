function dec_dates, yyyys,mms,dds

new_dates=[]	
for kk=0,n_elements(yyyys)-1 do begin
if (yyyys[kk]-2012.) mod 4 eq 0. then begin
	if mms[kk] eq 1 then mddec=float(dds[kk])
	if mms[kk] eq 2 then mddec=31.+float(dds[kk])
	if mms[kk] eq 3 then mddec=31.+29.+float(dds[kk])
	if mms[kk] eq 4 then mddec=31.+29.+31.+float(dds[kk])
	if mms[kk] eq 5 then mddec=31.+29.+31.+30.+float(dds[kk])
	if mms[kk] eq 6 then mddec=31.+29.+31.+30.+31.+float(dds[kk])
	if mms[kk] eq 7 then mddec=31.+29.+31.+30.+31.+30.+float(dds[kk])
	if mms[kk] eq 8 then mddec=31.+29.+31.+30.+31.+30.+31.+float(dds[kk])
	if mms[kk] eq 9 then mddec=31.+29.+31.+30.+31.+30.+31.+31.+float(dds[kk])
	if mms[kk] eq 10 then mddec=31.+29.+31.+30.+31.+30.+31.+31.+30.+float(dds[kk])
	if mms[kk] eq 11 then mddec=31.+29.+31.+30.+31.+30.+31.+31.+30.+31.+float(dds[kk])
	if mms[kk] eq 12 then mddec=31.+29.+31.+30.+31.+30.+31.+31.+30.+31.+30.+float(dds[kk])
	mddec=mddec/366.
endif else begin
	if mms[kk] eq 1 then mddec=float(dds[kk])
	if mms[kk] eq 2 then mddec=31.+float(dds[kk])
	if mms[kk] eq 3 then mddec=31.+28.+float(dds[kk])
	if mms[kk] eq 4 then mddec=31.+28.+31.+float(dds[kk])
	if mms[kk] eq 5 then mddec=31.+28.+31.+30.+float(dds[kk])
	if mms[kk] eq 6 then mddec=31.+28.+31.+30.+31.+float(dds[kk])
	if mms[kk] eq 7 then mddec=31.+28.+31.+30.+31.+30.+float(dds[kk])
	if mms[kk] eq 8 then mddec=31.+28.+31.+30.+31.+30.+31.+float(dds[kk])
	if mms[kk] eq 9 then mddec=31.+28.+31.+30.+31.+30.+31.+31.+float(dds[kk])
	if mms[kk] eq 10 then mddec=31.+28.+31.+30.+31.+30.+31.+31.+30.+float(dds[kk])
	if mms[kk] eq 11 then mddec=31.+28.+31.+30.+31.+30.+31.+31.+30.+31.+float(dds[kk])
	if mms[kk] eq 12 then mddec=31.+28.+31.+30.+31.+30.+31.+31.+30.+31.+30.+float(dds[kk])
	mddec=mddec/365.
endelse
ndate=double(yyyys[kk])+double(mddec)
new_dates=[new_dates,ndate[0]]
endfor


return, new_dates

end