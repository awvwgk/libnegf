!!--------------------------------------------------------------------------!
!! libNEGF: a general library for Non-Equilibrium Greens functions.         !
!! Copyright (C) 2012 - 2026                                                !
!!                                                                          !
!! This file is part of libNEGF: a library for                              !
!! Non Equilibrium Green's Functions calculations                           !
!!                                                                          !
!! Developers: Alessandro Pecchia, Daniele Soccodato                        !
!! Former Contributors: Gabriele Penazzi, Luca Latessa, Aldo Di Carlo       !
!!                                                                          !
!! libNEGF is free software: you can redistribute and/or modify it          !
!! under the terms of the GNU Lesser General Public License as published    !
!! by the Free Software Foundation, either version 3 of the License, or     !
!! (at your option) any later version.                                      !
!!                                                                          !
!!  You should have received a copy of the GNU Lesser General Public        !
!!  License along with libNEGF.  If not, see                                !
!!  <http://www.gnu.org/licenses/>.                                         !
!!--------------------------------------------------------------------------!
#:include "assert.fypp"
#:include "types.fypp"


#:include "assert.fypp"


module cudautils
   use ln_precision
   use mat_def
   use lib_param
   use iso_c_binding, only : c_int, c_loc, c_null_ptr, c_ptr, c_size_t
   use, intrinsic :: ieee_arithmetic
   implicit none
   private

   public :: createGPU
   public :: createGPU_async
   public :: createGPU_only_async
   public :: copyToGPU
   public :: copyToGPU_async
   public :: copyFromGPU
   public :: deleteGPU
   public :: deleteGPU_async
   public :: createAll
   public :: destroyAll
   public :: waitForGPU

   public :: copy_trid_toGPU
   public :: copy_trid_toHOST
   public :: copy_vdns_toGPU
   public :: delete_vdns_fromGPU
   public :: delete_trid_fromGPU

   public :: matmul_gpu
   public :: inverse_gpu
   public :: matsum_gpu
   public :: spectral_gpu
   public :: init_gpu
   public :: trace_gpu
   public :: copy_mat_gpu
   public :: asum_gpu
   public :: dagger_gpu

   public :: checksum

   public :: cublasInitialize
   public :: cusolverInitialize
   public :: cublasFinalize
   public :: cusolverFinalize

   public :: getDeviceCount
   public :: getDevice
   public :: setDevice
   !public :: getDeviceProperties
   public :: getDevMemInfo


   interface createGPU
   #:for PREC in PRECISIONS
      module procedure createGPU_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface createGPU

   interface createGPU_async
   #:for PREC in PRECISIONS
      module procedure createGPU_async_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface createGPU_async

   interface createGPU_only_async
   #:for PREC in PRECISIONS
      module procedure createGPU_only_async_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface createGPU_only_async

   interface deleteGPU
   #:for PREC in PRECISIONS
      module procedure deleteGPU_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface deleteGPU

   interface deleteGPU_async
   #:for PREC in PRECISIONS
      module procedure deleteGPU_async_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface deleteGPU_async

   interface createAll
   #:for PREC in PRECISIONS
      module procedure createAll_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface createAll

   interface destroyAll
   #:for PREC in PRECISIONS
      module procedure destroyAll_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface destroyAll

   interface copyToGPU
   #:for PREC in PRECISIONS
      module procedure copyToGPU_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface copyToGPU

   interface copyToGPU_async
   #:for PREC in PRECISIONS
      module procedure copyToGPU_async_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface copyToGPU_async

   interface copyFromGPU
   #:for PREC in PRECISIONS
      module procedure copyFromGPU_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface copyFromGPU

   interface copy_trid_toGPU
   #:for PREC in PRECISIONS
      module procedure copy_trid_toGPU_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface copy_trid_toGPU

   interface copy_trid_toHOST
   #:for PREC in PRECISIONS
      module procedure copy_trid_toHOST_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface copy_trid_toHOST

   interface delete_vdns_fromGPU
   #:for PREC in PRECISIONS
      module procedure delete_vdns_fromGPU_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface delete_vdns_fromGPU

   interface copy_vdns_toGPU
   #:for PREC in PRECISIONS
      module procedure copy_vdns_toGPU_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface copy_vdns_toGPU

   interface delete_trid_fromGPU
   #:for PREC in PRECISIONS
      module procedure delete_trid_fromGPU_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface delete_trid_fromGPU

   interface matmul_gpu
   #:for PREC in PRECISIONS
      module procedure matmul_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface matmul_gpu

   interface inverse_gpu
   #:for PREC in PRECISIONS
      module procedure inverse_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface inverse_gpu

   interface matsum_gpu
   #:for PREC in PRECISIONS
      module procedure matsum_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface matsum_gpu

   interface spectral_gpu
   #:for PREC in PRECISIONS
      module procedure spectral_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface spectral_gpu

   interface init_gpu
   #:for PREC in PRECISIONS
      module procedure init_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface init_gpu

   interface trace_gpu
   #:for PREC in PRECISIONS
      module procedure trace_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface trace_gpu

   interface copy_mat_gpu
   #:for PREC in PRECISIONS
      module procedure copy_mat_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface copy_mat_gpu

   interface asum_gpu
   #:for PREC in PRECISIONS
      module procedure asum_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface asum_gpu

   interface dagger_gpu
   #:for PREC in PRECISIONS
      module procedure dagger_gpu_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface dagger_gpu

   interface checksum
   #:for PREC in PRECISIONS
      module procedure checksum_${PREC_ABBREVS[PREC]}$
   #:endfor
   end interface checksum

   integer, parameter :: REAL_SIZE=4
   integer, parameter :: COMPLEX_SIZE=2*REAL_SIZE
   integer, parameter :: DOUBLE_SIZE=8
   integer, parameter :: DOUBLE_COMPLEX_SIZE=2*DOUBLE_SIZE

   ! Notes: type(c_ptr) -> void**
   !        type(c_ptr), value -> void*
   interface
     integer(c_int) function cu_cublasInit(hcublas) bind(C, name='cu_cublasInit')
       use iso_c_binding
       import cublasHandle
       type(cublasHandle) :: hcublas
     end function cu_cublasInit

     integer(c_int) function cu_cublasFinalize(hcublas) bind(C, name='cu_cublasFinalize')
       use iso_c_binding
       import cublasHandle
       type(cublasHandle), value :: hcublas
     end function cu_cublasFinalize

     integer(c_int) function cu_cusolverInit(hcusolver) bind(C, name='cu_cusolverInit')
       use iso_c_binding
       import cusolverDnHandle
       type(cusolverDnHandle) :: hcusolver
     end function cu_cusolverInit

     integer(c_int) function cu_cusolverFinalize(hcusolver) bind(C, name='cu_cusolverFinalize')
       use iso_c_binding
       import cusolverDnHandle
       type(cusolverDnHandle), value :: hcusolver
     end function cu_cusolverFinalize
     
     integer(c_int) function cudaDeviceSynchronize() bind(C, name='cudaDeviceSynchronize')
       use iso_c_binding
     end function cudaDeviceSynchronize

     integer(c_int) function cu_cudaFreeAsync(d_A) bind(C, name='cu_cudaFreeAsync')
       use iso_c_binding
       ! not by value since pointer has to be initialized, hence pass its reference
       type(c_ptr) :: d_A
     end function cu_cudaFreeAsync

     integer(c_int) function cu_cudaGetDeviceCount(count) bind(C, name='cu_cudaGetDeviceCount')
       use iso_c_binding
       integer(c_int) :: count
     end function cu_cudaGetDeviceCount

     integer(c_int) function cu_cudaGetDeviceProperties(device,prop) &
                                          & bind(C, name='cu_cudaGetDeviceProperties')
       use iso_c_binding
       integer(c_int) :: device
       type(c_ptr) :: prop
     end function cu_cudaGetDeviceProperties

     integer(c_int) function cu_cudaMallocAsync(d_A, siz) bind(C, name='cu_cudaMallocAsync')
       use iso_c_binding
       ! not by value since pointer has to be initialized, hence pass its reference
       type(c_ptr) :: d_A
       integer(c_size_t), value :: siz
     end function cu_cudaMallocAsync

     integer(c_int) function cu_cudaGetDevice(device) bind(C, name='cu_cudaGetDevice')
       use iso_c_binding
       integer(c_int) :: device
     end function cu_cudaGetDevice

     integer(c_int) function cu_cudaSetDevice(device) bind(C, name='cu_cudaSetDevice')
       use iso_c_binding
       integer(c_int), value :: device
     end function cu_cudaSetDevice

     integer(c_int) function cu_createMat(d_A, siz) bind(C, name='cu_createMat')
       use iso_c_binding
       ! not by value since pointer has to be initialized, hence pass its reference
       type(c_ptr) :: d_A
       integer(c_size_t), value :: siz
     end function cu_createMat

     integer(c_int) function cu_copyMatD2H(h_A, d_A, siz) bind(C, name='cu_copyMatD2H')
       use iso_c_binding
       type(c_ptr), value :: h_A
       type(c_ptr), value :: d_A
       integer(c_size_t), value :: siz
     end function cu_copyMatD2H

     integer(c_int) function cu_copyMatH2D(h_A, d_A, siz) bind(C, name='cu_copyMatH2D')
       use iso_c_binding
       type(c_ptr), value :: h_A
       type(c_ptr), value :: d_A
       integer(c_size_t), value :: siz
     end function cu_copyMatH2D

     integer(c_int) function cu_copyMatH2D_async(h_A, d_A, siz) bind(C, name='cu_copyMatH2D_async')
       use iso_c_binding
       type(c_ptr), value :: h_A
       type(c_ptr), value :: d_A
       integer(c_size_t), value :: siz
     end function cu_copyMatH2D_async

     integer(c_int) function cu_deleteMat(d_A) bind(C, name='cu_deleteMat')
       use iso_c_binding
       ! not by value since pointer has to be nullified, hence pass its reference
       type(c_ptr) :: d_A
     end function cu_deleteMat

     ! Retrieve memory info from device
     ! CAVEAT: free memory is updated at about 2MB steps
     integer(c_int) function cu_meminfo(freemem, totalmem) &
                  &   bind(C, name='cu_meminfo')
       use iso_c_binding
       integer(c_int64_t) :: freemem
       integer(c_int64_t) :: totalmem
     end function cu_meminfo

   #:for PREC in PRECISIONS
     #:set CTYPE = CHAR_ABBREVS['complex'][PREC]
     #:set C_BIND_CMPLX = ISO_C_BIND_TYPES['complex'][PREC]
     #:set C_BIND_REAL = ISO_C_BIND_TYPES['real'][PREC]
     ! C = alpha*A*B + beta*C
     integer(c_int) function cu_${CTYPE}$multMat(hcublas, m, n, k, alpha, d_A, d_B, beta, d_C, dagger) &
                  &   bind(C, name='cu_${CTYPE}$multMat')
       use iso_c_binding
       import cublasHandle
       type(cublasHandle), value :: hcublas
       integer(c_size_t), value :: m
       integer(c_size_t), value :: n
       integer(c_size_t), value :: k
       complex(${C_BIND_CMPLX}$) :: alpha
       type(c_ptr), value :: d_A
       type(c_ptr), value :: d_B
       complex(${C_BIND_CMPLX}$) :: beta
       type(c_ptr), value :: d_C
       integer(c_int), value :: dagger
     end function cu_${CTYPE}$multMat

     integer(c_int) function cu_${CTYPE}$inverse(hcublas, hcusolver, d_A, d_Ainv, N) &
                  &   bind(C, name='cu_${CTYPE}$inverse')
       use iso_c_binding
       import cublasHandle
       import cusolverDnHandle
       type(cusolverDnHandle), value :: hcusolver
       type(cublasHandle), value :: hcublas
       integer(c_size_t), value :: N
       type(c_ptr), value :: d_A
       type(c_ptr), value :: d_Ainv
     end function cu_${CTYPE}$inverse

     integer(c_int) function cu_${CTYPE}$matsum(hcublas, m, n, alpha, d_A, beta, d_B, d_C, dagger) &
                  &   bind(C, name='cu_${CTYPE}$matsum')
       use iso_c_binding
       import cublasHandle
       type(cublasHandle), value :: hcublas
       integer(c_size_t), value :: m
       integer(c_size_t), value :: n
       integer(c_int), value :: dagger
       complex(${C_BIND_CMPLX}$) :: alpha
       type(c_ptr), value :: d_A
       type(c_ptr), value :: d_B
       complex(${C_BIND_CMPLX}$) :: beta
       type(c_ptr), value :: d_C
     end function cu_${CTYPE}$matsum

     integer(c_int) function cu_${CTYPE}$initmat(d_A, nrow) &
                  &   bind(C, name='cu_${CTYPE}$initmat')
       use iso_c_binding
       type(c_ptr), value :: d_A
       integer(c_size_t), value :: nrow
     end function cu_${CTYPE}$initmat

     real(${C_BIND_REAL}$) function cu_${CTYPE}$trace(hcublas, d_A, nrow, h_tun, mask_present) &
                  &   bind(C, name='cu_${CTYPE}$trace')
       use iso_c_binding
       import cublasHandle
       type(cublasHandle), value :: hcublas
       type(c_ptr), value :: d_A
       type(c_ptr), value :: h_tun
       integer(c_size_t), value :: nrow
       integer(c_int), value :: mask_present
     end function cu_${CTYPE}$trace

     integer(c_int) function cu_${CTYPE}$matcopy(hcublas, d_A, d_B, msize) &
                  &   bind(C, name='cu_${CTYPE}$matcopy')
       use iso_c_binding
       import cublasHandle
       type(cublasHandle), value :: hcublas
       type(c_ptr), value :: d_A
       type(c_ptr), value :: d_B
       integer(c_size_t), value :: msize
     end function cu_${CTYPE}$matcopy

     integer(c_int) function cu_${CTYPE}$asum(hcublas, d_A, summ, N) &
                  &   bind(C, name='cu_${CTYPE}$asum')
       use iso_c_binding
       import cublasHandle
       type(cublasHandle), value :: hcublas
       type(c_ptr), value :: d_A
       real(${C_BIND_REAL}$) :: summ
       integer(c_size_t), value :: N
     end function cu_${CTYPE}$asum

   #:endfor

