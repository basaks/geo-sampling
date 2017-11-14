show_save_statistics <- function(cov_names, res, dsn_folder){
 
  par(mfrow = c(2,1))
  #Save histograms in the folders
  for(i in 1:length(cov_names)){
    pdf(paste(dsn_folder, paste0(cov_names[i],".pdf"), sep = "/"))
    
    tmp_cov <- res$initial_object[[i]]
    if(!is.numeric(tmp_cov))  
      tmp_cov <- as.numeric(tmp_cov)
    hist(tmp_cov, main = paste("Original histogram of",cov_names[i]), xlab = paste("Mean:",mean(tmp_cov, na.rm = TRUE), ", Variance", var(tmp_cov, na.rm = TRUE)), freq = FALSE)
    x_lim = range(tmp_cov, na.rm = TRUE)

    tmp_cov <- res$sampled_data[[i]]
    if(!is.numeric(tmp_cov))  
      tmp_cov <- as.numeric(tmp_cov)
    hist(tmp_cov, main = paste("cLHS histogram of",cov_names[i]), xlim = x_lim, xlab = paste("Mean:",mean(tmp_cov, na.rm = TRUE), ", Variance", var(tmp_cov, na.rm = TRUE)), freq = FALSE)
    
    #dev.print(pdf, paste(dsn_folder, paste0(cov_names[i],".pdf"), sep = "/"))
    dev.off()
  }
  par(mfrow = c(1,1))
}