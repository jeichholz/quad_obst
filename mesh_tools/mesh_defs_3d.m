edge_by_vertices=[-1 1 2 3;
                   1 -1 4 5;
                   2 4 -1 6;
                   3 5 6 -1];
               
opp_vertices_by_edge=[3 4;
                      2 4;
                      2 3;
                      1 4;
                      1 3;
                      1 2];
               
edges_by_face=[edge_by_vertices(2,3) edge_by_vertices(2,4) edge_by_vertices(3,4);
               edge_by_vertices(1,3) edge_by_vertices(1,4) edge_by_vertices(3,4);
               edge_by_vertices(1,2) edge_by_vertices(1,4) edge_by_vertices(2,4);
               edge_by_vertices(1,2) edge_by_vertices(1,3) edge_by_vertices(2,3)];
               
vertices_by_edge=[ 1 2;
                   1 3;
                   1 4;
                   2 3;
                   2 4;
                   3 4];
               
opp_edge_by_face_and_node=[-1, 4,5,6;
                            6, -1, 3,2;
                            5, 3, -1, 1;
                            4, 2, 1, -1];