end interface


 contains

!~-~-~-~-~-~-~-~-~-~-~-~ INIT/FINALIZE ROUTINES  ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
   subroutine cublasInitialize(hcublas)
     type(cublasHandle), intent(inout) :: hcublas
     integer :: err
     err = cu_cublasInit(hcublas)
   end subroutine cublasInitialize

   subroutine cublasFinalize(hcublas)
     type(cublasHandle), intent(inout) :: hcublas
     integer :: err
     err = cu_cublasFinalize(hcublas)
   end subroutine cublasFinalize

   subroutine cusolverInitialize(hcusolver)
     type(cusolverDnHandle), intent(inout) :: hcusolver
     integer :: err
     err = cu_cusolverInit(hcusolver)
   end subroutine cusolverInitialize

   subroutine cusolverFinalize(hcusolver)
     type(cusolverDnHandle), intent(inout) :: hcusolver
     integer :: err
     err = cu_cusolverFinalize(hcusolver)
   end subroutine cusolverFinalize

   subroutine getDeviceCount(count)
     integer(4) :: count
     integer :: err
     err = cu_cudaGetDeviceCount(count)
   end subroutine getDeviceCount

   subroutine getDevice(dev)
     integer(4) :: dev
     integer :: err
     err = cu_cudaGetDevice(dev)
   end subroutine getDevice

   subroutine setDevice(count)
     integer(4) :: count
     integer :: err
     err = cu_cudaSetDevice(count)
   end subroutine setDevice

   subroutine getDevMemInfo(freemem, totalmem)
     integer(8) :: freemem, totalmem
     integer :: err
     err = cu_meminfo(freemem, totalmem)
   end subroutine getDevMemInfo

   subroutine waitForGPU()
     integer :: err
     err = cudaDeviceSynchronize()
     @:ASSERT(err == 0)
   end subroutine waitForGPU


