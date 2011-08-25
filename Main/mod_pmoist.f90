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

module mod_pmoist
!
! Storage, parameters and constants related to
!     moisture calculations.
!
  use mod_constants
  use mod_dynparam
  use mod_memutil

  implicit none
!
  real(8) :: clfrcv , clfrcvmax , cllwcv , gulland , guloce , mincld , &
             qck10 , qck1land , qck1oce , rh0land , rh0oce , skbmax

  real(8) , pointer , dimension(:,:) :: cbmf2d
  real(8) , pointer , dimension(:,:,:) :: rsheat , rswat
  real(8) , pointer , dimension(:) :: qwght
  real(8) , pointer , dimension(:,:,:) :: twght , vqflx
  integer , pointer , dimension(:) :: icon
!
  contains
!
  subroutine allocate_mod_pmoist
  implicit none

  call getmem2d(cbmf2d,1,iy,1,jxp,'mod_pmoist:cbmf2d')
  call getmem3d(rsheat,1,iy,1,kz,1,jxp,'mod_pmoist:rsheat')
  call getmem3d(rswat,1,iy,1,kz,1,jxp,'mod_pmoist:rswat')
  call getmem1d(icon,1,jxp,'mod_pmoist:icon')
  call getmem1d(qwght,1,kz,'mod_pmoist:qwght')
  call getmem3d(twght,1,kz,5,kz,1,kz-3,'mod_pmoist:twght')
  call getmem3d(vqflx,1,kz,5,kz,1,kz-3,'mod_pmoist:vqflx')
!
  end subroutine allocate_mod_pmoist
!
end module mod_pmoist
