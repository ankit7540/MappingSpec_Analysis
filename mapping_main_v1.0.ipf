#pragma rtGlobals=3		// Use modern global access method and strict wave access.


// ******************************************************************************************************************************
// ******************************************************************************************************************************

// For the analysis of one peak in a 2D mapping matrix data for its parameters like
	//	y offset
	//	amplitude
	//	peakPosition
	//	peak width
// using fitting  using gauss band

function map_autofitMatrix( inputMatrix , xaxis, startPnt , endPnt )
	wave inputMatrix 	// name of your data wave
	wave xaxis 		// name of your raman shift wave
	variable startPnt 	// this macro will fit a band in the region startwn cm-1 to endwn cm-1 by a single gaussian with a constant offset
	variable endPnt 	// startwn < endwn must be satisfied

	variable xdim = dimsize( inputMatrix ,0)
	variable ydim = dimsize( inputMatrix,1)
	
	variable i
	
	if (endPnt < startPnt)
		abort ("map_autofitMatrix: Error : endpoint smaller than the start point. Try again with correct input.")
	endif
	
			
	make/O/n=(xdim)/FREE temp
	make/O/n=(ydim) autofit_offset			// outputwave
	make/O/n=(ydim) autofit_Amplitude		// outputwave
	make/O/n=(ydim) autofit_peakposition	// outputwave
	make/O/n=(ydim) autofit_width			// outputwave
	
	
	for(i=0;i<ydim;i+=1)
		temp = inputMatrix [p][i]
		
		// curve fitting to gauss function
		curvefit /Q/W=2 gauss, temp[startPnt,  endPnt]  /X=xaxis
		
		// save results 
		wave w_coef
		 autofit_offset[i] = w_coef[0]			// save as output
		 autofit_Amplitude[i] = w_coef[1]   	// save as output
		 autofit_peakposition[i] = W_coef[2]	// save as output
		 autofit_width[i] = w_coef[3]			// save as output
		 
	endfor

end

// ******************************************************************************************************************************
// ******************************************************************************************************************************

// Generate the mapping image for certain parameter (obtained from analysis of a 2d matrix)

function map_genImage_from_1D( inputWave, xpnts, ypnts, transpose )
	wave inputWave	//	parameter wave
	variable xpnts		//	number of map points in x
	variable ypnts		//	number of map points in y
	variable transpose	//	do transpose after map generation, 0=no, 1=yes
	
	variable i,j, cv, val
	
	make /d /o /n=(xpnts, ypnts) /WAVE mapImage
	duplicate /o inputWave, outputImg
	Redimension/N=(xpnts, ypnts) outputImg
	
	if (transpose ==1)
		matrixop /o  outputImg = outputImg^t
	endif	

end

// ******************************************************************************************************************************
// ******************************************************************************************************************************