!~-~-~-~-~-~-~-~-~-~-~-~ DATA MOVEMENT ROUTINES  ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
#:def createGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine createGPU_${KIND}$(A)
     type(${MTYPE}$), intent(in) :: A

     integer :: err
     err = cu_createMat(A%d_addr, size(A%val,kind=c_size_t)*${CUDATYPE}$)
   end subroutine createGPU_${KIND}$
#:enddef createGPU_template

#:def createGPU_async_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine createGPU_async_${KIND}$(A)
     use iso_c_binding, only: c_size_t
     type(${MTYPE}$), intent(in) :: A
     integer :: err
     err = cu_cudaMallocAsync(A%d_addr, size(A%val,kind=c_size_t)*${CUDATYPE}$)
   end subroutine createGPU_async_${KIND}$
#:enddef createGPU_async_template

#:def createGPU_only_async_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine createGPU_only_async_${KIND}$(A, m, n)
     use iso_c_binding, only: c_size_t
     type(${MTYPE}$), intent(inout) :: A
     integer, intent(in) :: m, n

     integer :: err
     A%nrow = m
     A%ncol = n
     err = cu_cudaMallocAsync(A%d_addr, int(m, kind=c_size_t) * n *${CUDATYPE}$)
     @:ASSERT(err == 0)
   end subroutine createGPU_only_async_${KIND}$
