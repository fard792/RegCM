
include $(REGCM_ROOT)/makeinc

vpath %.o $(REGCM_ROOT)/Share:.

if DO_COMPILE_LIBCLM45
bin_PROGRAMS = sst icbc chem_icbc clmbc
else
bin_PROGRAMS = sst icbc chem_icbc
endif

FCLD = $(MPIFC)

sst_SOURCES = mod_sst_ersst.F90 \
              mod_sst_1deg.F90 mod_sst_gnmnc.F90 mod_sst_grid.F90 \
              mod_sst_gnhnc.F90 mod_header.F90 mod_ccsm3_helper.F90 \
              mod_hadgem_helper.F90 mod_csiro_helper.F90 mod_canesm_helper.F90 \
              mod_miroc_helper.F90 mod_ipsl_helper.F90 mod_gfdl_helper.F90 \
              mod_cnrm_helper.F90 mod_mpiesm_helper.F90 mod_ecearth_helper.F90 \
              mod_noresm_helper.F90 mod_sst_gndnc.F90 mod_ccsm4_helper.F90 \
              mod_lgm_helper.F90 sst.F90
icbc_SOURCES = mod_vectutil.F90 mod_ein.F90 mod_grid.F90  \
               mod_ncep.F90 mod_nest.F90 mod_write.F90 mod_header.F90 \
               mod_mksst.F90 mod_gn6hnc.F90 mod_ifs.F90 \
               mod_ccsm3_helper.F90 mod_hadgem_helper.F90 mod_csiro_helper.F90 \
               mod_canesm_helper.F90 mod_miroc_helper.F90 mod_ipsl_helper.F90 \
               mod_gfdl_helper.F90 mod_cnrm_helper.F90 mod_mpiesm_helper.F90 \
               mod_ecearth_helper.F90 mod_noresm_helper.F90 mod_era5.F90 \
               mod_lgm_helper.F90 mod_ccsm4_helper.F90 icbc.F90
clmbc_SOURCES = mod_vectutil.F90 mod_grid.F90 mod_write.F90 mod_header.F90 \
               mod_mksst.F90 mod_era5.F90 clmbc.F90
chem_icbc_SOURCES = mod_ch_param.F90 mod_ch_icbc.F90 mod_ch_icbc_clim.F90 \
                    mod_ox_icbc.F90 mod_ae_icbc.F90 mod_wrtoxd.F90 \
                    mod_ch_fnest.F90 mod_grid.F90 mod_header.F90 chem_icbc.F90

LDADD = $(OMPFLAGS)

%.o: %.F90
	$(FC) $(CPPFLAGS) $(OMPFLAGS) $(GITVER) $(FCFLAGS) -c $<

clean-local:
	rm -f *.mod *__genmod.*

distclean-local:
	rm -f *.mod *__genmod.*

# --------------------------------------------------------------------
# DO NOT DELETE THIS LINE -- make depend depends on it.
chem_icbc.o : chem_icbc.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_constants.o mod_message.o mod_date.o mod_dynparam.o mod_space.o mod_memutil.o mod_nchelper.o mod_domain.o mod_grid.o mod_ncstream_types.o mod_ncstream.o mod_wrtoxd.o mod_header.o mod_ch_icbc.o mod_ch_icbc_clim.o mod_ox_icbc.o mod_ae_icbc.o
	$(MPIFC) $(CPPFLAGS) $(OMPFLAGS) $(GITVER) $(FCFLAGS) -c $<
icbc.o : icbc.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_message.o mod_header.o mod_stdio.o mod_memutil.o mod_mksst.o mod_date.o mod_grid.o mod_date.o mod_ein.o mod_ifs.o mod_era5.o mod_ncep.o mod_nest.o mod_gn6hnc.o mod_write.o mod_projections.o
	$(MPIFC) $(CPPFLAGS) $(OMPFLAGS) $(GITVER) $(FCFLAGS) -c $<
