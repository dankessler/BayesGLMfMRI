
organize_replicates <- function(n_sess, nx, mesh){

	# create vectors for each task: 
	# n_sess is the number of sessions sharing hyperparameters (can be different tasks)

	# beta and repl vectors are of length nvox * n_sess * nx
	# ith repl vector is an indicator vector for the cells corresponding to the ith column of x
	# ith beta vector contains data indices (e.g. 1,...,V) in the cells corresponding to the ith column of x

	spatial <- mesh$idx$loc 
	nvox <- length(spatial)

	grps <- ((1:(n_sess*nx) + (nx-1)) %% nx) + 1 # 1, 2, .. nx, 1, 2, .. nx, ...
	repls <- vector('list', nx)
	betas <- vector('list', nx)
	for(i in 1:nx){
		inds_i <- (grps == i)

		#set up replicates vectors
		sess_NA_i <- rep(NA, n_sess*nx)
		sess_NA_i[inds_i] <- 1:n_sess
		repls[[i]] <- rep(sess_NA_i, each=nvox)
		names(repls)[i] <- paste0('repl',i)

		#set up ith beta vector with replicates for sessions
		NAs <- rep(NA, nvox)
		preNAs <- rep(NAs, times=(i-1))
		postNAs <- rep(NAs, times=(nx-i))
		betas[[i]] <- rep(c(preNAs, spatial, postNAs), n_sess)
		names(betas)[i] <- paste0('bbeta',i)
	}

	result <- list(betas=betas, repls=repls)
	return(result)

}