#:enddef createGPU_only_async_template


#:def copyToGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine copyToGPU_${KIND}$(A)
     type(${MTYPE}$), intent(in), target :: A
     integer :: err
     !call createGPU(A)
     err = cu_copyMatH2D(c_loc(A%val), A%d_addr, size(A%val,kind=c_size_t)*${CUDATYPE}$)
   end subroutine copyToGPU_${KIND}$
#:enddef copyToGPU_template


#:def copyToGPU_async_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine copyToGPU_async_${KIND}$(A)
     use iso_c_binding, only: c_size_t
     type(${MTYPE}$), intent(in), target :: A
     integer :: err
     err = cu_copyMatH2D_async(c_loc(A%val), A%d_addr, size(A%val,kind=c_size_t)*${CUDATYPE}$)
   end subroutine copyToGPU_async_${KIND}$
#:enddef copyToGPU_async_template


#:def copyFromGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine copyFromGPU_${KIND}$(A)
     type(${MTYPE}$), intent(in), target :: A
     integer :: err
     err = cu_copyMatD2H(c_loc(A%val), A%d_addr, size(A%val,kind=c_size_t)*${CUDATYPE}$)
   end subroutine copyFromGPU_${KIND}$
#:enddef copyFromGPU_template

#:def deleteGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine deleteGPU_${KIND}$(A)
     type(${MTYPE}$), intent(in) :: A
     integer :: err
     err = cu_deleteMat(A%d_addr)
   end subroutine deleteGPU_${KIND}$
