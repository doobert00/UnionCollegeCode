package edu.union.adt.graph;
/**
* A factory class with a method to return a graph.
*
* @author Zach Dubinsky
* @version 1
**/
public class GraphFactory
{
  static public <V> Graph<V> createGraph()
  {
    return new ZachGraph<V>();
  }
}
