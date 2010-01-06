#ifndef __TOUCHLIB_MESH2D__
#define __TOUCHLIB_MESH2D__



#include <vector>

#include "vector2d.h"
#include "Image.h"
#include "rect2d.h"
#include <math.h>

// TODO: allow a mesh to be read from a file (xml file?)


//#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>


#include <touchlib_platform.h>

namespace touchlib 
{
	template <class T>
	class TOUCHLIB_CORE_EXPORT mesh2d
	{
	public:
		mesh2d()
		{
			position = vector2d<T>(0,0);
			offset = vector2d<T>(0,0);
			rotation = 0;
			scale = vector2df(0.1f, 0.1f);
		};
		~mesh2d()
		{
		};
		
		bool isCollidedWith(mesh2d<T> &other, bool bbonly=true)
		{

			if(bbox.isRectCollided(other.bbox))
			{
				if(bbonly)
					return true;

				//FIXME: do point by point check.. 

			} else {
				return false;
			}
		};

		void collideMoveWith(vector2d<T> &myOffset, mesh2d<T> other, vector2d<T> &otherOffset)
		{
			// Determine if the two meshes would intersect each other
		};

		void recalcBoundingBox()
		{
			if(points.size() > 0)
			{
				bbox.reset(points[0]);

				int i;
				int n = points.size();
				for(i=1; i<n; i++)
				{
					bbox.addPoint(points[i]);
				}
			}

		};

		bool isPointInTriangle(vector2d<T> &p, int t)
		{
			vector2d<T> a = points[triangles[t+0]];
			vector2d<T> b = points[triangles[t+1]];
			vector2d<T> c = points[triangles[t+2]];

			if (vector2d<T>::isOnSameSide(p,a, b,c) && vector2d<T>::isOnSameSide(p,b, a,c) && vector2d<T>::isOnSameSide(p, c, a, b))
				return true;
			else 
				return false;
		};


		// finds which triangle this point is within (if any).
		// returns -1 if not inside
		int findTriangleWithin(vector2d<T> p)
		{
			int i;

			vector2d<T> pt_local = transformToLocal(p);



			for(i=0; i<triangles.size(); i+=3)
			{
				if(isPointInTriangle(pt_local, i))
				{
					return i;
				}
			}

			return -1;
		};

		vector2d<T> transformToLocal(vector2d<T> &p)
		{
			vector2d<T> pt_local;
			pt_local = p - position;
			pt_local += offset;

			pt_local /= scale;

			pt_local.rotateBy(-rotation, offset);



			pt_local -= offset;

			return pt_local;
		}

		int findClosestPoint(vector2d<T> p)
		{
			unsigned int i;

			vector2d<T> pt_local = transformToLocal(p);

			int closest_i = -1;
			float closest_dist = 9999.0f;
			for(i=0; i<points.size(); i++)
			{
				float dist = points[i].getDistanceFromSQ(pt_local);
				if(dist < closest_dist)
				{
					closest_i = (int)i;
					closest_dist = dist;
				}
			}

			return closest_i;
		}

		void getBarycentricCoords(vector2d<T> pt, int tri_ind, float &bary_A, float &bary_B, float &bary_C)
		{
			vector2d<T> pt_local;
			pt_local = pt - position;
			pt_local.rotateBy(-rotation, vector2d<T>(0,0));
			pt_local /= scale;

			vector2df A = points[triangles[tri_ind+0]];
			vector2df B = points[triangles[tri_ind+1]];
			vector2df C = points[triangles[tri_ind+2]];

			float total_area = (A.X - B.X) * (A.Y - C.Y) - (A.Y - B.Y) * (A.X - C.X);

			// pt,B,C
			float area_A = (pt_local.X - B.X) * (pt_local.Y - C.Y) - (pt_local.Y - B.Y) * (pt_local.X - C.X);

			// A,pt,C
			float area_B = (A.X - pt_local.X) * (A.Y - C.Y) - (A.Y - pt_local.Y) * (A.X - C.X);

			// A,B,pt
			float area_C = (A.X - B.X) * (A.Y - pt_local.Y) - (A.Y - B.Y) * (A.X - pt_local.X);

			bary_A = area_A / total_area;
			bary_B = area_B / total_area;
			bary_C = area_C / total_area;
		};
		