#:enddef deleteGPU_template

#:def deleteGPU_async_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine deleteGPU_async_${KIND}$(A)
     type(${MTYPE}$), intent(in) :: A
     integer :: err
     err = cu_cudaFreeAsync(A%d_addr)
     @:ASSERT(err == 0)
   end subroutine deleteGPU_async_${KIND}$
#:enddef deleteGPU_async_template

#:def createAll_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine createAll_${KIND}$(A, nrow, ncol, str)
     type(${MTYPE}$) :: A
     integer, intent(in) :: nrow, ncol
     character(len=*), intent(in), optional :: str

     call create(A, nrow, ncol, str)
     call createGPU(A)
   end subroutine createAll_${KIND}$
#:enddef createAll_template

#:def destroyAll_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine destroyAll_${KIND}$(A, str)
     type(${MTYPE}$) :: A
     character(len=*), intent(in), optional :: str
     call deleteGPU(A)
     call destroy(A,tag= str)
   end subroutine destroyAll_${KIND}$
#:enddef destroyAll_template

!~-~-~-~-~-~-~-~-~-~-~-~ MATRIX COMPUTATION ROUTINES  ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

   ! C = alpha*A*B + beta*C
#:def matmul_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine matmul_gpu_${KIND}$(hcublas, alpha, A, B, beta, C, dagger)
     type(cublasHandle), intent(in) :: hcublas
     complex(${KIND}$), intent(in) :: alpha
     type(${MTYPE}$), intent(in) :: A
     type(${MTYPE}$), intent(in) :: B
     complex(${KIND}$), intent(in) :: beta
     type(${MTYPE}$), intent(inout) :: C
     character(*), intent(in), optional :: dagger

     integer :: istat
     integer(c_size_t) :: ncol_A
     integer(c_size_t) :: ncol_C
     integer(c_size_t) :: nrow_B
     integer(c_size_t) :: nrow_C

     @:ASSERT(A%ncol >= 0)
     ncol_A = int(A%ncol, kind=c_size_t)
     @:ASSERT(C%ncol >= 0)
     ncol_C = int(C%ncol, kind=c_size_t)

     @:ASSERT(B%nrow >= 0)
     nrow_B = int(B%nrow, kind=c_size_t)
     @:ASSERT(C%nrow >= 0)
     nrow_C = int(C%nrow, kind=c_size_t)

     if (.not.present(dagger)) then
     istat = cu_${CTYPE}$multMat(hcublas, nrow_C, ncol_C, ncol_A, alpha, A%d_addr, &
                               & B%d_addr, beta, C%d_addr, 0)
     else
       select case(dagger)
       case('dag_1st')
         istat = cu_${CTYPE}$multMat(hcublas, nrow_C, ncol_C, nrow_B, alpha, A%d_addr, &
                                   & B%d_addr, beta, C%d_addr, 1)
       case('dag_2nd')
         istat = cu_${CTYPE}$multMat(hcublas, nrow_C, ncol_C, ncol_A, alpha, A%d_addr, &
                                   & B%d_addr, beta, C%d_addr, 2)
       case default
         error stop 'Error in matmul_gpu'
       end select
     endif

   end subroutine matmul_gpu_${KIND}$
