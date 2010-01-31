!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
!
!    This file is part of RegCM model.
!
!    RegCM model is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    RegCM model is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with RegCM model.  If not, see <http://www.gnu.org/licenses/>.
!
!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
      function tpfc(press,thetae,tgs,d273,rl,qs,pi)
 
      implicit none
!
! Dummy arguments
!
      real(8) :: d273 , pi , press , qs , rl , tgs , thetae
      real(8) :: tpfc
      intent (in) d273 , pi , press , rl , tgs , thetae
      intent (inout) qs
!
! Local variables
!
      real(8) :: dt , es , f1 , fo , rl1004 , rl461 , rp , t1 , tguess
!
!...iteratively extract temperature from equivalent potential
!...temperature.
!
      rl461 = rl/461.5
      rl1004 = rl/1004.
      rp = thetae/pi
      es = 611.*dexp(rl461*(d273-1./tgs))
      qs = 0.622*es/(press-es)
      fo = tgs*dexp(rl1004*qs/tgs) - rp
      t1 = tgs - 0.5*fo
      tguess = tgs
 100  es = 611.*dexp(rl461*(d273-1./t1))
      qs = 0.622*es/(press-es)
      f1 = t1*exp(rl1004*qs/t1) - rp
      if ( abs(f1).lt..1 ) then
!
        tpfc = t1
      else
        dt = f1*(t1-tguess)/(f1-fo)
        tguess = t1
        fo = f1
        t1 = t1 - dt
        go to 100
      end if
      end function tpfc
