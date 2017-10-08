install_import_packages <- function(required_packages){
  all_packages <- installed.packages()
  all_packages <- all_packages[,"Package"]
  
  #install -> import the requirements
  for(i in length(required_packages)) 
    if(!is.element(required_packages[i],  all_packages))
      install.packages(required_packages[i],repos="https://cran.wu.ac.at/src/contrib/")
  dummy <- lapply(required_packages,library,character.only=TRUE,quietly = TRUE, verbose = FALSE)
}
  
