!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
!
!    This file is part of ICTP RegCM.
!
!    ICTP RegCM is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    ICTP RegCM is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with ICTP RegCM.  If not, see <http://www.gnu.org/licenses/>.
!
!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

      module mod_ccsm

!xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
!
! This is a package of subroutines to read CCSM T85 and T42 L26 data in
! NETCDF format and to prepare Initial and boundary conditions for RegCM
! Both Global and Window of CCSM data are acceptable.
! Written By Moetasim Ashfaq Dec-2005 @ PURDUE.EDU
! Revised By Graziano Giuliani Apr-2011 @ ICTP.IT
!
!xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
!
!  SUBROUTINES CALLED FROM ICBC.f
!     1) INTLIN
!     2) INTLOG
!     3) HUMIF1FV
!     3) BILINX2CR
!     4) BILINX2DT
!     5) TOP2BTM
!     6) UVROT4
!     7) INTGTB
!     8) P1P2
!     8) INTPSN
!     9) INTV3
!     10) MKSST
!     10) HUMID2FV
!     10) INTV1
!     11) WRITEF
!xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
!  DATA PREPARATION
!  Dataset required to use this code can be preapred using NCO utilitiles
!     such as NCKS, NCRCAT etc.
!  Prepare:
!     to extract a subset (window) of CAM85 data for Specific Humidity
!     ncks -d lat,min,max -d lon,min,max -v Q input.nc ccsm.shumJAN.nyear.nc
!xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
!  NAMING CONVENTION (Global Data Files)
!  (MONTH) = JAN/FEB/MAR/APR/MAY/JUN/JUL/AUG/SEP/OCT/NOV/DEC
!
!  ccsm.air(MONTH).nyear.nc     for 'T'     (Temperature)
!  ccsm.hgt(MONTH).nyear.nc     for 'Z3'    (Geopotential Height)
!  ccsm.shum(MONTH).nyear.nc    for 'Q'     (Specific Humidity)
!  ccsm.uwnd(MONTH).nyear.nc    for 'U'     (Zonal Wind)
!  ccsm.vwnd(MONTH).nyear.nc    for 'V'     (Meridonial Wind)
!  ccsm.pres(MONTH).nyear.nc    for 'PS'    (Surface Pressure)
!
!  PATH /DATA/CCSM
!  ccsm_ht.nc      for 'PHIS'  (Surface Geopotential-static field)
!
!xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!

      use mod_dynparam
      use mod_constants
      use mod_date
      use mod_grid
      use mod_write
      use mod_interp
      use mod_vertint
      use mod_hgt
      use mod_humid
      use mod_mksst
      use mod_uvrot
      use mod_vectutil

      implicit none

      private

      integer :: nlon , nlat , klev

      integer , parameter :: npl = 18

      ! Whole space
      real(4) , allocatable , target , dimension(:,:,:) :: b2
      real(4) , allocatable , target , dimension(:,:,:) :: d2
      real(4) , allocatable , target , dimension(:,:,:) :: b3
      real(4) , allocatable , target , dimension(:,:,:) :: d3

      real(4) , pointer :: u3(:,:,:) , v3(:,:,:)
      real(4) , pointer :: h3(:,:,:) , q3(:,:,:) , t3(:,:,:)
      real(4) , pointer :: up(:,:,:) , vp(:,:,:)
      real(4) , pointer :: hp(:,:,:) , qp(:,:,:) , tp(:,:,:)

      ! Input space
      real(4) :: p0
      real(4) , allocatable , dimension(:,:) :: psvar , zsvar
      real(4) , allocatable , dimension(:) :: ak , bk
      real(4) , allocatable , dimension(:) :: glat
      real(4) , allocatable , dimension(:) :: glon
      real(4) , allocatable , dimension(:,:,:) :: hvar , qvar , tvar , &
                                                  uvar , vvar , pp3d
      integer :: timlen
      integer , allocatable , dimension(:) :: itimes
      real(4) , dimension(npl) :: pplev , sigmar

      ! Shared by netcdf I/O routines
      integer :: ilastdate
      integer , dimension(4) :: icount , istart
      integer , dimension(6) :: inet6 , ivar6

      public :: get_ccsm , headccsm

      data ilastdate /0/
