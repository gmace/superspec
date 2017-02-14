pro mcsks1

;
;GNM 02.14.2017
;
;shift, normalize, and double sample spectra.
;output saved as spec and wave for each epoch.

rows=24                         ;number of Kband orders
finegrid=2
c=299792.458                    ;speed of light in km/s

readcol,'inlistK.txt',spectrum,Rvindex,phase,RV,unc,BVC,FORMAT='A,I,D,D,D,D',SKIPLINE=1,/DEBUG

srv=size(RV)
 
for k=0,srv(1)-1 do begin ; for each epoch

   spec=readfits(spectrum(k),EXTEN=0,/SILENT)
   wave=readfits(spectrum(k),EXTEN=1,/SILENT)
   wavenew=((wave)*(1+(BVC(k)-RV(k))/c)) ;adjust wavelength by Barycenter and stellar Radial Velocity

   norm = where(wavenew ge 2.25 and wavenew le 2.29)
   spec=spec/median(spec(norm)) ;normalize the spectrum before median combining

   ;erase major outliers
   erase = where(spec le -6.5)
   spec(erase) = 'NAN'      

   erase = where(spec ge 8.5)
   spec(erase) = 'NAN'          

   ;erase minor outliers
   erase = where(spec le 1-stddev(spec)*1.5)
   spec(erase) = 'NAN'     

   erase = where(spec ge 1+stddev(spec)*1.5)
   spec(erase) = 'NAN'      
   
   speci=dblarr(2048*finegrid,rows)
   waveni=dblarr(2048*finegrid,rows)
   
   for order=0,rows-1 do begin ; interpolate each order onto twice as many pixels
      speci(*,order) = interpol(spec(*,order),2048*finegrid, /spline, /NAN)
      waveni(*,order) = interpol(wavenew(*,order),2048*finegrid, /spline, /NAN)
   endfor
   
   dfn=string(k,format='(I02)')
   writefits,'spec'+dfn+'K.fits',speci,hdr  ; save the interpolated and normalized spectrum
   writefits,'wave'+dfn+'K.fits',waveni,hdr ; save the RV adjusted wavelengths

endfor
end
   