#:enddef matmul_gpu_template

#:def inverse_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
  subroutine inverse_gpu_${KIND}$(hcublas, hcusolver, A, Ainv, err)
     type(cublasHandle) :: hcublas
     type(cusolverDnHandle) :: hcusolver
     type(${MTYPE}$), intent(in) :: A
     type(${MTYPE}$), intent(inout) :: Ainv
     integer, intent(out) :: err

     integer :: istat
     integer(c_size_t) :: nrow

     call init_gpu_${KIND}$(Ainv)

     @:ASSERT(A%nrow >= 0)
     nrow = int(A%nrow, kind=c_size_t)
     istat = cu_${CTYPE}$inverse(hcublas,hcusolver, A%d_addr, Ainv%d_addr, nrow)
     err = istat

   end subroutine inverse_gpu_${KIND}$
#:enddef inverse_gpu_template

#:def kernelsum_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine kernelsum_gpu_${KIND}$(C,alpha,A,beta,B)
     type(${MTYPE}$), intent(inout) :: C
     type(${MTYPE}$), intent(in) :: A
     type(${MTYPE}$), intent(in) :: B
     complex(${KIND}$), intent(in) :: alpha
     complex(${KIND}$), intent(in) :: beta

     integer :: istat

     istat = cu_${CTYPE}$kernelsum(C%d_addr, alpha, A%d_addr, beta, B%d_addr, &
                                 & size(A%val, kind=c_size_t))

   end subroutine kernelsum_gpu_${KIND}$
#:enddef kernelsum_gpu_template

#:def matsum_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine matsum_gpu_${KIND}$(hcublas, alpha, A, beta, B, C, dagger)
     type(cublasHandle), intent(in) :: hcublas
     complex(${KIND}$), intent(in) :: alpha
     type(${MTYPE}$), intent(in) :: A
     type(${MTYPE}$), intent(in) :: B
     complex(${KIND}$), intent(in) :: beta
     type(${MTYPE}$), intent(inout) :: C
     character(*), intent(in), optional :: dagger

     integer :: istat
     integer(c_size_t) :: ncol_C
     integer(c_size_t) :: nrow_C

     @:ASSERT(C%ncol >= 0)
     ncol_C = int(C%ncol, kind=c_size_t)
     @:ASSERT(C%nrow >= 0)
     nrow_C = int(C%nrow, kind=c_size_t)

     if (.not.present(dagger)) then
       istat = cu_${CTYPE}$matsum(hcublas, nrow_C, ncol_C, alpha, A%d_addr, beta, B%d_addr, &
                                & C%d_addr, 0)
     else
       if (dagger == 'dag_1st') then
         istat = cu_${CTYPE}$matsum(hcublas, nrow_C, ncol_C, alpha, A%d_addr, beta, B%d_addr, &
                                  & C%d_addr, 1)
       endif
       if (dagger == 'dag_2nd') then
         istat = cu_${CTYPE}$matsum(hcublas, nrow_C, ncol_C, alpha, A%d_addr, beta, B%d_addr, &
                                  & C%d_addr, 2)
       endif
     endif

   end subroutine matsum_gpu_${KIND}$
#:enddef matsum_gpu_template