mod_ch_icbc.o : mod_ch_icbc.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_grid.o mod_wrtoxd.o mod_kdinterp.o mod_date.o mod_memutil.o mod_message.o mod_nchelper.o mod_ch_param.o
mod_ch_icbc_clim.o : mod_ch_icbc_clim.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_grid.o mod_wrtoxd.o mod_kdinterp.o mod_date.o mod_memutil.o mod_message.o mod_nchelper.o mod_ch_param.o
mod_ox_icbc.o : mod_ox_icbc.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_memutil.o mod_grid.o mod_wrtoxd.o mod_kdinterp.o mod_date.o mod_nchelper.o
mod_ae_icbc.o : mod_ae_icbc.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_memutil.o mod_grid.o mod_wrtoxd.o mod_kdinterp.o mod_date.o mod_nchelper.o
mod_ccsm_helper.o : mod_ccsm_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_message.o
mod_hadgem_helper.o : mod_hadgem_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_csiro_helper.o : mod_csiro_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_canesm_helper.o : mod_canesm_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_ecearth_helper.o : mod_ecearth_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_miroc_helper.o : mod_miroc_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_ipsl_helper.o : mod_ipsl_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_gfdl_helper.o : mod_gfdl_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_cnrm_helper.o : mod_cnrm_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_mpiesm_helper.o : mod_mpiesm_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o mod_message.o
mod_lgm_helper.o : mod_lgm_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o mod_message.o
mod_noresm_helper.o : mod_noresm_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_ccsm4_helper.o : mod_ccsm4_helper.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o
mod_ch_fnest.o : mod_ch_fnest.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_memutil.o mod_grid.o mod_wrtoxd.o mod_kdinterp.o mod_date.o mod_nchelper.o mod_posix.o mod_message.o mod_vertint.o
mod_ein.o : mod_ein.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_stdio.o mod_memutil.o mod_grid.o mod_write.o mod_vertint.o mod_hgt.o mod_humid.o mod_mksst.o mod_projections.o mod_vectutil.o mod_message.o mod_nchelper.o mod_kdinterp.o mod_earth.o
mod_ifs.o : mod_ifs.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_stdio.o mod_memutil.o mod_grid.o mod_write.o mod_vertint.o mod_hgt.o mod_humid.o mod_projections.o mod_vectutil.o mod_message.o mod_nchelper.o mod_kdinterp.o mod_earth.o
mod_era5.o : mod_era5.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_stdio.o mod_memutil.o mod_grid.o mod_write.o mod_vertint.o mod_hgt.o mod_humid.o mod_mksst.o mod_projections.o mod_vectutil.o mod_message.o mod_nchelper.o mod_kdinterp.o mod_earth.o
mod_gn6hnc.o : mod_gn6hnc.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_memutil.o mod_constants.o mod_grid.o mod_write.o mod_kdinterp.o mod_vertint.o mod_hgt.o mod_humid.o mod_mksst.o mod_projections.o mod_vectutil.o mod_message.o mod_nchelper.o mod_ccsm3_helper.o mod_hadgem_helper.o mod_canesm_helper.o mod_miroc_helper.o mod_ipsl_helper.o mod_gfdl_helper.o mod_csiro_helper.o mod_cnrm_helper.o mod_mpiesm_helper.o mod_ecearth_helper.o mod_noresm_helper.o mod_ccsm4_helper.o mod_lgm_helper.o
mod_grid.o : mod_grid.F90 mod_intkinds.o mod_realkinds.o mod_constants.o mod_memutil.o mod_stdio.o mod_message.o mod_nchelper.o mod_domain.o mod_dynparam.o mod_nhinterp.o mod_projections.o
mod_header.o : mod_header.F90 mod_intkinds.o mod_stdio.o $(REGCM_ROOT)/version
mod_mksst.o : mod_mksst.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_grid.o mod_memutil.o mod_constants.o mod_dynparam.o mod_message.o mod_nchelper.o mod_earth.o
mod_ncep.o : mod_ncep.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_stdio.o mod_grid.o mod_write.o mod_kdinterp.o mod_vertint.o mod_hgt.o mod_humid.o mod_mksst.o mod_projections.o mod_vectutil.o mod_message.o mod_memutil.o mod_nchelper.o mod_grid.o
mod_nest.o : mod_nest.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_constants.o mod_date.o mod_grid.o mod_write.o mod_kdinterp.o mod_vertint.o mod_hgt.o mod_humid.o mod_projections.o mod_vectutil.o mod_message.o mod_memutil.o mod_nchelper.o mod_stdatm.o
mod_sst_1deg.o : mod_sst_1deg.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_sst_grid.o mod_kdinterp.o mod_nchelper.o mod_message.o
mod_sst_ersst.o : mod_sst_ersst.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_sst_grid.o mod_kdinterp.o mod_message.o mod_memutil.o mod_nchelper.o
mod_sst_gnmnc.o : mod_sst_gnmnc.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_memutil.o mod_sst_grid.o mod_kdinterp.o mod_message.o mod_nchelper.o mod_hadgem_helper.o mod_canesm_helper.o mod_miroc_helper.o mod_ipsl_helper.o mod_gfdl_helper.o mod_csiro_helper.o mod_cnrm_helper.o mod_ecearth_helper.o mod_ccsm4_helper.o
mod_sst_gnhnc.o : mod_sst_gnhnc.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_memutil.o mod_sst_grid.o mod_message.o mod_nchelper.o mod_ccsm3_helper.o mod_mpiesm_helper.o mod_ecearth_helper.o mod_earth.o mod_kdinterp.o mod_lgm_helper.o
mod_sst_gndnc.o : mod_sst_gndnc.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_memutil.o mod_sst_grid.o mod_message.o mod_nchelper.o mod_noresm_helper.o mod_earth.o mod_kdinterp.o
mod_sst_grid.o : mod_sst_grid.F90 mod_intkinds.o mod_realkinds.o mod_stdio.o mod_dynparam.o mod_memutil.o mod_message.o mod_nchelper.o mod_ncstream_types.o mod_ncstream.o mod_domain.o
mod_vectutil.o : mod_vectutil.F90 mod_intkinds.o mod_realkinds.o mod_constants.o mod_message.o
mod_write.o : mod_write.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_grid.o mod_memutil.o mod_message.o mod_ncstream_types.o mod_ncstream.o mod_nhinterp.o mod_vectutil.o mod_zita.o
mod_wrtoxd.o : mod_wrtoxd.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_date.o mod_grid.o mod_memutil.o mod_message.o mod_stdio.o mod_nchelper.o mod_ncstream.o
sst.o : sst.F90 mod_intkinds.o mod_realkinds.o mod_header.o mod_dynparam.o mod_memutil.o mod_stdio.o mod_message.o mod_sst_grid.o mod_sst_1deg.o mod_sst_ersst.o mod_sst_gnmnc.o mod_sst_gndnc.o mod_sst_gnhnc.o
	$(MPIFC) $(CPPFLAGS) $(OMPFLAGS) $(GITVER) $(FCFLAGS) -c $<
mod_ch_param.o : mod_ch_param.F90 mod_intkinds.o mod_realkinds.o
clmbc.o : clmbc.F90 mod_intkinds.o mod_realkinds.o mod_dynparam.o mod_message.o mod_header.o mod_stdio.o mod_memutil.o mod_date.o mod_grid.o mod_date.o mod_write.o mod_era5.o mod_projections.o
	$(MPIFC) $(CPPFLAGS) $(OMPFLAGS) $(GITVER) $(FCFLAGS) -c $<
