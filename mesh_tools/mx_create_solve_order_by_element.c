
#include "linalg.h"
#include "applyS.h"
#include "mexify.h"
#include "misc.h"
#include "create_solve_order.h"

void mexFunction(int nout, mxArray *out[], int nin, const mxArray *in[]) {

	int nargs=4;
	if (nin!=nargs) {
		mexPrintf("You supplied %d of %d arguments.\nPlease provide X,C,nbrs,omegas. Thanksabunch.\n",nin,nargs);
		return;
	}

    matrix* X=matlabtoc(in[0]);

    intmatrix* C=matlabtoc_intmatrix(in[1]);
	intmatrix* nbrs=matlabtoc_intmatrix(in[2]);
	matrix* omegas=matlabtoc(in[3]);
	mwSize temp=omegas->size1;
	out[0] = mxCreateCellArray(1, &temp);

	mex_create_layers_indexed_by_element(X,C,nbrs,omegas,out[0]);



			
		
		

	
	
	

}