!
      contains
!
      subroutine headccsm
        use netcdf
!
        implicit none
!
        integer :: istatus , ivar1 , inet1 , ilat , ilon , ihyam , &
                   ihybm , ip0 , k
        integer :: lonid , latid , ilevid
        character(256) :: pathaddname
        real(8) :: dp0
!
        pathaddname = trim(inpglob)//'/CCSM/ccsm_ht.nc'
        istatus = nf90_open(pathaddname,nf90_nowrite,inet1)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)

        istatus = nf90_inq_dimid(inet1,'lon',lonid)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inquire_dimension(inet1,lonid,len=nlon)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inq_dimid(inet1,'lat',latid)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inquire_dimension(inet1,latid,len=nlat)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inq_dimid(inet1,'lev',ilevid)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inquire_dimension(inet1,ilevid,len=klev)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)

        istatus = nf90_inq_varid(inet1,'lat',ilat)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inq_varid(inet1,'lon',ilon)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inq_varid(inet1,'hyam',ihyam)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inq_varid(inet1,'hybm',ihybm)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inq_varid(inet1,'PHIS',ivar1)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_inq_varid(inet1,'P0',ip0)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)

        ! Input layer and pressure interpolated values

        allocate(glat(nlat))
        allocate(glon(nlon))
        allocate(zsvar(nlon,nlat))
        allocate(psvar(nlon,nlat))
        allocate(qvar(nlon,nlat,klev))
        allocate(tvar(nlon,nlat,klev))
        allocate(hvar(nlon,nlat,klev))
        allocate(uvar(nlon,nlat,klev))
        allocate(vvar(nlon,nlat,klev))
        allocate(pp3d(nlon,nlat,klev))
 
        allocate(ak(klev))
        allocate(bk(klev))

        istatus = nf90_get_var(inet1,ilat,glat)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_get_var(inet1,ilon,glon)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_get_var(inet1,ihyam,ak)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_get_var(inet1,ihybm,bk)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        istatus = nf90_get_var(inet1,ip0,dp0)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        p0 = real(dp0)

        icount(1) = nlon
        icount(2) = nlat
        icount(3) = 1
        istart(1) = 1
        istart(2) = 1
        istart(3) = 1
        istatus = nf90_get_var(inet1,ivar1,zsvar, &
                               istart(1:3),icount(1:3))
        if ( istatus/=nf90_noerr ) call handle_err(istatus)
        zsvar = zsvar/real(egrav)
        where (zsvar < 0.0) zsvar = 0.0

        write (*,*) 'Read in Static fields from ',trim(pathaddname),' .'

        istatus = nf90_close(inet1)
        if ( istatus/=nf90_noerr ) call handle_err(istatus)

        pplev(1) = 30.
        pplev(2) = 50.
        pplev(3) = 70.
        pplev(4) = 100.
        pplev(5) = 150.
        pplev(6) = 200.
        pplev(7) = 250.
        pplev(8) = 300.
        pplev(9) = 350.
        pplev(10) = 420.
        pplev(11) = 500.
        pplev(12) = 600.
        pplev(13) = 700.
        pplev(14) = 780.
        pplev(15) = 850.
        pplev(16) = 920.
        pplev(17) = 960.
        pplev(18) = 1000.
!
        do k = 1 , npl
          sigmar(k) = pplev(k)*0.001
        end do
 
        allocate(b3(jx,iy,npl*3))
        allocate(d3(jx,iy,npl*2))
        allocate(b2(nlon,nlat,npl*3))
        allocate(d2(nlon,nlat,npl*2))

!       Set up pointers
 
        up => d2(:,:,1:npl)
        vp => d2(:,:,npl+1:2*npl)
        tp => b2(:,:,1:npl)
        hp => b2(:,:,npl+1:2*npl)
        qp => b2(:,:,2*npl+1:3*npl)

        u3 => d3(:,:,1:npl)
        v3 => d3(:,:,npl+1:2*npl)
        t3 => b3(:,:,1:npl)
        h3 => b3(:,:,npl+1:2*npl)
        q3 => b3(:,:,2*npl+1:3*npl)

      end subroutine headccsm
!
!-----------------------------------------------------------------------
! 
      subroutine get_ccsm(idate)

        use netcdf

        implicit none
