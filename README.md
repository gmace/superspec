# superspec
Median combine IGRINS spectra from multiple epoch observations.

This code takes about 45 minutes to process 3 IGRINS epochs and this time scales linearly with the number of epochs. 40 spectra takes 6 hours.

Order of operation:

1) edit the inlist files to point to your data.
  spectrum - A0V corrected spectrum from the pipeline. Ensure that the correct A0 was used for your target to avoid propogating a bad telluric correction nto your final merged spectrum.
  
  RVindex - a book keeping number I use in my radial velocity code. Can be any number since not used by superspec.
  
  phase - a book keeping number for the binary system I used to test superspec, can be any number.
  
  RV - radial velocity of your star. If it is unchanged between epochs then it can be any value for all epochs. If the RV changes between observations, then put the RVs here to be corrected.
  
  unc - RV uncertainties, not currently used.
  
  BVC - Barycenter velocity correction from JskyCalc. This is required to register your spectra before combining.

2) run step 1, med_comb_spec_H_s1.pro and/or med_comb_spec_K_s1.pro

3) run step 2, med_comb_spec_H_s2.pro and/or med_comb_spec_K_s2.pro

4) run step 3, med_comb_spec_H_s3.pro and/or med_comb_spec_K_s3.pro

5) Enjoy.

Note: This code has been texted on 3 or more input spectra - it is unclear what it will do to a pair of spectra.

Note: If your spectra have small BVC and/or RV offsets between observations, then the median combination will still not be good. This is because the telluric absorption lines will be at the same wavelengths still. For the best results, use spectra with BVC values different by more than 4 km/s.
