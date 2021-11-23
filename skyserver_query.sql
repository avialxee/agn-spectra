-- This query does a table JOIN between the imaging (PhotoObj) and spectra
-- (SpecObj) tables and includes the necessary columns in the SELECT to upload
-- the results to the SAS (Science Archive Server) for FITS file retrieval.
SELECT TOP 30000
    d.objid, s.z, d.ra,d.dec,
    g.nii_6584_eqw as NII,
    -- g.nii_6584_eqw_err as NII_err,
    g.h_beta_eqw as Hbeta,
    -- g.h_beta_eqw_err as Hbeta_err,
    g.h_alpha_eqw as Halpha,
    -- g.h_alpha_eqw_err as Halpha_err,
    g.oiii_5007_eqw as OIII,
    -- g.oiii_5007_eqw_err as OIII_err,
    g.oii_3726_eqw as OII,
    -- g.oii_3726_eqw_err as OII_err,
    g.oi_6300_eqw as OI
    -- g.oi_6300_eqw_err as OI_err 
FROM
    (SELECT DISTINCT
    objid, ra, dec FROM photoObj) d,
    specObj s,
    galSpecLine g
WHERE 
    d.type=3
    and s.bestObjID = d.objid
    and (s.class ='QSO' or s.class='galaxy')
    and g.specObjID = s.specObjID
    and h_alpha_eqw!=0.0
    and h_beta_eqw!=0.0
    and oii_3726_eqw!=0.0
    and (oiii_5007_eqw/h_beta_eqw)>0.0
    and (oiii_5007_eqw/h_alpha_eqw)>0.0
    and (nii_6584_eqw/h_alpha_eqw)>0.0
    and (oi_6300_eqw/h_alpha_eqw)>0.0
    and (oi_6300_eqw/h_beta_eqw)>0.0
    and (oiii_5007_eqw/oii_3726_eqw)>0.0
    and s.z>0.04
    and s.z<0.1
    and s.snMedian>3.0 -- median signal to noise for all (u,g,r,i,z) good pixels