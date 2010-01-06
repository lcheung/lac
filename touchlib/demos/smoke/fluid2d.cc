
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

#include "fluid2d.h"
#include <math.h>
#include <iostream>


#define floor(x) ((x)>=0.0?((int)(x)):(-((int)(1-(x)))))
#define FFT(s,u)\
	if(s==1) rfftwnd_one_real_to_complex(plan_rc,(fftw_real *)u,(fftw_complex*)u);\
	else rfftwnd_one_complex_to_real(plan_cr,(fftw_complex *)u,(fftw_real *)u)



Fluid2D::Fluid2D(int nsize, float timestep, float setviscosity)
{
	n = nsize;
	dt = timestep;
	viscosity = setviscosity;

	u = new fftw_real[n * 2*(n/2+1)];
	v = new fftw_real[n * 2*(n/2+1)];
	u0 = new fftw_real[n * 2*(n/2+1)];
	v0 = new fftw_real[n * 2*(n/2+1)];

	r = new fftw_real[n * n];
	r0 = new fftw_real[n * n];
	g = new fftw_real[n * n];
	g0 = new fftw_real[n * n];
	b = new fftw_real[n * n];
	b0 = new fftw_real[n * n];

	u_u0 = new fftw_real[n * n];
	u_v0 = new fftw_real[n * n];

	plan_rc = rfftw2d_create_plan(n, n, FFTW_REAL_TO_COMPLEX, FFTW_IN_PLACE);
	plan_cr = rfftw2d_create_plan(n, n, FFTW_COMPLEX_TO_REAL, FFTW_IN_PLACE);

	t = 0.0;
	for( int i=0; i<n*n; i++ )
	{
		u[i] = v[i] = u0[i] = v0[i] = r[i] = r0[i] = g[i] = g0[i] = b[i] = b0[i] = u_u0[i] = u_v0[i] = 0.0f;
	}
}



void Fluid2D::Evolve()
{
	setForces();
	stable_solve(viscosity, dt);
	diffuse_matter( dt );
	zero_boundary();
	t += (fftw_real) dt;
}


Fluid2D::~Fluid2D()
{
	delete[] u;
	delete[] v;
	delete[] u0;
	delete[] v0;
	delete[] r;
	delete[] r0;
	delete[] g;
	delete[] g0;
	delete[] b;
	delete[] b0;
	delete[] u_u0;
	delete[] u_v0;
}


void Fluid2D::stable_solve( fftw_real visc, fftw_real dt )
{

	fftw_real x, y, x0, y0, f, r, U[2], V[2], s, t;
	int i, j, i0, j0, i1, j1;

	for ( i=0 ; i<n*n ; i++ )
	{
		u[i] += dt*u0[i]; 
		u0[i] = u[i];

		v[i] += dt*v0[i]; 
		v0[i] = v[i];
	}    

	for ( x=0.5f/n,i=0 ; i<n ; i++,x+=1.0f/n )
	{
		for ( y=0.5f/n,j=0 ; j<n ; j++,y+=1.0f/n )
		{
			x0 = n*(x-dt*u0[i+n*j])-0.5f; 
			y0 = n*(y-dt*v0[i+n*j])-0.5f;
			i0 = floor(x0);
			s = x0-i0;
			i0 = (n+(i0%n))%n;
			i1 = (i0+1)%n;
			j0 = floor(y0);
			t = y0-j0;
			j0 = (n+(j0%n))%n;
			j1 = (j0+1)%n;
			u[i+n*j] = (1-s)*((1-t)*u0[i0+n*j0]+t*u0[i0+n*j1])+                        
				s *((1-t)*u0[i1+n*j0]+t*u0[i1+n*j1]);
			v[i+n*j] = (1-s)*((1-t)*v0[i0+n*j0]+t*v0[i0+n*j1])+
				s *((1-t)*v0[i1+n*j0]+t*v0[i1+n*j1]);
		}    
	} 

	for ( i=0 ; i<n ; i++ )
		for ( j=0 ; j<n ; j++ )
		{ 
			u0[i+(n+2)*j] = u[i+n*j]; 
			v0[i+(n+2)*j] = v[i+n*j];
		}

		FFT(1,u0);
		FFT(1,v0);

		for ( i=0 ; i<=n ; i+=2 )
		{
			x = 0.5f*i;
			for ( j=0 ; j<n ; j++ )
			{
				y = j<=n/2 ? (fftw_real)j : (fftw_real)j-n;
				r = x*x+y*y;
				if ( r==0.0f ) continue;
				f = (fftw_real)exp(-r*dt*visc);
				U[0] = u0[i  +(n+2)*j]; V[0] = v0[i  +(n+2)*j];
				U[1] = u0[i+1+(n+2)*j]; V[1] = v0[i+1+(n+2)*j];

				u0[i  +(n+2)*j] = f*( (1-x*x/r)*U[0]     -x*y/r *V[0] );
				u0[i+1+(n+2)*j] = f*( (1-x*x/r)*U[1]     -x*y/r *V[1] );
				v0[i+  (n+2)*j] = f*(   -y*x/r *U[0] + (1-y*y/r)*V[0] );
				v0[i+1+(n+2)*j] = f*(   -y*x/r *U[1] + (1-y*y/r)*V[1] );
			}    
		}

		FFT(-1,u0); 
		FFT(-1,v0);

		f = 1.0/(n*n);
		for ( i=0 ; i<n ; i++ )
			for ( j=0 ; j<n ; j++ )
			{
				u[i+n*j] = f*u0[i+(n+2)*j]; 
				v[i+n*j] = f*v0[i+(n+2)*j]; 
			}
} 



