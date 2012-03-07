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

module mod_rad_common

  use mod_constants
  use mod_dynparam
  use mod_realkinds
  use mod_memutil

  public

  integer :: irrtm , irrtm_cldov , irrtm_sw_opcliq , irrtm_sw_opcice

  logical :: lchem ! ichem logical equiv
  real(dp) :: ptp ! ptop
  real(dp) , pointer , dimension(:) :: flev , hlev ! sigma , a
  real(dp),  pointer , dimension(:,:) :: twtr
  real(dp) , pointer , dimension(:,:) :: sfps    ! sfs%psb
  real(dp) , pointer , dimension(:,:) :: psfps   ! sfs%psa

  real(dp) , pointer , dimension(:,:,:) :: tatms  ! atms%tb3d
  real(dp) , pointer , dimension(:,:,:) :: qvatms ! atms%qvb3d
  real(dp) , pointer , dimension(:,:,:) :: rhatms ! atms%rhb3d
  real(dp) , pointer , dimension(:,:) :: tground  ! sfs%tgbb
  real(dp) , pointer , dimension(:,:) :: xlat     ! mddom%xlat

  ! vegetation absorbed radiation (full solar spectrum)
  real(dp) , pointer , dimension(:,:) :: abveg   ! sabveg
  ! Incident solar flux
  real(dp) , pointer , dimension(:,:) :: solar   ! solis
  ! Cosine of zenithal solar angle
  real(dp) , pointer , dimension(:,:) :: coszen  ! coszrs
  ! 0.2-0.7 micro-meter srfc alb to direct radiation
  real(dp) , pointer , dimension(:,:) :: swdiralb ! aldirs
  ! 0.2-0.7 micro-meter srfc alb to diffuse radiation
  real(dp) , pointer , dimension(:,:) :: swdifalb ! aldifs
  ! 0.7-5.0 micro-meter srfc alb to direct radiation
  real(dp) , pointer , dimension(:,:) :: lwdiralb ! aldirl
  ! 0.7-5.0 micro-meter srfc alb to diffuse radiation
  real(dp) , pointer , dimension(:,:) :: lwdifalb ! aldifl
  ! Total Short wave albedo (0.2-0.7 micro-meter)
  real(dp) , pointer , dimension(:,:) :: swalb   ! albvs
  ! Total Long wave albedo (0.7-5.0 micro-meter)
  real(dp) , pointer , dimension(:,:) :: lwalb   ! albvl
  ! Emissivity at surface
  real(dp) , pointer , dimension(:,:) :: emsvt   ! emiss1d
  ! Bidimensional collector storage for above
  real(dp) , pointer , dimension(:,:) :: totsol ! sinc
  real(dp) , pointer , dimension(:,:) :: soldir ! solvs
  real(dp) , pointer , dimension(:,:) :: soldif ! solvd
  real(dp) , pointer , dimension(:,:) :: solswdir ! sols
  real(dp) , pointer , dimension(:,:) :: sollwdir ! soll
  real(dp) , pointer , dimension(:,:) :: solswdif ! solsd
  real(dp) , pointer , dimension(:,:) :: sollwdif ! solld
  real(dp) , pointer , dimension(:,:) :: srfabswflx ! fsw
  real(dp) , pointer , dimension(:,:) :: srflwflxup ! flw
  real(dp) , pointer , dimension(:,:) :: srflwflxdw ! flwd

  ! Land Ocean Ice (1,0,2) mask
  integer , pointer , dimension(:,:,:) :: lndocnicemsk ! ldmsk12d

  real(dp) , pointer , dimension(:,:,:,:) :: chspmix  ! chia

  character(len=5) , pointer , dimension(:) :: tracname ! chtrname

  integer :: ncld ! # of bottom model levels with no clouds

  real(dp) , pointer , dimension(:,:,:) :: cldfra , cldlwc
  real(dp) , pointer , dimension(:,:,:) :: heatrt
  real(dp) , pointer , dimension(:,:,:) :: o3prof

  integer :: idirect , iemiss
  logical :: doabsems , dolw , dosw
  integer :: ichso4 , ichbc , ichoc

  real(dp) :: chfrovrradfr ! chfrq/rafrq

  integer(8) :: ntabem

  data lchem /.false./

  contains 

  subroutine allocate_mod_rad_common
    implicit none
    call getmem3d(cldfra,1,jxp,1,iym1,1,kz,'mod_rad:cldfra')
    call getmem3d(cldlwc,1,jxp,1,iym1,1,kz,'mod_rad:cldlwc')
    call getmem3d(heatrt,1,jxp,1,iym1,1,kz,'mod_rad:heatrt')
    call getmem3d(o3prof,1,jxp,1,iym1,1,kzp1,'mod_rad:o3prof')
  end subroutine  allocate_mod_rad_common

end module mod_rad_common