#:def spectral_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine spectral_gpu_${KIND}$(hcublas, G_in, G_out)
      type(cublasHandle), intent(in) :: hcublas
      type(${MTYPE}$), intent(in) :: G_in
      type(${MTYPE}$), intent(inout) :: G_out

      complex(${KIND}$) :: alpha, beta

      alpha = cmplx(0.0, 1.0, ${KIND}$)
      beta = cmplx(0.0, -1.0, ${KIND}$)

      call matsum_gpu_${KIND}$(hcublas, alpha, G_in, beta, G_in, G_out, 'dag_2nd')

   end subroutine spectral_gpu_${KIND}$
#:enddef spectral_gpu_template

#:def init_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine init_gpu_${KIND}$(A)
      type(${MTYPE}$), intent(inout) :: A

      integer :: istat
      integer(c_size_t) :: nrow

      @:ASSERT(A%nrow >= 0)
      nrow = int(A%nrow, kind=c_size_t)
      istat = cu_${CTYPE}$initmat(A%d_addr, nrow)

   end subroutine init_gpu_${KIND}$
#:enddef init_gpu_template

#:def trace_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine trace_gpu_${KIND}$(hcublas, A, trace, tun_mask)
      type(cublasHandle), intent(in) :: hcublas
      type(${MTYPE}$), intent(inout) :: A
      real(${KIND}$), intent(out) :: trace
      logical, intent(in), optional, target :: tun_mask(:)

      type(c_ptr) :: dummy
      integer(c_size_t) :: nrow
      dummy = c_null_ptr

      @:ASSERT(A%nrow >= 0)
      nrow = int(A%nrow, kind=c_size_t)

      if (.not.present(tun_mask)) then
         trace = cu_${CTYPE}$trace(hcublas, A%d_addr, nrow, dummy, 0)
      else
         trace = cu_${CTYPE}$trace(hcublas, A%d_addr, nrow, c_loc(tun_mask), 1)
      endif

   end subroutine trace_gpu_${KIND}$
#:enddef trace_gpu_template

#:def copy_mat_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine copy_mat_gpu_${KIND}$(hcublas, A, Acopy)
      type(cublasHandle), intent(in) :: hcublas
      type(${MTYPE}$), intent(inout) :: A
      type(${MTYPE}$), intent(inout) :: Acopy

      integer :: istat
      integer(c_size_t) :: n

      @:ASSERT(A%ncol >= 0)
      @:ASSERT(A%nrow >= 0)
      n = int(A%ncol, kind=c_size_t) * int(A%nrow, kind=c_size_t)
      istat = cu_${CTYPE}$matcopy(hcublas, A%d_addr, Acopy%d_addr, n)

   end subroutine copy_mat_gpu_${KIND}$
#:enddef copy_mat_gpu_template

#:def asum_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
   subroutine asum_gpu_${KIND}$(hcublas, A, summ)
      type(cublasHandle), intent(in) :: hcublas
      type(${MTYPE}$), intent(in) :: A
      real(${KIND}$), intent(out) :: summ

      integer :: istat
      integer(c_size_t) :: n

      @:ASSERT(A%ncol >= 0)
      @:ASSERT(A%nrow >= 0)
      n = int(A%ncol, kind=c_size_t) * int(A%nrow, kind=c_size_t)
      istat = cu_${CTYPE}$asum(hcublas, A%d_addr, summ, n)

   end subroutine asum_gpu_${KIND}$
#:enddef asum_gpu_template

#:def dagger_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)
  subroutine dagger_gpu_${KIND}$(hcublas, G, G_dag)
      type(cublasHandle), intent(in) :: hcublas
      type(${MTYPE}$), intent(in) :: G
      type(${MTYPE}$), intent(inout) :: G_dag

      complex(${KIND}$) :: alpha, beta

      alpha = cmplx(0.0, 0.0, ${KIND}$)
      beta = cmplx(1.0, 0.0, ${KIND}$)

      call matsum_gpu_${KIND}$(hcublas, alpha, G, beta, G, G_dag, 'dag_2nd')

  end subroutine dagger_gpu_${KIND}$
#:enddef dagger_gpu_template