/*
* This function diffuses matter that has been placed
* in the velocity field. It's almost identical to the
* velocity diffusion step in the function above. The
* input matter densities are in r0,g0,b0 and the result
* is written into r,g,b.
*
*/
void Fluid2D::diffuse_matter( fftw_real dt )
{
	fftw_real x, y, x0, y0, s, t;
	int i, j, i0, j0, i1, j1;

	for ( x=0.5f/n,i=0 ; i<n ; i++,x+=1.0f/n ) {
		for ( y=0.5f/n,j=0 ; j<n ; j++,y+=1.0f/n ) {
			x0 = n*(x-dt*u[i+n*j])-0.5f; 
			y0 = n*(y-dt*v[i+n*j])-0.5f;
			i0 = floor(x0);
			s = x0-i0;
			i0 = (n+(i0%n))%n;
			i1 = (i0+1)%n;
			j0 = floor(y0);
			t = y0-j0;
			j0 = (n+(j0%n))%n;
			j1 = (j0+1)%n;
			r[i+n*j] = (1-s)*((1-t)*r0[i0+n*j0]+t*r0[i0+n*j1])+                        
				s *((1-t)*r0[i1+n*j0]+t*r0[i1+n*j1]);
			g[i+n*j] = (1-s)*((1-t)*g0[i0+n*j0]+t*g0[i0+n*j1])+                        
				s *((1-t)*g0[i1+n*j0]+t*g0[i1+n*j1]);
			b[i+n*j] = (1-s)*((1-t)*b0[i0+n*j0]+t*b0[i0+n*j1])+                        
				s *((1-t)*b0[i1+n*j0]+t*b0[i1+n*j1]);
		}    
	} 
}


void Fluid2D::zero_boundary()
{
	for( int i=0; i<n; i++ )
	{
		// bottom edge
		u[0*n + i] = 0.0;
		v[0*n + i] = 0.0;
		u0[0*n + i] = 0.0;
		v0[0*n + i] = 0.0;

		// top edge
		u[(n-1)*n + i] = 0.0;
		v[(n-1)*n + i] = 0.0;
		u0[(n-1)*n + i] = 0.0;
		v0[(n-1)*n + i] = 0.0;

		// left edge
		u[i*n + 0] = 0.0;
		v[i*n + 0] = 0.0;
		u0[i*n + 0] = 0.0;
		v0[i*n + 0] = 0.0;

		// right edge
		u[i*n + n-1] = 0.0;
		v[i*n + n-1] = 0.0;
		u0[i*n + n-1] = 0.0;
		v0[i*n + n-1] = 0.0;
	}

}



// drag at normalized location nx, ny
void Fluid2D::Drag(float nx, float ny, float dnx, float dny, float rfactor, float gfactor, float bfactor)
{
	int     xi;
	int     yi;
	float  len;
	int     X, Y;

	// Compute the array index that corresponds to the cursor location
	xi = (int)floor((float)(n + 1) * nx);
	yi = (int)floor((float)(n + 1) * ny);

	X = xi;
	Y = yi;

	if (X > (n - 1)) {
		X = n - 1;
	}
	if (Y > (n - 1)) {
		Y = n - 1;
	}
	if (X < 0) {
		X = 0;
	}
	if (Y < 0) {
		Y = 0;
	}

	// Add force at the cursor location
	len = sqrt(dnx * dnx + dny * dny);
	if (len != 0.0) 
	{ 
		dnx *= 0.1 / len;
		dny *= 0.1 / len;
	}
	u_u0[Y * n + X] += dnx;
	u_v0[Y * n + X] += dny;

	// Increase matter densities at the cursor location
	r[Y * n + X] = 10.0f * rfactor;
	g[Y * n + X] = 10.0f * gfactor;
	b[Y * n + X] = 10.0f * bfactor;

}


/*
* Copy user-induced forces to the force vectors
* that is sent to the solver. Also dampen forces and
* matter density.
*
*/
void Fluid2D::setForces(void)
{
	int i;
	for (i = 0; i < n * n; i++) {
		r0[i] = 0.995 * r[i];
		g0[i] = 0.995 * g[i];
		b0[i] = 0.995 * b[i];

		u_u0[i] *= 0.85;
		u_v0[i] *= 0.85;

		u0[i] = u_u0[i];
		v0[i] = u_v0[i];
	}
}
