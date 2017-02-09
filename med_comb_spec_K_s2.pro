pro mcsks2

;
;GNM 02.09.2017
;
;for each wavelength, go find the flux values and median combine them.

rows=24
c=299792.458                    ;speed of light in km/s
finegrid=2

readcol,'inlistK.txt',spectrum,Rvindex,phase,RV,unc,BVC,FORMAT='A,I,D,D,D,D',SKIPLINE=1,/DEBUG

srv=size(RV)

wavestandard=readfits('wave00K.fits') ; arbitrarily use the first wave file as the standard
loop=size(wavestandard)
looper=loop(1)*loop(2) ; stop working with each order and make one long spectrum
speco=dblarr(looper)   ;spectrum 
unco=dblarr(looper)    ;uncertainty
waveo=dblarr(looper)   ;wavelength

for i=1,looper-2 do begin ; for each wavelength in the standard file except the first and last
   print,'Completed ',i,' of ',looper

   spectemp=dblarr(2048*finegrid,srv(1)) ; temporary array that is defined for each wavelength
   
   for k=0,srv(1)-1 do begin ; look through each epoch's spectrum
      dfn=string(k,format='(I02)')
      wavefile='wave'+dfn+'K.fits'
      specfile='spec'+dfn+'K.fits'
      
      spec=readfits(specfile,hdr,/SILENT)
      wave=readfits(wavefile,hdr,/SILENT)

      ;find where the wavelength is not the same as the standard +/-deltalambda
      ignore=where(wave le wavestandard(i-1) or wave ge wavestandard(i+1))
      isize=size(ignore)
      number=looper-isize(1) ; how many did it find that are not worth ignoring?
      spec(ignore)='NAN'     ; erase the ones worth ignoring
      places = where(finite(spec))  ; where are the good fluxes?
      spectemp(0:number-1,k)=spec(places) ; then save those in the temporary spectrum array
   endfor
   killer = where(spectemp eq 0.0) ; there are a lot of unused points in the temp.spec.
   spectemp(killer)='NAN'          ; erase them
   keeper = where(finite(spectemp)); find the fluxes that we still have kept 
   if keeper(0) eq -1 then continue; if there are none worth keeping, then move on to the next wavelength
   
   value = median(spectemp(keeper)); the median flux for this wavelength is 'value'
   moment4,spectemp(keeper),avg,avgdev,stddev,var,skew,kurt ; compute stats for the fluxes
   
   waveo(i)=wavestandard(i) ; store the wavelength
   speco(i)=value           ; store the median flux
   unco(i)=stddev           ; store the stddev
endfor

writefits,'waveo_K.fits',waveo,hdr
writefits,'speco_K.fits',speco,hdr
writefits,'unco_K.fits',unco,hdr

end
   
