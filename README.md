# superspec
Median combine IGRINS spectra from multiple epoch observations.

IDL script requires that the inlist be populated with the A0 divided spectrum from the IGRINS pipeline and the Barycenter and Radial velocities for the epoch of observation. It takes about 45 minutes to process 3 IGRINS epochs and this time scales linearly with the number of epochs.

order of operation:

1) edit the inlist files to point to your data.

2) run step 1, med_comb_spec_H_s1.pro

3) run step 2, med_comb_spec_H_s2.pro

4) run step 3, med_comb_spec_H_s3.pro

5) Enjoy.
