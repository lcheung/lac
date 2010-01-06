
/*
	C++ port of Gustav Taxen's (gustavt@nada.kth.se) C implementation
	of Jos Stam's fast 2D fluid solver, itself built on five hundred
	years of unpatented work in the study of turbulence.

	Portions of this code by Gustav Taxen,
	http://www.nada.kth.se/~gustavt/fluids/

	Portions of the code by Jos Stam, from the paper "A Simple Fluid 
	Solver Based on the FFT", available at
	http://www.dgp.utoronto.ca/people/stam/reality/Research/pub.html
*/
	

#ifndef __FLUID2D__
#define __FLUID2D__

#include "rfftw.h"
#include "fftw.h"

class Fluid2D
{

public:

	Fluid2D(int nsize, float timestep, float viscosity);
	~Fluid2D();
	void Evolve();
	void Drag(float nx, float ny, float dnx, float dny, float rfactor, float gfactor, float bfactor);
	const fftw_real* getDensityFieldR(void){ return r;}
	const fftw_real* getDensityFieldG(void){ return g;}
	const fftw_real* getDensityFieldB(void){ return b;}
	const fftw_real* getVelocityFieldX(void){ return u;}
	const fftw_real* getVelocityFieldY(void){ return v;}
	const int getMeshSize(void){ return n;}

private:

	void stable_solve( fftw_real visc, fftw_real dt );
	void diffuse_matter( fftw_real dt );
	void setForces(void);
	void zero_boundary(void);

	fftw_real *u, *v, *u0, *v0;  // velocity field
	fftw_real *r, *r0;  // density field for colour r
	fftw_real *g, *g0;  // density field for colour g
	fftw_real *b, *b0;  // density field for colour b
	fftw_real *u_u0, *u_v0;  // user-induced forces

	int n;
	rfftwnd_plan plan_rc, plan_cr;
	fftw_real t;
	float dt, viscosity;


};

#endif // __FLUID2D__