!
        integer :: idate
!

        call readccsm(idate)

        write (*,*) 'Read in fields at Date: ' , idate
 
        call height(hp,hvar,tvar,psvar,pp3d,zsvar,  &
                    nlon,nlat,klev,pplev,npl)
 
        call humid1fv(tvar,qvar,pp3d,nlon,nlat,klev)

        call intlin(up,uvar,psvar,pp3d,nlon,nlat,klev,pplev,npl)
        call intlin(vp,vvar,psvar,pp3d,nlon,nlat,klev,pplev,npl)
        call intlog(tp,tvar,psvar,pp3d,nlon,nlat,klev,pplev,npl)
        call intlin(qp,qvar,psvar,pp3d,nlon,nlat,klev,pplev,npl)
 
        call bilinx2(b3,b2,xlon,xlat,glon,glat,nlon,nlat,jx,iy,npl*3)
        call bilinx2(d3,d2,dlon,dlat,glon,glat,nlon,nlat,jx,iy,npl*2)

        call uvrot4(u3,v3,dlon,dlat,clon,clat,grdfac,jx,iy,  &
                    npl,plon,plat,iproj)
 
        call top2btm(t3,jx,iy,npl)
        call top2btm(q3,jx,iy,npl)
        call top2btm(h3,jx,iy,npl)
        call top2btm(u3,jx,iy,npl)
        call top2btm(v3,jx,iy,npl)
 
        call intgtb(pa,za,tlayer,topogm,t3,h3,sigmar,jx,iy,npl)
        call intpsn(ps4,topogm,pa,za,tlayer,ptop,jx,iy)
 
        if(i_band.eq.1) then
           call p1p2_band(b3pd,ps4,jx,iy)
        else
           call p1p2(b3pd,ps4,jx,iy)
        endif
 
        call intv3(ts4,t3,ps4,sigmar,ptop,jx,iy,npl)
        call readsst(ts4,idate)
        call intv1(u4,u3,b3pd,sigma2,sigmar,ptop,jx,iy,kz,npl)
        call intv1(v4,v3,b3pd,sigma2,sigmar,ptop,jx,iy,kz,npl)
        call intv2(t4,t3,ps4,sigma2,sigmar,ptop,jx,iy,kz,npl)
 
        call intv1(q4,q3,ps4,sigma2,sigmar,ptop,jx,iy,kz,npl)
        call humid2(t4,q4,ps4,ptop,sigma2,jx,iy,kz)
 
        call hydrost(h4,t4,topogm,ps4,ptop,sigmaf,sigma2, &
                     dsigma,jx,iy,kz)
 
        call writef(idate)

      end subroutine get_ccsm
!
!-----------------------------------------------------------------------
! 
      subroutine readccsm(idate)
!
        use netcdf
!
        implicit none
!
        integer , intent(in) :: idate
!
        integer :: istatus , nyear , month , nday , nhour
        integer :: i , it , j , k , kkrec , timid
        integer :: inet , ivar
        character(25) :: inname
        character(256) :: pathaddname
        character(2) , dimension(6) :: varname
        real(8) , allocatable , dimension(:) :: xtimes
        character(3) , dimension(12) :: mname
        character(64) :: cunit
        logical :: lfound
!
        data mname /'JAN','FEB','MAR','APR','MAY','JUN', &
                    'JUL','AUG','SEP','OCT','NOV','DEC'/
        data varname/'T' , 'Z3' , 'Q' , 'U' , 'V' , 'PS'/