!~-~-~-~-~-~-~-~-~-~-~-~ MATRIX MOVEMENTS ROUTINES  ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
#:def copy_trid_toGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)
  subroutine copy_trid_toGPU_${KIND}$(M)
    type(${MTYPE}$), dimension(:,:), intent(in) :: M
    integer :: ii, nbl

    nbl = size(M,1)
    call createGPU(M(1,1))
    call copyToGPU(M(1,1))
    do ii=2,nbl
       call createGPU(M(ii,ii))
       call copyToGPU(M(ii,ii))
       call createGPU(M(ii-1,ii))
       call copyToGPU(M(ii-1,ii))
       call createGPU(M(ii,ii-1))
       call copyToGPU(M(ii,ii-1))
    end do

  end subroutine copy_trid_toGPU_${KIND}$
#:enddef copy_trid_toGPU_template

#:def delete_trid_fromGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)
  subroutine delete_trid_fromGPU_${KIND}$(M)
    type(${MTYPE}$), dimension(:,:), intent(inout) :: M
    integer :: ii, nbl

    nbl = size(M,1)
    call deleteGPU(M(1,1))
    do ii=2,nbl
       call deleteGPU(M(ii,ii))
       call deleteGPU(M(ii-1,ii))
       call deleteGPU(M(ii,ii-1))
    end do
  end subroutine delete_trid_fromGPU_${KIND}$
#:enddef delete_trid_fromGPU_template

#:def copy_trid_toHOST_template(KIND, CTYPE, MTYPE, CUDATYPE)
  subroutine copy_trid_toHOST_${KIND}$(M)
    type(${MTYPE}$), dimension(:,:), intent(inout) :: M
    integer :: ii, nbl

    nbl = size(M,1)
    call copyFromGPU(M(1,1))
    do ii=2,nbl
       call copyFromGPU(M(ii,ii))
       call copyFromGPU(M(ii-1,ii))
       call copyFromGPU(M(ii,ii-1))
    end do
  end subroutine copy_trid_toHOST_${KIND}$
#:enddef copy_trid_toHOST_template

#:def copy_vdns_toGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)
  subroutine copy_vdns_toGPU_${KIND}$(V)
    type(${MTYPE}$), dimension(:), intent(in) :: V
    integer :: ii, nbl

    nbl = size(V)
    do ii=1,nbl
       if(allocated(V(ii)%val)) then
          call createGPU(V(ii))
          call copyToGPU(V(ii))
       endif
    end do
  end subroutine copy_vdns_toGPU_${KIND}$
#:enddef copy_vdns_toGPU_template

#:def delete_vdns_fromGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)
  subroutine delete_vdns_fromGPU_${KIND}$(V)
    type(${MTYPE}$), dimension(:) :: V
    integer :: ii, nbl

    nbl = size(V)
    do ii=1,nbl
       if(allocated(V(ii)%val)) then
          call deleteGPU(V(ii))
       endif
    end do
  end subroutine delete_vdns_fromGPU_${KIND}$
#:enddef delete_vdns_fromGPU_template

#:def checksum_template(KIND, CTYPE, MTYPE, CUDATYPE)
  subroutine checksum_${KIND}$(hcublas, A, nome)
    type(cublasHandle), intent(in) :: hcublas
    type(${MTYPE}$), intent(in) :: A
    character(*), intent(in) :: nome

    real(${KIND}$) :: summ

    call asum_gpu(hcublas, A, summ)

    if (ieee_is_nan(summ)) then
       write(*,*) 'GPU:   ',trim(nome),summ
    end if

  end subroutine checksum_${KIND}$
#:enddef checksum_template


#:for PREC in PRECISIONS
     #:set KIND = PREC_ABBREVS[PREC]
     #:set CTYPE = CHAR_ABBREVS['complex'][PREC]
     #:set MTYPE = MAT_TYPES['complex'][PREC]
     #:set CUDATYPE = CUDATYPES[PREC]

     $:createGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:createGPU_async_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:createGPU_only_async_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:copyToGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:copyToGPU_async_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:copyFromGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:deleteGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:deleteGPU_async_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:createAll_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:destroyAll_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:matmul_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:inverse_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:matsum_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:spectral_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:init_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:trace_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:copy_mat_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:asum_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:dagger_gpu_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:copy_trid_toGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:delete_trid_fromGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:copy_trid_toHOST_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:copy_vdns_toGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:delete_vdns_fromGPU_template(KIND, CTYPE, MTYPE, CUDATYPE)

     $:checksum_template(KIND, CTYPE, MTYPE, CUDATYPE)

 #:endfor
end module cudautils