		void readOBJFile(char *filename)
		{
			textureFilename = "";

			points.clear();
			colors.clear();
			uv.clear();

			triangles.clear();
			uv_triangles.clear();

			std::ifstream fp_in;  

			std::string matfile;

			fp_in.open(filename, std::ios::in);  
			char line[255];
			char tmpstr[255];
			if(fp_in.is_open())
			{
				while(fp_in.getline(line, 255))
				{
					char sztype[255];
					char tmpc, tmpc2;

					if(line[0] == 'v' && line[1] == ' ')
					{
						float x=0, y=0, z=0;
						RgbPixelFloat c;
						c.r = 0.0;
						c.g = 1.0;
						c.b = 0.0;
	
						sscanf(line, "%c %f %f %f", &tmpc, &x, &y, &z);
						vector2d<T> vec(x, y);
						points.push_back(vec);
						colors.push_back(c);
					}
					if(line[0] == 'v' && line[1] == 't')		// texture coordinate
					{
						float u=0, v=0;

	
						sscanf(line, "%c%c %f %f", &tmpc, &tmpc2, &u, &v);
						vector2df vec(u, v);
						uv.push_back(vec);

					}
					if(line[0] == 'm')
					{
						sscanf(line, "%c %s", &tmpc, tmpstr);
						textureFilename = tmpstr;
					}
					if(line[0] == 'f')
					{
						int i1, i2, i3;
						int ti1, ti2, ti3;
						sscanf(line, "%c %d/%d %d/%d %d/%d", &tmpc, &i1, &ti1, &i2, &ti2, &i3, &ti3);
						triangles.push_back((i1-1));
						triangles.push_back((i2-1));
						triangles.push_back((i3-1));

						uv_triangles.push_back((ti1-1));
						uv_triangles.push_back((ti2-1));
						uv_triangles.push_back((ti3-1));

					}
				}

				// FIXME: open Material file and steal the texture name.
				// textureFilename = ;

				fp_in.close();   // close the streams
			}

			recalcBoundingBox();
			calculateHull();
			calculateAngles();
		};

		void addEdge(int v1, int v2)
		{
			unsigned int i;

			for(i=0; i<edges.size(); i+=2)
			{
				if((edges[i] == v1 && edges[i+1] == v2) ||
					(edges[i] == v2 && edges[i+1] == v1))
					return;
			}

			edges.push_back(v1);
			edges.push_back(v2);
		}

		std::string textureFilename;

		std::vector<vector2d<T> > points;
		std::vector<vector2df > uv;		// uv coords for each point..
		std::vector<RgbPixelFloat> colors;
		std::vector<int> triangles;		// 3 = 1 tri
		std::vector<int> uv_triangles;		// 3 = 1 tri.. Indices for the UV
		std::vector<float> angles;
		rect<T> bbox;

		std::vector<int> edges;		// 2 = 1 edge
		std::vector<int> hull_edges;		// 2 = 1 edge
		std::vector<float> lengths;
		std::vector<vector2d<T> > edgevectors;
		//std::vector<int> hull_vertices;		//

		vector2d<T> position;
		vector2d<T> offset;
		float rotation;
		vector2df scale;


		// should also keep track of all the angles.


		void calculateAngles()
		{
			angles.clear();

			unsigned int i;
			unsigned int tri_inds = triangles.size();

			for(i=0; i<tri_inds; i+=3)
			{
				float angle;
				vector2d<T> v1, v2;

				// point 1
				v1 = points[triangles[i+1]] - points[triangles[i]];
				v2 = points[triangles[i+2]] - points[triangles[i]];

				angle = acosf( v1.dotProduct(v2) / (v1.getLength() * v2.getLength()) );

				angles.push_back(angle);

				// point 2
				v1 = points[triangles[i+2]] - points[triangles[i+1]];
				v2 = points[triangles[i]] - points[triangles[i+1]];

				angle = acosf( v1.dotProduct(v2) / (v1.getLength() * v2.getLength()) );

				angles.push_back(angle);

				// point 3
				v1 = points[triangles[i]] - points[triangles[i+2]];
				v2 = points[triangles[i+1]] - points[triangles[i+2]];

				angle = acosf( v1.dotProduct(v2) / (v1.getLength() * v2.getLength()) );

				angles.push_back(angle);
				
				// all three angles should add up to 180
			}
		}

