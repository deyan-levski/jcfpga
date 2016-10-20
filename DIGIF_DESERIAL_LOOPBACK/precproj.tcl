#project
file mkdir "/media/data/git/jcfpga/DIGIF_DESERIAL_LOOPBACK/Precision"
set project_file [file join "/media/data/git/jcfpga/DIGIF_DESERIAL_LOOPBACK/Precision" "Precision"]
set project_file $project_file.psp
file delete "/media/data/git/jcfpga/DIGIF_DESERIAL_LOOPBACK/Precision/*_temp_*"
if { [file exists $project_file] } {
  open_project $project_file
} else {
  new_project -name Precision -folder "/media/data/git/jcfpga/DIGIF_DESERIAL_LOOPBACK/Precision"
}

#implementation
set impl_file [file join "/media/data/git/jcfpga/DIGIF_DESERIAL_LOOPBACK/Precision/Precision_impl_DIGIF_DESERIAL_LOOPBACK" "Precision_impl_DIGIF_DESERIAL_LOOPBACK"]
set impl_file $impl_file.psi
if { [file exists $impl_file] } {
  activate_impl -impl Precision_impl_DIGIF_DESERIAL_LOOPBACK
} else {
  new_impl -name Precision_impl_DIGIF_DESERIAL_LOOPBACK
}
set_input_dir "/media/data/git/jcfpga/DIGIF_DESERIAL_LOOPBACK"
