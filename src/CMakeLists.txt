set(sources-fpp
  clock.F90
  ln_extract.F90
  input_output.F90
  ln_cache.F90
  lib_param.F90
  ln_enums.F90
  ln_precision.F90
  mpi_globals.F90
  contselfenergy.F90
  inversions.F90
  libnegf.F90
  ln_structure.F90
  outmatrix.F90
  distributions.F90
  ln_allocation.F90
  load.F90
  sparsekit_drv.F90
  integrations.F90
  globals.F90
  iterative.F90
  ln_constants.F90
  mat_def.F90
  population.F90
  energy_mesh.F90
  equiv_kpoints.F90
  interactions.F90
  ln_elastic.F90
  ln_inelastic.F90
  elphdd.F90
  elphdb.F90
  elphds.F90
  elphinel.F90
  self_energy.F90
  scba.F90
  sparskit/skit_blassm.F90
  sparskit/skit_formats.F90
  sparskit/skit_module.F90
  sparskit/skit_unary.F90)

if(WITH_HILBERT)
  list(APPEND sources-fpp transform.F90)
endif()

if(WITH_TRANSPORT_GPU)
  list(APPEND sources-fpp cudautils.F90)
  list(APPEND sources-fpp iterative_gpu.F90)
  set(sources-cuda gpuroutines.cu)
  set_source_files_properties(
    gpuroutines.cu
    PROPERTIES INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/include)
else()
  list(APPEND sources-fpp iterative_cpu.F90)
endif()

set(sources-f90
  api/libnegfAPICommon.f90
  api/libnegf_api.f90)

#execute_process(COMMAND git describe OUTPUT_VARIABLE gitrevision)
set(gitrevision "000")
string(TIMESTAMP compdate "%Y-%m-%d")

set(fyppdefs -D_GITREVISION=\"${gitrevision}\" -D_COMPDATE=\"${compdate}\")
if(WITH_MPI)
  list(APPEND fyppdefs -DMPI)
endif()


if(WITH_TRANSPORT_GPU)
  list(APPEND fyppdefs -DGPU)
endif()

set(sources-fpp-f90)
foreach(fppsrc IN LISTS sources-fpp)
  string(REGEX REPLACE "\\.F90" ".f90" f90src ${fppsrc})
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${f90src}
    COMMAND ${FYPP}
      -I${PROJECT_SOURCE_DIR}/include
      ${fyppdefs} ${CMAKE_CURRENT_SOURCE_DIR}/${fppsrc}
      ${CMAKE_CURRENT_BINARY_DIR}/${f90src}
    MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/${fppsrc}
    DEPENDS ${PROJECT_SOURCE_DIR}/include/assert.fypp
    VERBATIM)
  list(APPEND sources-fpp-f90 ${CMAKE_CURRENT_BINARY_DIR}/${f90src})
endforeach()


  if(WITH_TRANSPORT_GPU)
     add_library(negf ${sources-fpp-f90} ${sources-f90} ${sources-cuda})
  else()
     add_library(negf ${sources-fpp-f90} ${sources-f90})
  endif()

target_sources(negf PRIVATE $<TARGET_OBJECTS:syscalls_objlib>)
target_include_directories(negf PUBLIC
  $<BUILD_INTERFACE:$<TARGET_PROPERTY:syscalls_objlib,INTERFACE_INCLUDE_DIRECTORIES>>)

set(BUILD_MOD_DIR ${CMAKE_CURRENT_BINARY_DIR}/include)

set_target_properties(negf PROPERTIES Fortran_MODULE_DIRECTORY ${BUILD_MOD_DIR})
set_property(TARGET negf PROPERTY CUDA_ARCHITECTURES OFF)

if(WITH_OMP)
  find_package(OpenMP REQUIRED)
  target_link_libraries(negf PUBLIC OpenMP::OpenMP_Fortran)
endif()

if(WITH_MPI)
  find_package(MPI REQUIRED)
  target_link_libraries(negf PUBLIC MpiFx::MpiFx)
  # MPI::MPI_Fortran cannot be made PUBLIC because the compile options of this
  # target may cause errors or warnings when passed to a C compiler (e.g., when
  # using MPICH 4.0.2 on Debian 12).  Unfortunately we cannot manually add
  # INTERFACE compile options because this leads to build problems on
  # * JUWELS with Rocky Linux 8, ParaStationMPI 5.9.2-1, CMake 3.26.3 and
  # * Debian 11, IntelMPI 2021, Intel Fortran 2021
  # due to malformed linker flags (the individual flags are passed as a string
  # instead of a list).
  # As a consequence of marking this dependency PRIVATE, every dependee of this
  # target has to manually add an MPI dependency.
  target_link_libraries(negf PRIVATE MPI::MPI_Fortran)
endif()

if(WITH_TRANSPORT_GPU)
  find_package(CUDAToolkit REQUIRED)
  target_link_libraries(negf PRIVATE CUDA::cudart CUDA::cusolver CUDA::cublas)
endif()

if (NOT "${BLAS_LIBRARY}" STREQUAL "NONE")
  target_link_libraries(negf PRIVATE ${BLAS_LIBRARY})
endif()
if (NOT "${LAPACK_LIBRARY}" STREQUAL "NONE")
  target_link_libraries(negf PRIVATE ${LAPACK_LIBRARY})
endif()

target_include_directories(negf PUBLIC
  $<BUILD_INTERFACE:${BUILD_MOD_DIR}>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${INSTALL_MOD_DIR}>)

install(TARGETS negf
  EXPORT negf-targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(INSTALL_INCLUDE_FILES)
  install(DIRECTORY ${BUILD_MOD_DIR}/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${INSTALL_MOD_DIR})
endif()
