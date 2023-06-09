package edu.union.adt.graph;
import java.util.*;
/**
 * A graph that establishes connections (edges) between objects of
 * (parameterized) type V (vertices).  The edges are directed.  An
 * undirected edge between u and v can be simulated by two edges: (u,
 * v) and (v, u).
 *
 * The API is based on one from
 *     http://introcs.cs.princeton.edu/java/home/
 *
 * Some method names have been changed, and the ZachGraph type is
 * parameterized with a vertex type V instead of assuming String
 * vertices.
 *
 * @author Zach Dubinsky
 * @version 1
 */
public class ZachGraph<V> implements Graph<V>
{
    private HashMap<V,ArrayList<V>> map;
    /**
     * Create an empty graph.
     */
    public ZachGraph()
    {
      map = new HashMap<V,ArrayList<V>>();
    }

    /**
     * @return the number of vertices in the graph.
     */
    public int numVertices()
    {
      return map.size();
    }

    /**
     * @return the number of edges in the graph.
     */
    public int numEdges()
    {
      int count = 0;
      for(V v : map.keySet()){
        count += map.get(v).size();
      }
      return count;
    }

    /**
     * Gets the number of vertices connected by edges from a given
     * vertex.  If the given vertex is not in the graph, throws a
     * RuntimeException.
     *
     * @param vertex the vertex whose degree we wf(!vert_dict.contains(vertex))
      {
        vert_dict.add(vertex);
        int index = vert_dict.get(vertex);
        for(int row = 0; row < vert_dict.size();row++)
        {
          edge_table[row].add(0)
        }
        edge_table.add(new ArrayList<Integer>(edge_table.size()));
      }ant.
     * @return the degree of vertex 'vertex'
     */
    public int degree(V vertex) throws RuntimeException
    {
        if(!map.containsKey(vertex)){
          throw new RuntimeException();
        }
        return map.get(vertex).size();
    }

    /**
     * Adds a directed edge between two vertices.  If there is already an edge
     * between the given vertices, does nothing.  If either (or both)
     * of the given vertices does not exist, it is added to the
     * graph before the edge is created between them.
     *
     * @param from the source vertex for the added edge
     * @param to the destination vertex for the added edge
     */
    public void addEdge(V from, V to)
    {
      if(!map.containsKey(from)){map.put(from,new ArrayList<V>());}
      if(!map.containsKey(to)){map.put(to,new ArrayList<V>());}
      if(!map.get(from).contains(to)){map.get(from).add(to);}
    }

    /**
     * Adds a vertex to the graph.  If the vertex already exists in
     * the graph, does nothing.  If the vertex does not exist, it is
     * added to the graph, with no edges connected to it.
     *
     * @param vertex the vertex to add
     */
    public void addVertex(V vertex)
    {
      if(!map.containsKey(vertex)){
        map.put(vertex,new ArrayList<V>());
      }
    }

    /**
     * @return the an iterable collection for the set of vertices of
     * the graph.
     */
    public Iterable<V> getVertices()
    {
        return map.keySet();
    }

    /**
     * Gets the vertices adjacent to a given vertex.  A vertex y is
     * "adjacent to" vertex x if there is an edge (x, y) in the graph.
     * Because edges are directed, if (x, y) is an edge but (y, x) is
     * not an edge, we would say that y is adjacent to x but that x is
     * NOT adjacent to y.
     *
     * @param from the source vertex
     * @return an iterable collection for the set of vertices that are
     * the destinations of edges for which 'from' is the source
     * vertex.  If 'from' is not a vertex in the graph, returns an
     * empty iterator.
     */
    public Iterable<V> adjacentTo(V from)
    {
        return map.get(from);
    }

    /**
     * Tells whether or not a vertex is in the graph.
     *
     * @param vertex a vertex
     * @return true iff 'vertex' is a vertex in the graph.
     */
    public boolean contains(V vertex)
    {
        return map.keySet().contains(vertex);
    }

    /**
     * Tells whether an edge exists in the graph.
     *
     * @param from the source vertex
     * @param to the destination vertex
     *
     * @return true iff there is an edge from the source vertex to the
     * destination vertex in the graph.  If either of the given
     * vertices are not vertices in the graph, then there is no edge
     * between them.
     */
    public boolean hasEdge(V from, V to)
    {
        if(map.containsKey(from)){
          return map.get(from).contains(to);
        }
        return false;
    }

      /**
   * Tells whether the graph is empty.
   *
   * @return true iff the graph is empty. A graph is empty if it has
   * no vertices and no edges.
   */
    public boolean isEmpty()
    {
      return map.size() == 0;
    }