		void calculateLengths()
		{
			unsigned int i;
			for(i=0; i<edges.size(); i+=2)
			{
				vector2d<T> edgevec = points[edges[i]]-points[edges[i+1]];
				lengths[i/2] = edgevec.getLength();
				edgevectors[i/2] = edgevec.normalize();

			}
		}
	private:
		void calculateHull() 
		{
			edges.clear();
			lengths.clear();
			hull_edges.clear();
			edgevectors.clear();


			//hull_vertices.clear();
			std::vector<int> num_tris;		// the number of triangles that an edge forms.. 1 or 2

			unsigned int i, j;
			unsigned int tri_inds = triangles.size();


			for(i=0; i<tri_inds; i+=3)
			{

				bool exists = false;

				for(j=0; j<edges.size(); j+=2)
				{
					if((edges[j] == triangles[i] && edges[j+1] == triangles[i+1]) ||
						(edges[j] == triangles[i+1] && edges[j+1] == triangles[i]))
					{
						num_tris[j/2]++;
						exists = true;
						break;
					}
				}

				if(!exists)
				{
					edges.push_back(triangles[i]);
					edges.push_back(triangles[i+1]);

					vector2d<T> edgevec = (points[triangles[i]]-points[triangles[i+1]]);
					lengths.push_back(edgevec.getLength());
					edgevectors.push_back(edgevec.normalize());

					num_tris.push_back(1);
				}

				// edge 2
				exists = false;

				for(j=0; j<edges.size(); j+=2)
				{
					if((edges[j] == triangles[i+1] && edges[j+1] == triangles[i+2]) ||
						(edges[j] == triangles[i+2] && edges[j+1] == triangles[i+1]))
					{
						num_tris[j/2]++;
						exists = true;
						break;
					}
				}

				if(!exists)
				{
					edges.push_back(triangles[i+1]);
					edges.push_back(triangles[i+2]);

					vector2d<T> edgevec = (points[triangles[i+1]]-points[triangles[i+2]]);
					lengths.push_back(edgevec.getLength());
					edgevectors.push_back(edgevec.normalize());

					num_tris.push_back(1);
				}

				// edge 3

				exists = false;

				for(j=0; j<edges.size(); j+=2)
				{
					if((edges[j] == triangles[i+2] && edges[j+1] == triangles[i]) ||
						(edges[j] == triangles[i] && edges[j+1] == triangles[i+2]))
					{
						num_tris[j/2]++;
						exists = true;
						break;
					}
				}

				if(!exists)
				{
					edges.push_back(triangles[i+2]);
					edges.push_back(triangles[i]);

					vector2d<T> edgevec = (points[triangles[i+2]]-points[triangles[i]]);
					lengths.push_back(edgevec.getLength());
					edgevectors.push_back(edgevec.normalize());

					num_tris.push_back(1);
				}
			}

			// get hull edges..

			int num_edges = edges.size();

			for(i=0; i<num_edges; i+=2)
			{
				if(num_tris[i/2] == 1)
				{
					hull_edges.push_back(edges[i]);
					hull_edges.push_back(edges[i+1]);
				}
			}

			// todo:
			// for all edges, if an edge only forms one triangle,
			// then it is an outer (hull) edge.
			// both it's points are outer vertices.
			// we can use this info for collision detection or other stuff.
		};


	};

	//! Typedef for float 2d mesh.
	typedef mesh2d<float> mesh2df;
	//! Typedef for integer 2d mesh.
	typedef mesh2d<int> mesh2di;

}

#endif