!
        call split_idate(idate,nyear,month,nday,nhour)

        if ( .not. lsame_month(idate,ilastdate) ) then
          do kkrec = 1 , 6
            if ( kkrec==1 ) then
              write (inname,99001) nyear , 'air' , mname(month), nyear
            else if ( kkrec==2 ) then
              write (inname,99001) nyear , 'hgt' , mname(month), nyear
            else if ( kkrec==3 ) then
              write (inname,99002) nyear , 'shum' , mname(month), nyear
            else if ( kkrec==4 ) then
              write (inname,99002) nyear , 'uwnd' , mname(month), nyear
            else if ( kkrec==5 ) then
              write (inname,99002) nyear , 'vwnd' , mname(month), nyear
            else if ( kkrec==6 ) then
              write (inname,99002) nyear , 'pres' , mname(month), nyear
            end if
 
            pathaddname = trim(inpglob)//'/CCSM/'//inname
 
            istatus = nf90_open(pathaddname,nf90_nowrite,inet6(kkrec))
            if ( istatus/=nf90_noerr ) call handle_err(istatus)
            istatus = nf90_inq_varid(inet6(kkrec),varname(kkrec),  &
                    &                ivar6(kkrec))
            if ( istatus/=nf90_noerr ) call handle_err(istatus)
            write (*,*) inet6(kkrec), trim(pathaddname), ' : ', &
                        varname(kkrec)
            if ( kkrec == 1 ) then
              istatus = nf90_inq_dimid(inet6(kkrec),'time',timid)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
              istatus = nf90_inquire_dimension(inet6(kkrec),timid, &
                        len=timlen)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
              istatus = nf90_inq_varid(inet6(kkrec),'time',timid)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
              istatus = nf90_get_att(inet6(kkrec),timid,'units',cunit)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
              cunit = '-'//trim(cunit)//' GMT-'

              if (allocated(itimes)) deallocate(itimes)
              allocate(xtimes(timlen))
              allocate(itimes(timlen))
              istatus = nf90_get_var(inet6(kkrec),timid,xtimes)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
              do it = 1 , timlen
                itimes(it) = timeval2idate_noleap(xtimes(it)*24.0,cunit)
              end do
              deallocate(xtimes)
            end if
          end do
        end if

        do kkrec = 1 , 6

          lfound = .false.
          do it = 1 , timlen
            if (itimes(it) == idate) then
              lfound = .true.
              exit
            end if
          end do
 
          if ( .not. lfound ) then
            print * , idate, ' not found in ', trim(pathaddname)
            print * , 'Extremes are : ', itimes(1), '-', itimes(timlen)
            stop
          end if

          inet = inet6(kkrec)
          ivar = ivar6(kkrec)

          if ( kkrec==6 ) then
            icount(1) = nlon
            icount(2) = nlat
            icount(3) = 1
            istart(1) = 1
            istart(2) = 1
            istart(3) = it
            istatus = nf90_get_var(inet,ivar,psvar, &
                                   istart(1:3),icount(1:3))
            if ( istatus/=nf90_noerr ) call handle_err(istatus)
          else
            icount(1) = nlon
            icount(2) = nlat
            icount(3) = klev
            icount(4) = 1
            istart(1) = 1
            istart(2) = 1
            istart(3) = 1
            istart(4) = it
            if ( kkrec == 1 ) then
              istatus = nf90_get_var(inet,ivar,tvar,istart,icount)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
            else if ( kkrec == 2 ) then
              istatus = nf90_get_var(inet,ivar,hvar,istart,icount)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
            else if ( kkrec == 3 ) then
              istatus = nf90_get_var(inet,ivar,qvar,istart,icount)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
            else if ( kkrec == 4 ) then
              istatus = nf90_get_var(inet,ivar,uvar,istart,icount)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
            else if ( kkrec == 5 ) then
              istatus = nf90_get_var(inet,ivar,vvar,istart,icount)
              if ( istatus/=nf90_noerr ) call handle_err(istatus)
            end if
          end if
        end do

        do k = 1 , klev
          do j = 1 , nlat
            do i = 1 , nlon
              pp3d(i,j,k) = (ak(k)*p0 + bk(k)*psvar(i,j))*0.01
            end do
          end do
        end do
        do j = 1 , nlat
          do i = 1 , nlon
            psvar(i,j) = psvar(i,j)*0.01
          end do
        end do
 
        ilastdate = idate

99001   format (i4,'/','ccsm.',a3,a3,'.',i4,'.nc')
99002   format (i4,'/','ccsm.',a4,a3,'.',i4,'.nc')

      end subroutine readccsm
!
!-----------------------------------------------------------------------
!
!     Error Handler for NETCDF Calls
!
      subroutine handle_err(istatus)
        use netcdf
        implicit none
!
        integer :: istatus
        intent (in) :: istatus
!
        print * , nf90_strerror(istatus)
        stop 'Netcdf Error'

      end subroutine handle_err
!
      end module mod_ccsm