    /**
     * Gives a string representation of the graph.  The representation
     * is a series of lines, one for each vertex in the graph.  On
     * each line, the vertex is shown followed by ": " and then
     * followed by a list of the vertices adjacent to that vertex.  In
     * this list of vertices, the vertices are separated by ", ".  For
     * example, for a graph with String vertices "A", "B", and "C", we
     * might have the following string representation:
     *
     * <PRE>
     * A: A, B
     * B:
     * C: A, B
     * </PRE>
     *
     * This representation would indicate that the following edges are
     * in the graph: (A, A), (A, B), (C, A), (C, B) and that B has no
     * adjacent vertices.
     *
     * Note: there are no extraneous spaces in the output.  So, if we
     * replace each space with '*', the above representation would be:
     *
     * <PRE>
     * A:*A,*B
     * B:
     * C:*A,*B
     * </PRE>
     *
     * @return the string representation of the graph
     */
     public String toString()
      {
        if(map.size() == 0){return "";}
        String out = "";
        for(V v0 : map.keySet()){
          out += v0.toString() +":";
          for(V v1 : map.get(v0))
          {
            out+= " "+v1.toString();
          }
          out+="\n";
        }
        return out.substring(0,out.length()-1);
      }
/*
    @Override
    public boolean equals(Graph<V> other) {
        return false;
    }
*/
    public boolean equals(Object other)
    {
        if(!(other instanceof Graph)){return false;}
        Graph<V> otherG = (ZachGraph<V>) other;

        for(V v0 : map.keySet()){
          if(!otherG.contains(v0) || otherG.degree(v0) != this.degree(v0)){return false;}
          for(V v1 : map.get(v0)){
            if(!otherG.hasEdge(v0,v1)){return false;}
          }
        }
        return true;
    }



  /**
   * Removes and vertex from the graph.  Also removes any edges
   * connecting from the edge or to the edge.
   *
   * <p>Postconditions:
   *
   * <p>If toRemove was in the graph:
   * <ul>
   * <li>numVertices = numVertices' - 1
   * <li>toRemove is no longer a vertex in the graph
   * <li>for all vertices v: toRemove is not in adjacentTo(v)
   * </ul>
   *
   * @param toRemove the vertex to remove.
   */
  public void removeVertex(V toRemove)
  {
    if(this.contains(toRemove))
    {
      map.remove(toRemove);
      for(V v : map.keySet())
      {
        while(map.get(v).contains(toRemove))
        {
            map.get(v).remove(toRemove);
        }
      }
    }
  }

  /**
   * Removes an edge from the graph.
   *
   * <p>Postcondition: If from and to were in the graph and (from,
   * to) was an edge in the graph, then numEdges = numEdges' - 1
   */
  public void removeEdge(V from, V to)
  {
    while(this.hasEdge(from,to))
    {
      map.get(from).remove(to);
    }
  }

  /**
   * Tells whether there is a path connecting two given vertices.  A
   * path exists from vertex A to vertex B iff A and B are in the
   * graph and there exists a sequence x_1, x_2, ..., x_n where:
   *
   * <ul>
   * <li>x_1 = A
   * <li>x_n = B
   * <li>for all i from 1 to n-1, (x_i, x_{i+1}) is an edge in the graph.
   * </ul>
   *
   * It therefore follows that, if vertex A is in the graph, there
   * is a path from A to A.
   *
   * @param from the source vertex
   * @param to the destination vertex
   * @return true iff there is a path from 'from' to 'to' in the graph.
   */
  public boolean hasPath(V from, V to)
  {
    return this.pathLength(from,to)!= Integer.MAX_VALUE;
  }

  /**
   * Gets the length of the shortest path connecting two given
   * vertices.  The length of a path is the number of edges in the
   * path.
   *
   * <ol>
   * <li>If from = to, shortest path has length 0
   * <li>Otherwise, shortest path length is length of the shortest
   * possible path connecting from to to.
   * </ol>
   *
   * @param from the source vertex
   * @param to the destination vertex
   * @return the length of the shortest path from 'from' to 'to' in
   * the graph.  If there is no path, returns Integer.MAX_VALUE
   */
  public int pathLength(V from, V to)
  {
    if(!map.containsKey(from)){return Integer.MAX_VALUE;}
    Map<V,Integer> dist_map = new HashMap<V,Integer>();
    Queue<V> Q = new LinkedList<V>();
    V temp;

    Q.add(from);
    dist_map.put(from,0);
    while(Q.size() != 0)
    {
        temp = Q.remove();
        for(V adj : map.get(temp))
        {
          if(adj == to){return dist_map.get(temp)+1;}
          if(!dist_map.containsKey(adj))
          {
            dist_map.put(adj,dist_map.get(temp)+1);
            Q.add(adj);
          }
        }
    }
    if(!dist_map.containsKey(to)){return Integer.MAX_VALUE;}
    return dist_map.get(to);
  }


  /**
   * Returns the vertices along the shortest path connecting two
   * given vertices.  The vertices should be given in the order x_1,
   * x_2, x_3, ..., x_n, where:
   *
   * <ol>
   * <li>x_1 = from
   * <li>x_n = to
   * <li>for all i from 1 to n-1: (x_i, x_{i+1}) is an edge in the graph.
   * </ol>
   *
   * @param from the source vertex
   * @param to the destination vertex
   * @return an Iterable collection of vertices along the shortest
   * path from 'from' to 'to'.  The Iterable should include the
   * source and destination vertices.
   */
  public Iterable<V> getPath(V from, V to)
  {
    ArrayList<V> shortest_path = new ArrayList<V>();
    if(!map.containsKey(from)){return shortest_path;}

    Map<V,V> parent_map = new HashMap<V,V>();
    Queue<V> Q = new LinkedList<V>();

    V temp;
    Q.add(from);
    parent_map.put(from,from);
    while(Q.size() != 0)
    {
        temp = Q.remove();
        for(V adj: map.get(temp))
        {
          if(!parent_map.containsKey(adj))
          {
            parent_map.put(adj,temp);
            Q.add(adj);
          }
          if(adj == to){

            shortest_path.add(0,to);
            while(to != from)
            {
              to = parent_map.get(to);
              shortest_path.add(0,to);
            }
            return shortest_path;
          }
       }
    }
    return shortest_path;
  }
}
